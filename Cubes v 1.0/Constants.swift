//
//  Constants.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 4/7/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

let playerSize = CGSize(width: 80.0, height: 40.0)

enum ColliderType: UInt32
{
	case player = 1
	case playerProjectile = 2
	case enemy = 4
	case enemyProjectile = 8
	case largeEnemy = 16
	case border = 32
	case playerProjectileExplosion = 64
    case enemyBoss = 128
    case powerUp = 256
    case laser = 512
    case torpedo = 1024
    case shield = 2048
}

enum SpawnOnSide: String
{
	case Left = "left"
	case Right = "right"
	case Top = "top"
	case Bottom = "bottom"
}

enum PowerUpType: Int
{
    case Laser = 0
    case Torpedo = 1
    case Shield = 2
    case InterceptionCannon = 3
}

struct Levels
{
	static let LevelOne = "Level01"
	static let LevelTwo = "Level02"
	static let LevelThree = "Level03"
}

func explosion(addToNode node: SKNode, bullet: PlayerProjectile?, location: CGPoint, physicsBody: Bool)
{
	let emitter = SKEmitterNode(fileNamed: "Explode")
	emitter!.position = location
	emitter!.zPosition = 3

	if physicsBody == true
	{
		emitter?.physicsBody = SKPhysicsBody(circleOfRadius: 15.0)
		emitter?.physicsBody?.affectedByGravity = false
		emitter?.physicsBody?.categoryBitMask = ColliderType.playerProjectileExplosion.rawValue
		emitter?.physicsBody?.collisionBitMask = ColliderType.enemyBoss.rawValue | ColliderType.enemyProjectile.rawValue | ColliderType.powerUp.rawValue
		emitter?.physicsBody?.contactTestBitMask = ColliderType.enemyProjectile.rawValue | ColliderType.powerUp.rawValue
	}
	node.addChild(emitter!)
	
	let remove = SKAction.run
	{
		emitter?.removeFromParent()
	}
	node.run(SKAction.sequence([SKAction.wait(forDuration: 0.7), remove]))
}

func torpedoExplosion(addTo node: SKNode, location: CGPoint)
{
    let emitter = SKEmitterNode(fileNamed: "TorpedoExplosion")
    emitter?.position = location
    emitter?.zPosition = 3
    emitter?.physicsBody = SKPhysicsBody(circleOfRadius: 45.0)
    emitter?.physicsBody?.affectedByGravity = false
    emitter?.physicsBody?.categoryBitMask = ColliderType.torpedo.rawValue
    emitter?.physicsBody?.contactTestBitMask = ColliderType.enemyBoss.rawValue | ColliderType.enemy.rawValue | ColliderType.largeEnemy.rawValue | ColliderType.enemyProjectile.rawValue
    emitter?.physicsBody?.collisionBitMask = ColliderType.enemyBoss.rawValue | ColliderType.enemy.rawValue | ColliderType.largeEnemy.rawValue | ColliderType.enemyProjectile.rawValue
    node.addChild(emitter!)
    let remove = SKAction.run { 
        emitter?.removeFromParent()
    }
    node.run(SKAction.sequence([SKAction.wait(forDuration: 0.7), remove]))
}
