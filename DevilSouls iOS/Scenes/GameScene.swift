//
//  GameScene.swift
//  DevilSouls iOS
//
//  Created by Patryk Matuszak on 13/04/2021.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    var character = SKSpriteNode()
    private var touchLeft = false
    private var touchRight = false
    private var touchUp = false
    
    
    override func didMove(to view: SKView) {
        if let objectNode = self.childNode(withName: "Character") as? SKSpriteNode {
            character = objectNode
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                if name == "LeftArrow" {
                    touchLeft = true
                }
                if name == "RightArrow" {
                    touchRight = true
                }
                if name == "UpArrow" {
                    touchUp = true
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp = false
        touchRight = false
        touchLeft = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if touchLeft {
            let moveAction: SKAction = SKAction.moveBy(x: -1, y: 0, duration: 0.5)
            character.run(moveAction)
        }
        
        if touchRight {
            let moveAction: SKAction = SKAction.moveBy(x: 1, y: 0, duration: 0.5)
            character.run(moveAction)
        }
        
        if touchUp {
            let moveAction: SKAction = SKAction.moveBy(x: 0, y: 10, duration: 0.5)
            character.run(moveAction)
        }
    }
}
