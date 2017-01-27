//
//  PowerUp.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 1/12/17.
//  Copyright © 2017 James Paulk. All rights reserved.
//

import SpriteKit

class PowerUp: Sprite
{
    var powerUpType: PowerUpType!
    var damage: Double = 0
    var duration: Int?
    
    init(position: CGPoint, type: PowerUpType, addTo node: SKNode)
    {
        let size = CGSize(width: 25.0, height: 25.0)
        super.init(texture: nil, size: size, position: position, gravity: false, categoryBitmask: ColliderType.powerUp.rawValue, rotates: false)
        self.powerUpType = type
        
        switch type
        {
            case .Laser:
                //self.texture =
                self.color = SKColor.red
                self.damage = 20
                self.duration = 3
                
            case .Torpedo:
                //self.texture =
                self.color = SKColor.blue
                self.damage = 80
                self.duration = 1
                
            case .InterceptionCannon:
                self.color = SKColor.orange
                self.duration = 5
                
            case .Shield:
                self.color = SKColor.purple
                self.damage = 75
                self.duration = 10
        }
        node.addChild(self)
    }
    
    func activateLaser()
    {
        print("laser activated")
    }
    
    func activateShield(player: Player, addTo node: SKNode)
    {
        print("shield activated")
        let shield = SKShapeNode(circleOfRadius: player.size.width * 0.6)
        shield.strokeColor = .cyan
        shield.glowWidth = 2.0
        shield.position = player.position
        shield.zPosition = 3
        shield.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width * 0.6)
        shield.physicsBody?.affectedByGravity = false
        shield.physicsBody?.allowsRotation = false
        shield.physicsBody?.categoryBitMask = ColliderType.shield.rawValue
        shield.physicsBody?.collisionBitMask = ColliderType.enemy.rawValue | ColliderType.enemyProjectile.rawValue
        shield.physicsBody?.contactTestBitMask = ColliderType.enemyProjectile.rawValue | ColliderType.enemy.rawValue
        node.addChild(shield)
    }
    
    func activateTorpedo(for player: Player)
    {
        print("torpedo activated")
        player.torpedoActivated = true
    }
    
    func activateInterceptionCannon(addToNode node: SKNode, spawnAt position: CGPoint)
    {
        if self.powerUpType == PowerUpType.InterceptionCannon
        {print("interception cannon activated")
            var locations: [CGPoint] = [CGPoint]()
            
            node.enumerateChildNodes(withName: "enemy", using: { (enemy, pointer) in
                locations.append(enemy.position)
            })
            let wait = SKAction.wait(forDuration: 2.0)
            let icShoot = SKAction.run({
                
                for i in locations
                {
                    
                    let size = CGSize(width: 5.0, height: 5.0)
                    
                    var bullet: PlayerProjectile? = PlayerProjectile(texture: nil, size: size, position: position, gravity: false, categoryBitmask: ColliderType.playerProjectile.rawValue, rotates: false)
                    bullet?.color = SKColor.orange
                    let dx = i.x
                    let dy = i.y
                    
                    bullet!.name = "bullet"
                    bullet!.physicsBody?.collisionBitMask = ColliderType.enemy.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.largeEnemy.rawValue | ColliderType.enemyProjectile.rawValue
                    bullet?.physicsBody?.contactTestBitMask = ColliderType.enemy.rawValue | ColliderType.enemyBoss.rawValue | ColliderType.enemyProjectile.rawValue
                    bullet?.zPosition = 0
                    
                    let distance = sqrt(pow(i.x - position.x, 2) + pow(i.y - position.y, 2))
                    let duration: TimeInterval = Double(distance / (bullet?.shootSpeed)!)
                    
                    let moveBullet = SKAction.move(to: CGPoint(x: dx , y: dy ), duration: duration)
                    let removeBullet = SKAction.run
                        {
                            bullet?.removeFromParent()
                            bullet = nil
                    }
                    
                    let explode = SKAction.run
                        {
                            explosion(addToNode: node, bullet: bullet!, location: i, physicsBody: true)
                    }
                    node.addChild(bullet!)
                    bullet!.run(SKAction.sequence([moveBullet, explode, removeBullet]))
                    //self.ammo -= 1
                }
            })
            
            let shootThenWait = SKAction.sequence([icShoot, wait])
            node.run(SKAction.repeat(shootThenWait, count: duration!))
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
