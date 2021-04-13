//
//  Character.swift
//  DevilSouls iOS
//
//  Created by Marek Przybolewski on 13/04/2021.
//

import SpriteKit

class Character: SKNode {
    init(image: SKSpriteNode) {
        super.init()
        self.position = CGPoint(x: 0, y: 0)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "IcyTowerCharacter"), size: CGSize(width: 70, height: 120))
        image.size.width = 70
        image.size.height = 120
        self.addChild(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
