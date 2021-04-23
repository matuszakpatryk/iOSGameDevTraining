//
//  GameScene.swift
//  DevilSouls iOS
//
//  Created by Patryk Matuszak on 13/04/2021.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene {
    var motion = CMMotionManager()

    var background: SKSpriteNode!
    var character: SKSpriteNode!
    var floor: SKSpriteNode!
    
    var rightScale: CGFloat = 0
    var leftScale: CGFloat = 0
    
    private var isCharacterFlying: Bool = true
    
    override func didMove(to view: SKView) {
        self.setupCharacter()
        self.setupFloor()
        self.setupScene()
        
        self.physicsWorld.contactDelegate = self
        
        rightScale = character.xScale
        leftScale = character.xScale * (-1)
        
        if motion.isAccelerometerAvailable {
            self.motion.startAccelerometerUpdates()
        }
    }
    
    func moveLeft() {
        character.xScale = leftScale
    }
    
    func moveRight() {
        character.xScale = rightScale
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if !self.isCharacterFlying {
            self.isCharacterFlying = true
            character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        }
        
        if let accelerometerData = motion.accelerometerData {
            if accelerometerData.acceleration.x < 0 {
                moveLeft()
                character.physicsBody?.applyImpulse(CGVector(dx: accelerometerData.acceleration.x * 5, dy: 0))
                if character.position.x <= -1 {
                    character.position.x = self.size.width + 1
                }
            } else if accelerometerData.acceleration.x > 0.02 {
                moveRight()
                character.physicsBody?.applyImpulse(CGVector(dx: accelerometerData.acceleration.x * 5, dy: 0))
                if character.position.x >= self.size.width + 1 {
                    character.position.x = -1
                }
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
        self.character.physicsBody?.allowsRotation = false
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
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategories.characterCategory | PhysicsCategories.floorCategory {
            self.isCharacterFlying = false
        }
    }
}
