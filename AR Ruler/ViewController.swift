//
//  ViewController.swift
//  AR Ruler
//
//  Created by Antons Aleksandrovs on 07/02/2018.
//  Copyright © 2018 Antons Aleksandrovs. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = []
            textNode.removeFromParentNode()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }

    func addDot(at hitResult: ARHitTestResult) {
        
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.red
        
        dotGeometry.materials = [dotMaterial]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        let column = hitResult.worldTransform.columns.3
        dotNode.position = SCNVector3(column.x, column.y, column.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        updateText(text: "\(distance) m", atPosition: end.position)
    }
    
    func updateText(text: String, atPosition position: SCNVector3) {
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode.geometry = textGeometry
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
