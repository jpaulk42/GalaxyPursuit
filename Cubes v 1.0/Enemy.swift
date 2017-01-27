//
//  Enemy.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/29/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class Enemy: Sprite
{
	var health: Double
	var shootSpeed: Double = 85
	let enemyTexture = SKTexture(imageNamed: "AlienShip")
	var enemyHit: Bool = false

	init(pos: CGPoint, shootTrajectory: CGPoint, addToNode node: SKNode, moveTowardsPosition: CGPoint, waitToShootFor: TimeInterval)
	{
		self.health = 50
		let color = SKColor.clear
		super.init(texture: enemyTexture, size: enemyTexture.size(), position: pos, gravity: false, categoryBitmask: ColliderType.enemy.rawValue, rotates: false)
        self.setScale(0.85)
		self.color = color
		self.physicsBody?.collisionBitMask = ColliderType.player.rawValue | ColliderType.playerProjectile.rawValue
		self.physicsBody?.contactTestBitMask = ColliderType.player.rawValue | ColliderType.playerProjectile.rawValue
		self.zPosition = 3
		self.name = "enemy"
		let moveEnemy = SKAction.move(to: moveTowardsPosition, duration: 14.5)

		let wait = SKAction.wait(forDuration: waitToShootFor)
		let shoot = SKAction.run
		{
            self.enemyShoot(fromPosition: self.position, addToNode: node, trajectory: shootTrajectory)
		}
		let waitAndShoot = SKAction.sequence([wait, shoot])

		node.addChild(self)
		self.run(moveEnemy)
		self.run(SKAction.repeatForever(waitAndShoot))
	}

	fileprivate func enemyShoot(fromPosition pos: CGPoint, addToNode node: SKNode, trajectory: CGPoint)
	{
		let theColor = SKColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 1.0)
		let theSize = CGSize(width: 5.0, height: 5.0)
		let bullet = PlayerProjectile(texture: nil, size: theSize, position: pos, gravity: false, categoryBitmask: ColliderType.enemyProjectile.rawValue, rotates: false)
		bullet.color = theColor
		bullet.physicsBody?.contactTestBitMask = ColliderType.player.rawValue
		bullet.physicsBody?.collisionBitMask = ColliderType.player.rawValue
		bullet.zPosition = 2
		bullet.name = "enemy"

		let distance = sqrt(pow(trajectory.x - pos.x, 2) + pow(trajectory.y - pos.y, 2))
		let duration: TimeInterval = Double(distance) / self.shootSpeed

		let moveBullet = SKAction.move(to: trajectory, duration: duration)
		let removeBullet = SKAction.removeFromParent()

		node.addChild(bullet)
		bullet.run(SKAction.sequence([moveBullet, removeBullet]))
	}

	func enemyTookDamage(_ amount: Double)
	{
		health -= amount 
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
