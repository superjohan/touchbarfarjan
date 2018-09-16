//
//  TouchBarFarjanView.swift
//  touchbarfarjan
//
//  Created by Johan Halin on 16/09/2018.
//  Copyright © 2018 Aero Deko. All rights reserved.
//

import Cocoa
import SceneKit
import QuartzCore

class TouchBarFarjanView: NSView {
    let sceneView = SCNView()
    let camera = SCNNode()
    let scroller = NSTextField()
    
    override init(frame frameRect: NSRect) {
        let camera = SCNCamera()
        camera.zFar = 600
        camera.fieldOfView = 60
        self.camera.camera = camera // lol

        super.init(frame: frameRect)
        
        self.sceneView.autoresizingMask = [ .width, .height ]
        self.wantsLayer = true
        
        self.scroller.isBezeled = false
        self.scroller.drawsBackground = false
        self.scroller.isEditable = false
        self.scroller.isSelectable = false
        self.scroller.stringValue = "Welcome to Jumalauta 18 Years party 24.-26.8.2018 at Hauho in (as it turned out) quite rainy Finland! We have cabins and good times! If you're in Sweden, take the dang titular finlandsfärjan/time machine!! Greets to everyone at Skrolli Party 2018 and everyone who's been at the Jumalauta party before! See you there this year and next year! This remake was made by Ylvaes, Tohtori Kannabispiikki, and Paasikivi-Kekkosen Linja. The 2006 original was made by Anteeksi, Maitotuote, Saksan Perussanasto, and Ylvaes."
        self.scroller.font = NSFont.boldSystemFont(ofSize: 12)
        self.scroller.sizeToFit()
        self.scroller.textColor = NSColor.white
        self.scroller.shadow = NSShadow()
        self.scroller.shadow?.shadowColor = NSColor.black
        self.scroller.shadow?.shadowOffset = NSSize(width: 1, height: 1)
        self.scroller.isHidden = true

        self.addSubview(self.sceneView)
        self.addSubview(self.scroller)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        self.sceneView.scene = createScene()
        self.sceneView.frame = self.bounds

        perform(#selector(startScroller), with: nil, afterDelay: 1)
    }
    
    @objc private func startScroller() {
        self.scroller.isHidden = false
        self.scroller.frame.origin.x = self.bounds.width

        perform(#selector(startScroller2), with: nil, afterDelay: 0)
    }

    @objc private func startScroller2() {
        NSAnimationContext.runAnimationGroup({ _ in
            NSAnimationContext.current.duration = 60.0
            NSAnimationContext.current.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            
            self.scroller.animator().frame = CGRect(x: -self.scroller.bounds.size.width, y: self.bounds.size.height - self.scroller.bounds.size.height - 15, width: self.scroller.bounds.size.width, height: self.scroller.bounds.size.height)
        }, completionHandler: nil)
    }
    
    fileprivate func createScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = NSColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        
        self.camera.position = SCNVector3Make(0, 0, 20)
        
        scene.rootNode.addChildNode(self.camera)
        
        configureLight(scene)
        
        let sun = SCNSphere(radius: 7)
        sun.firstMaterial?.diffuse.contents = NSColor.yellow
        let sunNode = SCNNode(geometry: sun)
        sunNode.position = SCNVector3Make(36, 12, -10)
        scene.rootNode.addChildNode(sunNode)
        
        let ground = SCNBox(width: 1000, height: 50, length: 20, chamferRadius: 10)
        ground.firstMaterial?.diffuse.contents = NSColor.green
        let groundNode = SCNNode(geometry: ground)
        groundNode.position = SCNVector3Make(0, -22, -15)
        scene.rootNode.addChildNode(groundNode)
        addRotateMoveActions(node: groundNode, moveBy: SCNVector3Make(0, 1, 0), moveDuration: 6, rotateBy: SCNVector3Make(0, 0, 0), rotateDuration: 7)
        
        let water = SCNBox(width: 1000, height: 50, length: 20, chamferRadius: 10)
        water.firstMaterial?.diffuse.contents = NSColor(red: 80.0 / 255.0, green: 80.0 / 255.0, blue: 1, alpha: 0.95)
        let waterNode = SCNNode(geometry: water)
        waterNode.position = SCNVector3Make(0, -31, 0)
        scene.rootNode.addChildNode(waterNode)
        addRotateMoveActions(node: waterNode, moveBy: SCNVector3Make(0, 0.4, 0), moveDuration: 5, rotateBy: SCNVector3Make(0, 0, 0.01), rotateDuration: 6)
        
        if let filePath = Bundle.main.path(forResource: "paatti", ofType: "dae", inDirectory: "") {
            let referenceURL = URL(fileURLWithPath: filePath)
            let referenceNode = SCNReferenceNode(url: referenceURL)
            referenceNode?.load()
            
            referenceNode?.runAction(
                SCNAction.rotateBy(
                    x: 3.14159 * 1.5 - 0.1,
                    y: -0.05,
                    z: -0.2,
                    duration: 0
                )
            )
            
            let boatImage = NSImage(named: "paatti")
            let childNodes = referenceNode?.childNodes
            for childNode in childNodes! {
                childNode.geometry?.firstMaterial = SCNMaterial()
                childNode.geometry?.firstMaterial?.diffuse.contents = boatImage
            }
            
            referenceNode?.position = SCNVector3Make(-5, -6, 0)
            referenceNode?.scale = SCNVector3Make(3, 3, 3)
            
            let moveAction = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 2)
            moveAction.timingMode = SCNActionTimingMode.easeInEaseOut
            
            if let node = referenceNode {
                addRotateMoveActions(node: node, moveBy: SCNVector3Make(0, -2, 0), moveDuration: 3, rotateBy: SCNVector3Make(0.2, 0.1, 0.4), rotateDuration: 3)
            }
            
            scene.rootNode.addChildNode(referenceNode!)
        }
        
        return scene
    }
    
    fileprivate func addRotateMoveActions(node: SCNNode, moveBy: SCNVector3, moveDuration: TimeInterval, rotateBy: SCNVector3, rotateDuration: TimeInterval) {
        let moveAction = SCNAction.moveBy(x: CGFloat(moveBy.x), y: CGFloat(moveBy.y), z: CGFloat(moveBy.z), duration: moveDuration)
        moveAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let moveReverseAction = moveAction.reversed()
        let sequence = SCNAction.sequence([moveAction, moveReverseAction])
        
        node.runAction(
            SCNAction.repeatForever(
                sequence
            )
        )
        
        let rotateAction = SCNAction.rotateBy(x: CGFloat(rotateBy.x), y: CGFloat(rotateBy.y), z: CGFloat(rotateBy.z), duration: rotateDuration)
        rotateAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let rotateReverseAction = rotateAction.reversed()
        let rotateSequence = SCNAction.sequence([rotateAction, rotateReverseAction])
        
        node.runAction(
            SCNAction.repeatForever(
                rotateSequence
            )
        )
    }
    
    fileprivate func configureLight(_ scene: SCNScene) {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = NSColor(white: 1.0, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 0, 60)
        scene.rootNode.addChildNode(omniLightNode)
    }
}
