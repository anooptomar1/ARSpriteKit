//
//  DuckHuntDuck.swift
//  ARSpriteKit
//
//  Created by B Gay on 4/22/18.
//  Copyright © 2018 B Gay. All rights reserved.
//

import SpriteKit

final class DuckHuntDuck: SKNode {
    private var timer: Timer?
    private var textureSprite: SKSpriteNode?
    private var otherDuck: Bool = false
    var duckSpeed: Float = 0.0
    private var atlas: SKTextureAtlas?
    
    
    override init() {
        super.init()
        name = String(format: "Duck %p", self)
        let rand = arc4random_uniform(4)
        if rand == 1 {
            otherDuck = true
            atlas = SKTextureAtlas(named: "otherDuck")
        } else {
            otherDuck = false
            atlas = SKTextureAtlas(named: "duck")
        }
        duckSpeed = 2.0
        initNodeGraph()
        physicsBody = SKPhysicsBody()
        physicsBody?.affectedByGravity = false
    }
    
    private func initNodeGraph() {
        let f1 = atlas?.textureNamed("duckUpRight1.png")
        let duck = SKSpriteNode(texture: f1)
        textureSprite = duck
        addChild(textureSprite!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func setStartPosition() {
        let frame = UIScreen.main.bounds
        let x: CGFloat = CGFloat(arc4random_uniform(UInt32(frame.width * 0.8))) + frame.width * 0.1
        let y: CGFloat = 1.0
        position = CGPoint(x: x, y: y)
    }
    
    @objc func fly() {
        let frame = UIScreen.main.bounds
        let x: CGFloat = CGFloat(arc4random_uniform(UInt32(frame.width * 0.8))) + frame.width * 0.1
        let y: CGFloat = CGFloat(arc4random_uniform(UInt32(frame.height * 0.7))) + frame.width * 0.3
        animate()
    }
    
    private func animate() {
        removeAction(forKey: "animation")
        let f1: SKTexture?
        let f2: SKTexture?
        let f3: SKTexture?
        let rand = arc4random_uniform(4)
        switch rand {
        case 0:
            // Up left
            f1 = atlas?.textureNamed("duckUpLeft1.png")
            f2 = atlas?.textureNamed("duckUpLeft2.png")
            f3 = atlas?.textureNamed("duckUpLeft3.png")
        case 1:
            // Up Right
            f1 = atlas?.textureNamed("duckUpRight1.png")
            f2 = atlas?.textureNamed("duckUpRight2.png")
            f3 = atlas?.textureNamed("duckUpRight3.png")
        case 2:
            // Left
            f1 = atlas?.textureNamed("duckAcrossLeft1.png")
            f2 = atlas?.textureNamed("duckAcrossLeft2.png")
            f3 = atlas?.textureNamed("duckAcrossLeft3.png")
        case 3:
            // Right
            f1 = atlas?.textureNamed("duckAcrossRight1.png")
            f2 = atlas?.textureNamed("duckAcrossRight2.png")
            f3 = atlas?.textureNamed("duckAcrossRight3.png")
        default:
            fatalError()
        }
        let textures = [f1, f2, f3].compactMap { $0 }
        let action = SKAction.animate(with: textures, timePerFrame: TimeInterval(2.0 / 6.0))
        let actionRepeat = SKAction.repeatForever(action)
        textureSprite?.run(actionRepeat, withKey: "animation")
    }
    
    private func moveOff() {
        let location = CGPoint(x: position.x, y: -3_000)
        let distance = self.distance(position, p2: location)
        let pixels = UIScreen.main.bounds.width
        let duration: TimeInterval = TimeInterval(CGFloat(duckSpeed) * distance / pixels)
        let moveAction = SKAction.move(to: location, duration: duration)
        run(moveAction) { [weak self] in
            self?.removeFromParent()
        }
    }
    
    func duckKilled() {
        textureSprite?.removeAction(forKey: "animation")
        textureSprite?.texture = atlas?.textureNamed("duckShot.png")
        let pause = SKAction.wait(forDuration: 0.25)
        run(pause) { [weak self] in
            self?.physicsBody?.affectedByGravity = true
            let f1 = self?.atlas?.textureNamed("duckDown1.png")
            let f2 = self?.atlas?.textureNamed("duckDown2.png")
            let down = [f1, f2].compactMap { $0 }
            let shotDown = SKAction.animate(with: down, timePerFrame: 0.2)
            let shotDownRepeat = SKAction.repeatForever(shotDown)
            self?.textureSprite?.run(shotDownRepeat)
            self?.moveOff()
        }
    }
    
    private func distance(_ p1: CGPoint, p2: CGPoint) -> CGFloat {
        return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
    
    private func slope(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return (p2.y - p1.y) / (p2.x - p1.x)
    }
}
