//
//  GameScene.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/24/16.
//  Copyright (c) 2016 James Paulk. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
	var pos: CGPoint?

    override func didMove(to view: SKView)
	{
		pos = CGPoint(x: self.size.width * 0.5, y: self.frame.height * 0.5)
		self.backgroundColor = SKColor(red: 0.5, green: 1.5, blue: 2.0, alpha: 1.0)
		self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
		let sprite = Sprite(texture: nil, size: CGSize(width: 50, height: 50), position: pos!, gravity: false, categoryBitmask: 1, rotates: false)
		sprite.color = SKColor.red
		sprite.addAsChildTo(self)

		sprite.name = "bobby"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
        for touch in touches
		{
			let node = self.atPoint(touch.location(in: self))
			if node.name == "bobby"
			{
				let level1 = Level01()
				level1.size = self.size
				self.view?.presentScene(level1, transition: SKTransition.fade(withDuration: 1))
			}
        }
    }

	
}
