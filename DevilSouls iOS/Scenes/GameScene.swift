//
//  GameScene.swift
//  DevilSouls iOS
//
//  Created by Patryk Matuszak on 13/04/2021.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    var background: SKSpriteNode!
    var character: SKSpriteNode!
    var floor: SKSpriteNode!
    
    var leftArrow: SKSpriteNode!
    var upArrow: SKSpriteNode!
    var rightArrow: SKSpriteNode!
    
    var rightScale: CGFloat = 0
    var leftScale: CGFloat = 0
    var characterAnimationAction: SKAction?
    var characterAnimation = [SKTexture]()
    
    private var touchLeft = false
    private var touchRight = false
    private var touchUp = false
    
    private var isCharacterFlying: Bool = true
    
    override func didMove(to view: SKView) {
        self.setupCharacter()
        self.setupFloor()
        self.setupController()
        
        self.physicsWorld.contactDelegate = self
        
        let characterAtlas = SKTextureAtlas(named: "character")
        
        for index in 1...characterAtlas.textureNames.count {
            let imageName = String(format: "character%1d", index)
            characterAnimation += [characterAtlas.textureNamed(imageName)]
        }
        
        characterAnimationAction = SKAction.repeatForever(SKAction.animate(with: characterAnimation, timePerFrame: 0.1))
        rightScale = character.xScale
        leftScale = character.xScale * (-1)
        self.setupScene()
        
    } 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                if name == NodeType.leftArrow.rawValue {
                    touchLeft = true
                    character.xScale = leftScale
                    if character.action(forKey: "animation") == nil, let animation = characterAnimationAction {
                        character.run(animation, withKey: "animation")
                    }
                }
                if name == NodeType.rightArrow.rawValue {
                    touchRight = true
                    character.xScale = rightScale
                    if character.action(forKey: "animation") == nil, let animation = characterAnimationAction {
                        character.run(animation, withKey: "animation")
                    }
                }
                if name == NodeType.upArrow.rawValue {
                    touchUp = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp = false
        touchRight = false
        touchLeft = false
        character.removeAction(forKey: "animation")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if touchLeft {
            let moveAction: SKAction = SKAction.moveBy(x: -1, y: 0, duration: 0.5)
            character.run(moveAction)
        }
        
        if touchRight {
            let moveAction = SKAction.moveBy(x: 1, y: 0, duration: 0.5)
            character.run(moveAction)
        }
        
        if touchUp {
            if !self.isCharacterFlying {
                self.isCharacterFlying = true
                let moveAction: SKAction = SKAction.moveBy(x: 0, y: 300, duration: 0.5)
                character.run(moveAction)
            }
        }
    }
    
    private func setupScene() {
        self.background = SKSpriteNode(imageNamed: "Background")
        self.background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.background.size = CGSize(width: self.frame.width, height: self.frame.height)
        self.background.zPosition = -1
        addChild(self.background)
    }
    
    private func setupCharacter() {
        self.character = SKSpriteNode(imageNamed: "IcyTowerCharacter")
        self.character.size = CGSize(width: 70, height: 120)
        self.character.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.character.physicsBody = SKPhysicsBody(rectangleOf: self.character.size)
        self.character.physicsBody?.categoryBitMask = PhysicsCategories.characterCategory
        self.character.physicsBody?.contactTestBitMask = PhysicsCategories.floorCategory
        self.character.physicsBody?.collisionBitMask = PhysicsCategories.floorCategory
        self.addChild(self.character)
    }
    
    private func setupFloor() {
        self.floor = SKSpriteNode(imageNamed: "Platform")
        self.floor.size = CGSize(width: self.frame.width, height: 30)
        self.floor.position = CGPoint(x: self.frame.midX, y: self.frame.minY + self.frame.height / 7)
        self.floor.physicsBody = SKPhysicsBody(rectangleOf: self.floor.size)
        self.floor.physicsBody?.categoryBitMask = PhysicsCategories.floorCategory
        self.floor.physicsBody?.isDynamic = false
        self.addChild(self.floor)
    }
    
    private func setupController() {
        let arrowWidth: CGFloat = 30
        self.leftArrow = SKSpriteNode(imageNamed: "Arrow")
        self.leftArrow.size = CGSize(width: arrowWidth, height: 40)
        self.leftArrow.position = CGPoint(x: self.frame.midX - (arrowWidth * 2), y: self.frame.minY + 50)
        self.leftArrow.zRotation = .pi
        self.leftArrow.name = NodeType.leftArrow.rawValue
        self.addChild(leftArrow)
        
        self.upArrow = SKSpriteNode(imageNamed: "Arrow")
        self.upArrow.size = CGSize(width: arrowWidth, height: 40)
        self.upArrow.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 80)
        self.upArrow.zRotation = .pi / 2
        self.upArrow.name = NodeType.upArrow.rawValue
        self.addChild(upArrow)
        
        self.rightArrow = SKSpriteNode(imageNamed: "Arrow")
        self.rightArrow.size = CGSize(width: arrowWidth, height: 40)
        self.rightArrow.position = CGPoint(x: self.frame.midX + (arrowWidth * 2), y: self.frame.minY + 50)
        self.rightArrow.name = NodeType.rightArrow.rawValue
        self.addChild(rightArrow)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategories.characterCategory | PhysicsCategories.floorCategory {
            self.isCharacterFlying = false
        }
    }
}
