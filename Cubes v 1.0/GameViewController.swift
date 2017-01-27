//
//  GameViewController.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/24/16.
//  Copyright (c) 2016 James Paulk. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    override func viewDidLoad()
	{
        super.viewDidLoad()

        let scene = GameScene()

            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
			skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
			scene.size = UIScreen.main.bounds.size
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
    }

    override var shouldAutorotate : Bool
	{
        return true
    }

//    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
//	{
//       return .landscapeLeft
//    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool
	{
        return true
    }
}
