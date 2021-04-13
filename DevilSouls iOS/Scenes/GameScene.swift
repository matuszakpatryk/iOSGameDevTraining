//
//  GameScene.swift
//  DevilSouls iOS
//
//  Created by Patryk Matuszak on 13/04/2021.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    var background = SKSpriteNode(imageNamed: "Background")
    var character = Character(image: SKSpriteNode(imageNamed: "IcyTowerCharacter"))
    var floor = Floor(image: SKSpriteNode(imageNamed: "Platform"))
    
    private var touchLeft = false
    private var touchRight = false
    private var touchUp = false
    
    
    override func didMove(to view: SKView) {
        self.setupBackground()
        
        self.addChild(self.character)
        self.addChild(self.floor)
        
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
    
    private func setupBackground() {
        self.background.position = CGPoint(x: 0, y: 0)
        self.background.size.width = self.size.width
        self.background.size.height = self.size.height
        self.background.zPosition = -1
        addChild(self.background)
    }
}
