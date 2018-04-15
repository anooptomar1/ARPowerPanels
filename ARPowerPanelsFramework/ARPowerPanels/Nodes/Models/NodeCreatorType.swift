//
//  NodeCreatorType.swift
//  ARPlanets
//
//  Created by Paige Sun on 2018-03-18.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import SceneKit

protocol NodeCreatorType {
    static var allTypes: [NodeCreatorType] { get }
    var menuImage: UIImage? { get }
    func createNode() -> SCNNode?
}

public enum Shapes: NodeCreatorType {

    case sphere, plane, box, pyramid, cylinder, cone, torus, tube, capsule
    
    static var allTypes: [NodeCreatorType] {
        return [Shapes.sphere, Shapes.plane, Shapes.box, Shapes.pyramid, Shapes.cylinder, Shapes.cone, Shapes.torus, Shapes.tube, Shapes.capsule]
    }
    
    var menuImage: UIImage? {
        switch self {
        case .sphere:
            return ImageAssets.shapeSphere.image()
        case .plane:
            return ImageAssets.shapePlane.image()
        case .box:
            return ImageAssets.shapeBox.image()
        case .pyramid:
            return ImageAssets.shapePyramid.image()
        case .cylinder:
            return ImageAssets.shapeCylinder.image()
        case .cone:
            return ImageAssets.shapeCone.image()
        case .torus:
            return ImageAssets.shapeTorus.image()
        case .tube:
            return ImageAssets.shapeTube.image()
        case .capsule:
            return ImageAssets.shapeCapsule.image()
        }        
    }
    
    public func createNode() -> SCNNode? {
        let basicGeometry = geometry(for: self)
        basicGeometry.firstMaterial?.diffuse.contents = UIColor.randomColor()
        
        let childNode = SCNNode()
        childNode.geometry = basicGeometry
        childNode.scale = SCNVector3Make(0.03, 0.03, 0.03)
        
        let parentNode = SCNNode()
        parentNode.name = "\(self)"
        parentNode.addChildNode(childNode)
        return parentNode
    }
    
    private func geometry(for type: Shapes) -> SCNGeometry {
        switch self {
        case .sphere:
            return SCNSphere(radius: 1.0)
        case .plane:
            return SCNPlane(width: 1.0, height: 1.5)
        case .box:
            return SCNBox(width: 1.0, height: 1.5, length: 2.0, chamferRadius: 0.0)
        case .pyramid:
            return SCNPyramid(width: 2.0, height: 1.5, length: 1.0)
        case .cylinder:
            return SCNCylinder(radius: 1.0, height: 1.5)
        case .cone:
            return SCNCone(topRadius: 0.5, bottomRadius: 1.0, height: 1.5)
        case .torus:
            return SCNTorus(ringRadius: 1.0, pipeRadius: 0.2)
        case .tube:
            return SCNTube(innerRadius: 0.5, outerRadius: 1.0, height: 1.5)
        case .capsule:
            return SCNCapsule(capRadius: 0.5, height: 2.0)
        }
    }
}

public enum Model: NodeCreatorType {
    case wolf, fox, lowPolyTree, camera, custom, ship
    
    static var allTypes: [NodeCreatorType] {
        return [Model.wolf, Model.fox, Model.lowPolyTree, Model.ship] // TODO remove the Axis assets
    }
    
    public func createNode() -> SCNNode? {
        switch self {
        case .fox:
            return nodeFromScene(assetName: "fox/max", rootChildNodeName: "Max_rootNode", newNodeName: "Fox 🦊", newScale: SCNVector3Make(0.2, 0.2, 0.2))
        case .wolf:
            return nodeFromResource(assetName: "wolf/wolf", extensionName: "dae")?.clone()
        case .lowPolyTree:
            return nodeFromResource(assetName: "lowPolyTree", extensionName: "dae")?.clone()
        case .camera:
            return nodeFromScene(assetName: "camera", rootChildNodeName: "Camera Shape")
        case .custom:
            return SCNNode()
        case .ship:
            return nodeFromScene(assetName: "ship", rootChildNodeName: "ship", newNodeName: "Spaceship ✈️", newScale: SCNVector3Make(0.03, 0.03, 0.03))
        }
    }
    
    private func nodeFromScene(assetName: String, rootChildNodeName: String, newNodeName: String, newScale: SCNVector3) -> SCNNode? {
        if let foxNode = nodeFromScene(assetName: assetName, rootChildNodeName: rootChildNodeName)?.clone() {
            let parentNode = SCNNode()
            parentNode.name = newNodeName
            foxNode.scale = newScale
            parentNode.addChildNode(foxNode)
            return parentNode
        }
        NSLog("PAIGE LOG: COULD NOT LOAD \(assetName) MODEL")
        return nil
    }
    
    private func nodeFromScene(assetName: String, rootChildNodeName: String) -> SCNNode? {
        let bundle = Bundle(for: ModelCollectionView.self)
        if let url = bundle.url(forResource: "art.scnassets/\(assetName)", withExtension: "scn"),
            let scene = try? SCNScene(url: url) {
            return scene.rootNode.childNode(withName: rootChildNodeName, recursively: true)
        }
        return nil
    }
    
    func nodeFromResource(assetName: String, extensionName: String) -> SCNNode? {
        let bundle = Bundle(for: ModelCollectionView.self)
        
        if let url = bundle.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName) {
            NSLog("PAIGE LOG url \(url)")
            
            if let node = SCNReferenceNode(url: url) {
                node.name = assetName
                node.load()
                return node
            }
        } else {
            NSLog("PAIGE LOG: COULD NOT LOAD FROM RESOURCE")
        }
        return nil
    }
    
    var menuImage: UIImage? {
        switch self {
        case .wolf:
            return ImageAssets.menuWolf.image()
        case .lowPolyTree:
            return ImageAssets.menuLowPolyTree.image()
        case .fox:
            return ImageAssets.menuFox.image()
        case .camera:
            return ImageAssets.menuWolf.image()
        case .custom:
            return ImageAssets.menuWolf.image()
        case .ship:
            return ImageAssets.menuShip.image()
        }
    }
}
