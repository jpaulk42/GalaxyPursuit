//
//  Level02.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 5/13/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class Level02: SKScene, SKPhysicsContactDelegate
{
	var player: Player!
	var hud: HUD?
	let gameWorld = GameWorld()

	var pos: CGPoint?
	var timer = Timer()

	var time = 45

	override func didMove(to view: SKView)
	{
		canShoot = true
		gamePaused = false
		gameWorld.setBG(self)
		self.physicsWorld.contactDelegate = self
		pos = CGPoint(x: 60, y: 50)
		player = Player(color: SKColor.green, position: pos!, gravity: false, categoryBitmask: ColliderType.player.rawValue, rotates: false, health: 100.0, strength: 10.0)
		player.addAsChildTo(self)

		gameWorld.spawnEnemyForever(addTo: self, moveAndShootTowards: player.position, spawnAlongSide: SpawnOnSide.Top, waitFor: 3.7, waitToShootFor: 3.5)
		gameWorld.spawnEnemyForever(addTo: self, moveAndShootTowards: player.position, spawnAlongSide: SpawnOnSide.Right, waitFor: 5.5, waitToShootFor: 4.5)
        gameWorld.spawnRandomPowerUpForever(at: CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5) , addTo: self, initialWaitToSpawn: 5)
		hud = HUD(node: self)
		hud!.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
		self.addChild(hud!)

		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Level02.updateTimer), userInfo: nil, repeats: true)
	}

	override func update(_ currentTime: TimeInterval)
	{
		hud?.updateHealthTo(Int(player.health))

		gameWorld.handlePlayerContact(player, node: self)

		gameWorld.handleAmmo(player, hud: hud!)
	}

	func didBegin(_ contact: SKPhysicsContact)
	{
        gameWorld.handlePhysicsContacts(contact, parent: self, player: player)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		for touch in touches
		{
			let node = self.atPoint(touch.location(in: self))
			if node.name == "ammo" && player.ammo < 10
			{
				canShoot = false
				player.reloadAmmo(hud!)
				player.ammo = 10
			}
			else if node.name == "pause" && gamePaused == false
			{
				self.speed = 0.0
				timer.invalidate()
				gamePaused = true
			}
			else if node.name == "pause" && gamePaused == true
			{
				self.speed = 1.0
				timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Level02.updateTimer), userInfo: nil, repeats: true)
				gamePaused = false
			}
			else if canShoot && !gamePaused
			{
				player.ammo -= 1
				player.playerShoot(player.position, addToNode: self, touchLocation: touch.location(in: self), hud: hud!)
			}
			else if node.name == "next"
			{
				//let next = Level02()
				//gameWorld.loadNextLevel(next, selfNode: self, player: player)
			}
			else if node.name == "quit"
			{
				let main = GameScene()
				main.size = self.size
				self.view?.presentScene(main, transition: SKTransition.fade(withDuration: 1))
			}
            else if node.name == "player"
            {
                self.player.activatePlayerPowerUp(currentScene: self)
            }
		}
	}

	func updateTimer()
	{
		time -= 1
		hud?.updateTimerTo(String(time))
		gameWorld.handleWin(self, timer: timer, time: time)
	}
}
