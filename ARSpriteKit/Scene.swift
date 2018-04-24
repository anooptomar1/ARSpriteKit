//
//  Scene.swift
//  ARSpriteKit
//
//  Created by B Gay on 4/21/18.
//  Copyright © 2018 B Gay. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if let touchLocation = touches.first?.location(in: self),
            let node = nodes(at: touchLocation).first(where: { $0 is DuckHuntDuck }) as? DuckHuntDuck {
            node.duckKilled()
            return
        } else if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.75 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.75
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
}
