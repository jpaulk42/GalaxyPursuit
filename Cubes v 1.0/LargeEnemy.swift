import SpriteKit

class LargeEnemy: Sprite
{
    let LETexture = SKTexture(imageNamed: "AlienShip")
    
    var health: Double = 200.0
    let shootSpeed: Double = 120.0
    
    init(position: CGPoint, addToNode node: SKNode)
    {
        let size: CGSize! = LETexture.size()
        
        super.init(texture: LETexture, size: size, position: position, gravity: false, categoryBitmask: ColliderType.largeEnemy.rawValue, rotates: false)
        
        self.setScale(2.5)
        self.color = SKColor.cyan
        self.colorBlendFactor = 0.8
        self.physicsBody?.isDynamic = false
        self.name = "largeEnemy"
        self.zPosition = 3
        self.physicsBody?.collisionBitMask = ColliderType.playerProjectile.rawValue 
        self.physicsBody?.contactTestBitMask = ColliderType.playerProjectile.rawValue
        
        node.addChild(self)
    }
    
    public func waitAndShoot(for time: Double, addToNode node: SKNode, targetPosition: CGPoint)
    {
        let wait = SKAction.wait(forDuration: time)
        let shoot = SKAction.run
        {
            self.LEShoot(fromPosition: self.position, addToNode: node, trajectory: targetPosition)
        }
        let waitAndShoot = SKAction.sequence([shoot, wait, shoot])
        self.run(SKAction.repeatForever(waitAndShoot))
    }
    
    private func LEShoot(fromPosition pos: CGPoint, addToNode node: SKNode, trajectory: CGPoint)
    {
        let theColor = SKColor(red: 0.1, green: 0.7, blue: 0.3, alpha: 1.0)
        let theSize = CGSize(width: 8.5, height: 8.5)
        let bullet = PlayerProjectile(texture: nil, size: theSize, position: pos, gravity: false, categoryBitmask: ColliderType.enemyProjectile.rawValue, rotates: false)
        bullet.color = theColor
        bullet.physicsBody?.contactTestBitMask = ColliderType.player.rawValue
        bullet.physicsBody?.collisionBitMask = ColliderType.player.rawValue
        bullet.zPosition = 2
        bullet.name = "largeEnemy"
        
        let distance = sqrt(pow(trajectory.x - pos.x, 2) + pow(trajectory.y - pos.y, 2))
        let duration: TimeInterval = Double(distance) / self.shootSpeed
        
        let moveBullet = SKAction.move(to: trajectory, duration: duration)
        let removeBullet = SKAction.removeFromParent()
        
        node.addChild(bullet)
        bullet.run(SKAction.sequence([moveBullet, removeBullet]))
    }
    
    public func LETookDamage(_ amount: Double)
    {
        self.health -= amount
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
