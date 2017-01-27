//
//  Torpedo.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 1/17/17.
//  Copyright © 2017 James Paulk. All rights reserved.
//

import SpriteKit

class Torpedo: SKShapeNode
{
    let shootSpeed: CGFloat = 400.0
    
    init(position: CGPoint)
    {
        let rect = CGRect(x: 0, y: 0, width: 16, height: 16)
        super.init()
        self.path = CGPath(ellipseIn: rect, transform: nil)
        
        self.fillColor = .cyan
        self.strokeColor = .cyan
        self.glowWidth = 3.0
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: path!)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = ColliderType.torpedo.rawValue
        self.physicsBody?.collisionBitMask = ColliderType.enemy.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.largeEnemy.rawValue | ColliderType.enemyProjectile.rawValue
        self.physicsBody?.contactTestBitMask = ColliderType.enemy.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.largeEnemy.rawValue | ColliderType.enemyProjectile.rawValue
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
