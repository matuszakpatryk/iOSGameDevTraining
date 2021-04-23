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
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .aspectFill
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.presentScene(scene)
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}
