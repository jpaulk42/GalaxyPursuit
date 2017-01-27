//
//  Player.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/26/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit
import CoreMotion

class Player: Sprite
{
	var health: Double
	var strength: Double
	var ammo: Int = 0
	var playerHitByProjectile: Bool = false
	var playerHitByEnemy: Bool = false
    var playerHitByLEProjectile = false
    var hasPowerUpEquipped: Bool = false
    var equippedPowerUp: PowerUp?
    var equippedPowerUpDamage = 0.0
    var torpedoActivated = false
    
    public static let timeToEnterScene: Double = 1.21

	let playerTexture = SKTexture(imageNamed: "PlayerShip")

	init(color: UIColor, position: CGPoint, gravity: Bool, categoryBitmask: UInt32, rotates: Bool, health: Double, strength: Double)
	{
		self.health = health
		self.strength = strength
		self.ammo = 15
		super.init(texture: playerTexture, size: playerTexture.size(), position: position, gravity: gravity, categoryBitmask: categoryBitmask, rotates: rotates)
        self.name = "player"
		self.physicsBody?.mass = 100.0
		self.physicsBody?.collisionBitMask = ColliderType.enemy.rawValue | ColliderType.enemyProjectile.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.border.rawValue
		self.physicsBody?.contactTestBitMask = ColliderType.enemy.rawValue | ColliderType.enemyProjectile.rawValue | ColliderType.enemyBoss.rawValue
		self.zPosition = 2
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	func playerTookDamage(_ amount: Double)
	{
		health -= amount
	}

	func setPlayerVelocity(dx: CGFloat, dy: CGFloat)
	{
		self.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
	}

	func playerShoot(_ pos: CGPoint, addToNode node: SKNode, touchLocation: CGPoint, hud: HUD)
	{
        if self.torpedoActivated
        {
            var pedo = Torpedo(position: self.position)
            pedo.name = "pedo"
            let dx = touchLocation.x
            let dy = touchLocation.y
            pedo.zPosition = 0
            let distance = sqrt(pow(touchLocation.x - pos.x, 2) + pow(touchLocation.y - pos.y, 2))
            let duration: TimeInterval = Double(distance / (pedo.shootSpeed))
            
            let movePedo = SKAction.move(to: CGPoint(x: dx, y: dy) , duration: duration)
            let removePedo = SKAction.run {
                pedo.removeFromParent()
            }
            let explode = SKAction.run {
                
                torpedoExplosion(addTo: node, location: touchLocation)
            }
            node.addChild(pedo)
            pedo.run(SKAction.sequence([movePedo, explode, removePedo]))
            self.torpedoActivated = false
        }
        else
        {
            let size = CGSize(width: 9.0, height: 9.0)

            var bullet: PlayerProjectile? = PlayerProjectile(texture: nil, size: size, position: pos, gravity: false, categoryBitmask: ColliderType.playerProjectile.rawValue, rotates: false)
            bullet?.color = SKColor.red
            let dx = touchLocation.x
            let dy = touchLocation.y

            bullet!.name = "bullet"
            bullet!.physicsBody?.collisionBitMask = ColliderType.enemy.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.largeEnemy.rawValue | ColliderType.powerUp.rawValue
            bullet?.physicsBody?.contactTestBitMask = ColliderType.enemy.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.powerUp.rawValue
            bullet?.zPosition = 0

            let distance = sqrt(pow(touchLocation.x - pos.x, 2) + pow(touchLocation.y - pos.y, 2))
            let duration: TimeInterval = Double(distance / (bullet?.shootSpeed)!)

            let moveBullet = SKAction.move(to: CGPoint(x: dx , y: dy ), duration: duration)
            let removeBullet = SKAction.run
            {
                bullet?.removeFromParent()
                bullet = nil
            }

            let explode = SKAction.run
            {
                explosion(addToNode: node, bullet: bullet!, location: touchLocation, physicsBody: true)
            }

            node.addChild(bullet!)
            bullet!.run(SKAction.sequence([moveBullet, explode, removeBullet]))
            //self.ammo -= 1
        }
	}

	func reloadAmmo(_ hud: HUD)
	{
		hud.reloadLabel.isHidden = false
		let wait = SKAction.wait(forDuration: 2.5)
		let reload = SKAction.run
		{
			canShoot = true
			hud.reloadLabel.isHidden = true
		}

		self.run(SKAction.sequence([wait, reload]))
	}
    
    func activatePlayerPowerUp(currentScene: SKNode)
    {
        if hasPowerUpEquipped
        {
            equippedPowerUpDamage = (equippedPowerUp?.damage)!
            if let powerUp = equippedPowerUp
            {
                switch (equippedPowerUp?.powerUpType!)!
                {
                case .Laser: 
                    powerUp.activateLaser()
                case .Torpedo:
                    powerUp.activateTorpedo(for: self)
                case .Shield:
                    powerUp.activateShield(player: self, addTo: currentScene)
                case .InterceptionCannon:
                    powerUp.activateInterceptionCannon(addToNode: currentScene, spawnAt: self.position)
                }
            }
        }
        self.hasPowerUpEquipped = false
        self.equippedPowerUp = nil
    }
    
//    func handleShieldDurability()
//    {
//        if equippedPowerUp?.powerUpType == .Shield
//        {
//            if (equippedPowerUp?.damage)! <= 0.0
//            {
//                equippedPowerUp?.removeFromParent()
//                equippedPowerUp = nil
//                hasPowerUpEquipped = false
//            }
//        }
//    }

	func movePlayerWithDeviceMotion(_ motionManager: CMMotionManager, playerNode: Player)
	{
		if let accelData = motionManager.accelerometerData
		{
			var dx = CGFloat()
			var dy = CGFloat()

			if let accelX: CGFloat = CGFloat(accelData.acceleration.x) * 500
			{
				if accelData.acceleration.x < 1.0
				{
					dx = -accelX
				}
			}

			if let accelY: CGFloat = CGFloat(accelData.acceleration.y) * 500
			{
				if accelData.acceleration.y > 0.1
				{
					dy = accelY
				}
				else if accelData.acceleration.y < 0.1
				{
					dy = accelY
				}
			}
			playerNode.setPlayerVelocity(dx: dy, dy: dx)
		}
	}
}
