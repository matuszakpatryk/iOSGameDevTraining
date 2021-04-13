//
//  GameViewController.swift
//  DevilSouls iOS
//
//  Created by Patryk Matuszak on 13/04/2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        let scene = GameScene(fileNamed: "GameScene")
        let skView = view as! SKView
        skView.presentScene(scene)
    }
}
