//
//  Sprite.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/24/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class Sprite: SKSpriteNode
{
	init(texture: SKTexture?, size: CGSize, position: CGPoint, gravity: Bool,  categoryBitmask: UInt32, rotates: Bool)
	{
		super.init(texture: texture, color: UIColor.clear, size: size)
		self.position = position
		if texture != nil
		{
			self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width - 5, height: size.height - 5))
		}
		else
		{
			self.physicsBody = SKPhysicsBody(rectangleOf: size)
		}
		self.physicsBody?.affectedByGravity = gravity
		self.physicsBody?.categoryBitMask = categoryBitmask
		self.physicsBody?.allowsRotation = rotates
	}

	func addAsChildTo(_ node: SKNode)
	{
		node.addChild(self)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
