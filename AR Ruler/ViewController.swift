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
    }
    
}
