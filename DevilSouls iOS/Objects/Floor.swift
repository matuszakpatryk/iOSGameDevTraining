//
//  Floor.swift
//  DevilSouls iOS
//
//  Created by Marek Przybolewski on 13/04/2021.
//

import SpriteKit

class Floor: SKNode {
    init(image: SKSpriteNode) {
        super.init()
        self.position = CGPoint(x: 0, y: -UIScreen.main.bounds.height/4)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Platform"), size: CGSize(width: UIScreen.main.bounds.width, height: 30))
        image.size.width = UIScreen.main.bounds.width
        image.size.height = 30
        self.physicsBody?.isDynamic = false
        self.addChild(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
