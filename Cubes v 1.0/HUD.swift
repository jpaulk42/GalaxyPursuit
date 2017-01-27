//
//  HUD.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/31/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class HUD: SKNode
{
	let health = SKLabelNode(text: "Hull: 100%")
	let timer = SKLabelNode(text: "Engine Cooling: 0")
	let ammo = SKLabelNode(text: "Ammo: 15")
	let pauseLabel = SKLabelNode(text: "Pause")
	var pauseBG = SKShapeNode()
	let reloadLabel = SKLabelNode(text: "Reloading!")

	init(node: SKNode)
	{
		super.init()

		health.fontColor = UIColor.white
		health.fontSize = 30.0
		health.zPosition = 10
		health.position = CGPoint(x: node.frame.width - 75, y: 10)
		node.addChild(health)

		timer.fontColor = UIColor.white
		timer.fontSize = 30.0
		timer.zPosition = 10
		timer.position = CGPoint(x: 120, y: node.frame.height - 30)
		node.addChild(timer)

		ammo.fontColor = UIColor.white
		ammo.fontSize = 30.0
		ammo.zPosition = 10
		ammo.position = CGPoint(x: 75, y: 10)
		ammo.name = "ammo"
		node.addChild(ammo)

		pauseLabel.fontColor = UIColor.white
		pauseLabel.fontSize = 30.0
		pauseLabel.zPosition = 10
		pauseLabel.position = CGPoint(x: node.frame.width - 43, y: node.frame.height - 30)
		pauseLabel.name = "pause"
		node.addChild(pauseLabel)

		pauseBG = SKShapeNode(rect: CGRect(x: node.frame.width - 75, y: node.frame.height - 34, width: 80, height: 30))
		pauseBG.fillColor = UIColor.clear
		pauseBG.strokeColor = UIColor.clear
		pauseBG.name = "pause"
		node.addChild(pauseBG)

		reloadLabel.fontColor = UIColor.red
		reloadLabel.fontSize = 40.0
		reloadLabel.zPosition = 10
		reloadLabel.position = CGPoint(x: node.frame.width * 0.5, y: node.frame.height * 0.5 + 30)
		reloadLabel.isHidden = true
		node.addChild(reloadLabel)
	}

	func updateHealthTo(_ amount: Int)
	{
		health.text = "Hull: \(amount)%"
	}

	func  updateTimerTo(_ amount: String)
	{
		timer.text = "Engine Cooling: \(amount)"
	}

	func updateAmmoTo(_ amount: Int)
	{
		ammo.text = "Ammo: \(amount)"
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
