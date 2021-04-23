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
    var label = SKLabelNode(text: "SHEPARD GNOJEK")
    var motion = CMMotionManager()
    var character = SKSpriteNode()
    var characterAnimation = [SKTexture]()
    var characterAnimationAction: SKAction?
    var rightScale: CGFloat = 0
    var leftScale: CGFloat = 0
    private var touchLeft = false
    private var touchRight = false
    private var touchUp = false
    
    
    override func didMove(to view: SKView) {
        addChild(label)
        
        label.position = CGPoint(x: view.frame.width / 2 , y: view.frame.height / 2 )
        if let objectNode = self.childNode(withName: "Character") as? SKSpriteNode {
            character = objectNode
        }
        
        let characterAtlas = SKTextureAtlas(named: "character")
        
        for index in 1...characterAtlas.textureNames.count {
            let imageName = String(format: "character%1d", index)
            characterAnimation += [characterAtlas.textureNamed(imageName)]
        }
        
        characterAnimationAction = SKAction.repeatForever(SKAction.animate(with: characterAnimation, timePerFrame: 0.1))
        rightScale = character.xScale
        leftScale = character.xScale * (-1)
        
        if motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 0.5
            self.motion.deviceMotionUpdateInterval = 0.5
            self.motion.startAccelerometerUpdates()
            self.motion.startDeviceMotionUpdates()
            
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let validData = data {
                    print(validData.attitude.yaw)
                    if validData.attitude.yaw < 0.00 {
                        self.moveRight()
                    } else if validData.attitude.yaw > 0.6 {
                        self.moveLeft()
                    } else {
                        self.stop()
                    }
                }
            }
            
        }
    }
    
    func moveLeft() {
        stop()
        touchLeft = true
        character.xScale = leftScale
        if character.action(forKey: "animation") == nil, let animation = characterAnimationAction {
            character.run(animation, withKey: "animation")
        }
    }
    
    func moveRight() {
        stop()
        touchRight = true
        character.xScale = rightScale
        if character.action(forKey: "animation") == nil, let animation = characterAnimationAction {
            character.run(animation, withKey: "animation")
        }
    }
    
    func stop() {
        touchUp = false
        touchRight = false
        touchLeft = false
        character.removeAction(forKey: "animation")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                if name == "UpArrow" {
                    touchUp = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if touchLeft {
            let moveAction: SKAction = SKAction.moveBy(x: -2, y: 0, duration: 0.5)
            character.run(moveAction)
        }
        
        if touchRight {
            let moveAction = SKAction.moveBy(x: 2, y: 0, duration: 0.5)
            character.run(moveAction)
        }
        
        if touchUp {
            let moveAction: SKAction = SKAction.moveBy(x: 0, y: 5, duration: 0.5)
            character.run(moveAction)
        }
    }
}
