//
//  WinNode.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 5/13/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class WinNode: SKSpriteNode
{
	init(node: SKNode)
	{
		let color = SKColor(red: 0.071, green: 0.725, blue: 0.389, alpha: 1.00)
		let size = CGSize(width: 350, height: node.frame.size.height - 40)
		super.init(texture: nil, color: color , size: size)

		let winLabel = SKLabelNode(text: "Your engines are ready!")
		winLabel.fontSize = 30
		winLabel.position = CGPoint(x: 0, y: self.frame.height * 0.5 - 40)
		self.addChild(winLabel)

		let next = SKLabelNode(text: "Warp to Next Level")
		next.fontSize = 25
		next.name = "next"
		next.position = CGPoint(x: 0, y: 0)
		self.addChild(next)

		let nextbg = SKSpriteNode(texture: nil, color: SKColor.clear, size: CGSize(width: 80, height: 20))
		nextbg.name = "next"
		nextbg.position = next.position
		self.addChild(nextbg)

		let quit = SKLabelNode(text: "Main Menu")
		quit.fontSize = 25
		quit.name = "quit"
		quit.position = CGPoint(x: 0, y: -60)
		self.addChild(quit)

		let quitbg = SKSpriteNode(texture: nil, color: SKColor.clear, size: CGSize(width: 80, height: 20))
		quitbg.name = "quit"
		quitbg.position = quit.position
		self.addChild(quitbg)

		self.position = CGPoint(x: node.frame.width * 0.5, y: node.frame.height * 0.5)
		self.zPosition = 20
		self.name = "winNode"
		node.addChild(self)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
