//
//  ViewController.swift
//  ARSpriteKit
//
//  Created by B Gay on 4/21/18.
//  Copyright © 2018 B Gay. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        if anchor is ARPlaneAnchor {
            if arc4random_uniform(2) == 0 {
                let treeNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "tree")))
                return treeNode
            } else {
                let bushNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "back")))
                bushNode.zPosition = 1.0
                let dog = DuckHuntDog()
                dog.position = CGPoint(x: -bushNode.frame.width * 0.5, y: -bushNode.frame.height * 0.5 + dog.frame.height)
                dog.zPosition = 2.0
                bushNode.addChild(dog)
                dog.playOpenning()
                return bushNode
            }
        } else {
            let duck = DuckHuntDuck()
            duck.fly()
            return duck
        }
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
