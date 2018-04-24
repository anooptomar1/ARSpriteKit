//
//  DuckHuntDog.swift
//  ARSpriteKit
//
//  Created by B Gay on 4/22/18.
//  Copyright © 2018 B Gay. All rights reserved.
//

import SpriteKit

final class DuckHuntDog: SKNode {
    
    private var textureSprite: SKSpriteNode?
    
    override init() {
        super.init()
        initNodeGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initNodeGraph() {
        let atlas = SKTextureAtlas(named: "dogSniff")
        let f1 = atlas.textureNamed("dogSniff1.png")
        let dog = SKSpriteNode(texture: f1)
        textureSprite = dog
        addChild(textureSprite!)
    }
    
    func playOpenning() {
        guard let parent = self.parent else { return }
        let atlas = SKTextureAtlas(named: "dogSniff")
        let f1 = atlas.textureNamed("dogSniff1.png")
        let f2 = atlas.textureNamed("dogSniff2.png")
        let f3 = atlas.textureNamed("dogSniff3.png")
        let f4 = atlas.textureNamed("dogSniff4.png")
        let f5 = atlas.textureNamed("dogSniff5.png")
        let textures = [f1, f2, f3, f4, f5].compactMap { $0 }
        let sniffAnimation = SKAction.animate(with: textures, timePerFrame: 0.2, resize: false, restore: true)
        let sniffRepeat = SKAction.repeatForever(sniffAnimation)
        textureSprite?.run(sniffRepeat, withKey: "Sniff")
        let moveOver = SKAction.moveBy(x: parent.frame.width * 0.5, y: 0.0, duration: 2.55)
        run(moveOver) { [weak self] in
            self?.textureSprite?.removeAction(forKey: "Sniff")
            self?.textureSprite?.texture = atlas.textureNamed("dogSniff6.png")
            let pause = SKAction.wait(forDuration: 1.0)
            
            let atlas = SKTextureAtlas(named: "dogJump")
            let f1 = atlas.textureNamed("dogJump1.png")
            let f2 = atlas.textureNamed("dogJump2.png")
            let jumpTextures = [f1, f2].compactMap { $0 }
            let jumpAnimation = SKAction.animate(with: jumpTextures, timePerFrame: 0.5)
            let jumpSequence = SKAction.sequence([pause, jumpAnimation])
            self?.textureSprite?.run(jumpSequence)
            let moveUp = SKAction.moveBy(x: 0.0, y: 100.0, duration: 0.5)
            moveUp.timingMode = .easeOut
            let moveDown = SKAction.moveBy(x: 0.0, y: -25.0, duration: 0.5)
            moveUp.timingMode = .easeIn
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let upDown = SKAction.sequence([pause, moveUp, moveDown, fadeOut])
            self?.run(upDown) { [weak self] in
                self?.removeFromParent()
            }
        }
    }
}
