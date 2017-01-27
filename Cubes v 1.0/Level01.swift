//
//  Level01.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 3/26/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

var gamePaused: Bool = false
var canShoot: Bool = true

class Level01: SKScene, SKPhysicsContactDelegate
{
	var player: Player!
	var hud: HUD?
    var largeEnemy: LargeEnemy!
	var pos: CGPoint?
	var timer = Timer()
	var time = 30
    
    let gameWorld = GameWorld()

	override func didMove(to view: SKView)
	{
		canShoot = true
		gamePaused = false
        pos = CGPoint(x: -300, y: 50)
		self.physicsWorld.contactDelegate = self
        self.hud = HUD(node: self)
        gameWorld.setBG(self)
        self.player = Player(color: SKColor.green, position: self.pos!, gravity: false, categoryBitmask: ColliderType.player.rawValue, rotates: false, health: 100.0, strength: 10.0)
        
        self.player.addAsChildTo(self)

        self.gameWorld.waitForPlayerEntry(for: Player.timeToEnterScene, onNode: self) {
            
            self.gameWorld.spawnEnemyForever(addTo: self, moveAndShootTowards: self.player.position, spawnAlongSide: SpawnOnSide.Top, waitFor: 3.0, waitToShootFor: 3.0)
        }
        
       // self.largeEnemy = LargeEnemy(position: CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5), addToNode: self)
        gameWorld.spawnRandomPowerUpForever(at: CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5) , addTo: self, initialWaitToSpawn: 5)

        self.hud!.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
        self.addChild(self.hud!)
       
        self.player.run(SKAction.moveTo(x: self.frame.width * 0.5, duration: 1.2))
        self.gameWorld.waitForPlayerEntry(for: Player.timeToEnterScene, onNode: self)
        {
            //self.largeEnemy.waitAndShoot(for: 1.7, addToNode: self, targetPosition: self.player.position)
        }

        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Level01.updateTimer), userInfo: nil, repeats: true)
    
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
				player.ammo = 15
			}
			else if node.name == "pause" && gamePaused == false
			{
				self.speed = 0.0
                scene?.view?.isPaused = true 
				timer.invalidate()
				gamePaused = true
			}
			else if node.name == "pause" && gamePaused == true
			{
				self.speed = 1.0
                scene?.view?.isPaused = false
				timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Level01.updateTimer), userInfo: nil, repeats: true)
				gamePaused = false
			}
            else if node.name == "next"
            {
                let next = Level02()
                gameWorld.loadNextLevel(next, selfNode: self, player: player)
            }
            else if node.name == "quit"
            {
                let main = GameScene()
                main.size = self.size
                self.view?.presentScene(main, transition: SKTransition.fade(withDuration: 1))
            }
            else if node.name == "player" && player.hasPowerUpEquipped
            {
                self.player.activatePlayerPowerUp(currentScene: self)
            }
			else if player.torpedoActivated || canShoot && !gamePaused && node.name != "player"
			{
				player.ammo -= 1
				player.playerShoot(player.position, addToNode: self, touchLocation: touch.location(in: self), hud: hud!)
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
