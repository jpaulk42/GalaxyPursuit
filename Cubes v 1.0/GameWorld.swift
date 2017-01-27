//
//  Constants.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/26/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class GameWorld
{    
	func setBG(_ node: SKScene)
	{
		node.backgroundColor = SKColor.black
        if let initialStars = SKEmitterNode(fileNamed: "SpaceBG.sks")
        {
            initialStars.position = CGPoint(x: node.frame.width * 0.5, y: node.frame.height * 0.5)
            initialStars.particleBirthRate = 100
            initialStars.particlePositionRange.dx = 1000
            initialStars.numParticlesToEmit = 100
            node.addChild(initialStars)
        }
        if let bgEmitter = SKEmitterNode(fileNamed: "SpaceBG.sks")
        {
            bgEmitter.position = CGPoint(x: node.frame.width + 20, y: node.frame.height * 0.5)
            node.addChild(bgEmitter)
        }
        if let secondaryBGEmitter = SKEmitterNode(fileNamed: "SpaceBG.sks")
        {
            secondaryBGEmitter.position = CGPoint(x: node.frame.width + 20, y: node.frame.height * 0.5)
            secondaryBGEmitter.particleScale = 0.07
            secondaryBGEmitter.speed = -20.0
            node.addChild(secondaryBGEmitter)
        }
	}
    
    func waitForPlayerEntry(for time: Double, onNode node: SKNode, completionHandler: @escaping () -> Void )
    {
        node.run(SKAction.wait(forDuration: time))
        {
            completionHandler()
        }
    }

	func handleWin(_ node: SKNode, timer: Timer, time: Int)
	{
		if time <= 0
		{
			removeAllEnemies(fromNode: node)
			node.speed = 0.0
			node.removeAllActions()
			gamePaused = true
			timer.invalidate()
            
			_ =  WinNode(node: node)
		}
	}
    
    func handleAmmo(_ player: Player, hud: HUD)
    {
        if player.ammo <= 15 && player.ammo >= 1
        {
            hud.updateAmmoTo(player.ammo)
        }
        else if player.ammo < 1
        {
            canShoot = false
            player.reloadAmmo(hud)
            player.ammo = 15
        }
    }
    
    func spawnRandomPowerUpForever(at position: CGPoint, addTo node: SKNode, initialWaitToSpawn duration: TimeInterval)
    {
        var time = duration
       
        let wait = SKAction.wait(forDuration: time)
        let spawnIt = SKAction.run({
            if let randomNum = PowerUpType(rawValue: Int(arc4random_uniform(4)))
            {
                _ = PowerUp(position: position, type: .Torpedo , addTo: node)
            }
            time += 6
        })
        
        let repeatForever = SKAction.repeatForever(SKAction.sequence([wait, spawnIt]))
        node.run(repeatForever)
    }
	
	func loadNextLevel(_ nextLevel: SKScene, selfNode: SKScene, player: Player)
	{
		selfNode.enumerateChildNodes(withName: "winNode") { (node, pointer) in
			node.run(SKAction.fadeOut(withDuration: 0.8))
			node.removeFromParent()
		}
		selfNode.speed = 1
		let movePlayer = SKAction.move(to: CGPoint(x: player.position.x + 500, y: player.position.y), duration: 1.0)
		player.run(movePlayer, completion: { 
			let nextScene = nextLevel
			nextScene.size = selfNode.size
			selfNode.view?.presentScene(nextScene, transition: SKTransition.fade(with: SKColor.green, duration: 1.0))
		}) 
	}

	fileprivate func removeAllEnemies(fromNode node: SKNode)
	{
		node.enumerateChildNodes(withName: "enemy") { (node, pointer) in
			node.removeFromParent()
		}
	}

	func spawnEnemy(addToNode node: SKNode, moveAndShootToPosition: CGPoint, spawnAlongSide: SpawnOnSide, waitToShootFor: TimeInterval)
	{
		let spawnRange: CGFloat
		var randomSpawnPosition: CGPoint = CGPoint.zero

		if spawnAlongSide == SpawnOnSide.Top
		{
			spawnRange = CGFloat(arc4random_uniform(UInt32(node.frame.width)))
			randomSpawnPosition = CGPoint(x: spawnRange, y: node.frame.height + 50)
		}
		else if spawnAlongSide == SpawnOnSide.Right
		{
			spawnRange = CGFloat(arc4random_uniform(UInt32(node.frame.height)))
			randomSpawnPosition = CGPoint(x: node.frame.width + 50, y: spawnRange)
		}
		else if spawnAlongSide == SpawnOnSide.Left
		{
			spawnRange = CGFloat(arc4random_uniform(UInt32(node.frame.height)))
			randomSpawnPosition = CGPoint(x: -50, y: spawnRange)
		}
		else if spawnAlongSide == SpawnOnSide.Bottom
		{
			spawnRange = CGFloat(arc4random_uniform(UInt32(node.frame.width)))
			randomSpawnPosition = CGPoint(x: spawnRange, y: -50)
		}

		_ = Enemy(pos: randomSpawnPosition, shootTrajectory: moveAndShootToPosition, addToNode: node, moveTowardsPosition: moveAndShootToPosition, waitToShootFor: waitToShootFor)
	}

	func spawnEnemyForever(addTo node: SKNode, moveAndShootTowards: CGPoint, spawnAlongSide: SpawnOnSide, waitFor: TimeInterval, waitToShootFor: TimeInterval)
	{
		spawnEnemy(addToNode: node, moveAndShootToPosition: moveAndShootTowards, spawnAlongSide: spawnAlongSide, waitToShootFor: waitToShootFor)
		let wait = SKAction.wait(forDuration: waitFor)
		let spawn = SKAction.run
		{
			self.spawnEnemy(addToNode: node, moveAndShootToPosition: moveAndShootTowards, spawnAlongSide: spawnAlongSide, waitToShootFor: waitToShootFor)
		}
		let sequence = SKAction.sequence([wait, spawn])
		node.run(SKAction.repeatForever(sequence))
	}

	func addBorders(_ width: CGFloat, height: CGFloat, node: SKNode)
	{
		let border = SKSpriteNode(color: UIColor.clear, size: CGSize(width: width, height: height))
		border.physicsBody = SKPhysicsBody(edgeLoopFrom: border.frame)
		border.position = CGPoint(x: node.frame.width * 0.5, y: node.frame.height * 0.5)
		border.zPosition = -1
		border.physicsBody?.categoryBitMask = ColliderType.border.rawValue
		border.physicsBody?.contactTestBitMask = ColliderType.player.rawValue
		border.physicsBody?.isDynamic = false
		node.addChild(border)
	}
//MARK: Physics Contacts
    func handlePhysicsContacts(_ contact: SKPhysicsContact, parent: SKNode, player: Player)
	{
		var firstBody = SKPhysicsBody()
		var secondBody = SKPhysicsBody()

		if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask
		{
			firstBody = contact.bodyA
			secondBody = contact.bodyB
		}
		else
		{
			firstBody = contact.bodyB
			secondBody = contact.bodyA
		}

		//CONTACT TO PLAYER

		if firstBody.categoryBitMask == ColliderType.enemyProjectile.rawValue && secondBody.categoryBitMask == ColliderType.player.rawValue
		{
			
			//use this to handle enemy projectile contact to player node
			if let player = secondBody.node as? Player
			{
				player.playerHitByProjectile = true
			}
			firstBody.node?.removeFromParent()
		}
		else if firstBody.categoryBitMask == ColliderType.enemy.rawValue && secondBody.categoryBitMask == ColliderType.player.rawValue
		{
			//use this to handle enemy contact to player node
			if let player = secondBody.node as? Player
			{
				player.playerHitByEnemy = true
			}
			firstBody.node?.removeFromParent()
		}
		else if firstBody.categoryBitMask == ColliderType.enemyBoss.rawValue && secondBody.categoryBitMask == ColliderType.player.rawValue
		{
			print("contact!")
		}
        else if firstBody.categoryBitMask == ColliderType.playerProjectile.rawValue && firstBody.node?.name == "largeEnemy" && secondBody.categoryBitMask == ColliderType.player.rawValue
        {
            print("large enemy projectile made contact with player!")
            if let player = secondBody.node as? Player
            {
                player.playerHitByLEProjectile = true
            }
            firstBody.node?.removeFromParent()
        }

			//CONTACT WITH PLAYER PROJECTILE

		else if firstBody.categoryBitMask == ColliderType.enemy.rawValue && secondBody.categoryBitMask == ColliderType.playerProjectile.rawValue 
		{
			secondBody.node?.removeFromParent()
			explosion(addToNode: parent, bullet: nil, location: contact.contactPoint, physicsBody: true)

			if let enemy = firstBody.node as? Enemy
			{
				if enemy.health <= 25
				{
					enemy.removeFromParent()
				}
				else
				{
					enemy.health -= 25
				}
			}
		}
        else if firstBody.categoryBitMask == ColliderType.largeEnemy.rawValue && secondBody.categoryBitMask == ColliderType.playerProjectile.rawValue
        {
            secondBody.node?.removeFromParent()
            explosion(addToNode: parent, bullet: nil, location: contact.contactPoint, physicsBody: true)
            if let LE = firstBody.node as? LargeEnemy
            {
                if LE.health <= 25
                {
                    LE.removeFromParent()
                }
                else
                {
                    LE.health -= 25
                }
            }
            
        }
		else if firstBody.categoryBitMask == ColliderType.enemyBoss.rawValue && secondBody.categoryBitMask == ColliderType.playerProjectile.rawValue
		{
			print("contact with enemy boss!")
		}
			// CONTACT WITH PLAYER PROJECTILE EXPLOSION

		else if firstBody.categoryBitMask == ColliderType.playerProjectileExplosion.rawValue && secondBody.categoryBitMask == ColliderType.enemyProjectile.rawValue
		{
			secondBody.node?.removeFromParent()
		}
            
        else if firstBody.categoryBitMask == ColliderType.powerUp.rawValue && secondBody.categoryBitMask == ColliderType.playerProjectileExplosion.rawValue
        {
            player.hasPowerUpEquipped = true
            if let powerUp = firstBody.node as? PowerUp
            {
                player.equippedPowerUp = powerUp
            }
            firstBody.node?.removeFromParent()
            print("power up equipped. type: \((player.equippedPowerUp?.powerUpType)!)")
        }
            
            //contact with power up
        else if firstBody.categoryBitMask == ColliderType.powerUp.rawValue && secondBody.categoryBitMask == ColliderType.playerProjectile.rawValue
        {
            explosion(addToNode: parent, bullet: nil, location: contact.contactPoint, physicsBody: true)
            
                player.hasPowerUpEquipped = true
                if let powerUp = firstBody.node as? PowerUp
                {
                    player.equippedPowerUp = powerUp
                }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            print("power up equipped. type: \((player.equippedPowerUp?.powerUpType)!)")
        }
        
        else if firstBody.categoryBitMask == ColliderType.shield.rawValue && secondBody.categoryBitMask == ColliderType.enemy.rawValue
        {
            explosion(addToNode: parent, bullet: nil, location: contact.contactPoint, physicsBody: false)
            secondBody.node?.removeFromParent()
            if player.equippedPowerUpDamage > 50.0
            {
                player.equippedPowerUpDamage -= 50.0
            }
            else if player.equippedPowerUpDamage < 50.0
            {
                //player.equippedPowerUp?.removeFromParent()
                firstBody.node?.removeFromParent()
                player.equippedPowerUp = nil
                player.hasPowerUpEquipped = false
            }
            print(player.equippedPowerUpDamage)
        }
            //contact with shield
        else if firstBody.categoryBitMask == ColliderType.shield.rawValue && secondBody.categoryBitMask == ColliderType.enemyProjectile.rawValue
        {
            explosion(addToNode: parent, bullet: nil, location: contact.contactPoint, physicsBody: false)
            secondBody.node?.removeFromParent()
            if player.equippedPowerUpDamage > 15.0
            {
                player.equippedPowerUpDamage -= 15.0
            }
            else if player.equippedPowerUpDamage < 50.0
            {
                //player.equippedPowerUp?.removeFromParent()
                firstBody.node?.removeFromParent()
                player.equippedPowerUp = nil
                player.hasPowerUpEquipped = false
            }
            print(player.equippedPowerUpDamage)
        }
        //contact with torpedo
        else if firstBody.categoryBitMask == ColliderType.torpedo.rawValue && secondBody.categoryBitMask == ColliderType.enemyProjectile.rawValue
        {
            print("torpedo contact with enemy projectile")
            secondBody.node?.removeFromParent()
        }
        else if firstBody.categoryBitMask == ColliderType.torpedo.rawValue && secondBody.categoryBitMask == ColliderType.enemy.rawValue
        {
            print("torpedo contact with enemy")
            torpedoExplosion(addTo: parent, location: contact.contactPoint)
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }
        else if firstBody.categoryBitMask == ColliderType.torpedo.rawValue && secondBody.categoryBitMask == ColliderType.largeEnemy.rawValue
        {
            print("torpedo contact with large enemy")
        }
        else if firstBody.categoryBitMask == ColliderType.torpedo.rawValue && secondBody.categoryBitMask == ColliderType.enemyBoss.rawValue
        {
            print("torpedo contact with enemy boss")
        }
	}

	func handlePlayerContact(_ player: Player, node: SKScene)
	{
		if player.playerHitByProjectile == true
		{
			if player.health >= 1
			{
				player.health -= 10
				player.playerHitByProjectile = false
			}
		}
		if player.playerHitByEnemy == true
		{
			if player.health >= 1
			{
				player.health -= 35
				player.playerHitByEnemy = false
			}
		}
        if player.playerHitByLEProjectile == true
        {
            if player.health >= 1
            {
                player.health -= 20
                player.playerHitByLEProjectile = false
            }
        }
		if player.health <= 0
		{
			let gameOverScene = GameOverScene()
			gameOverScene.size = node.size
			node.view?.presentScene(gameOverScene, transition: SKTransition.fade(with: SKColor.red, duration: 1))
		}
	}
}

