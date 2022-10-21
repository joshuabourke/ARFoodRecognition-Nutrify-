//
//  NameModelEntity.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 11/9/2022.
//

import Foundation
import UIKit
import RealityKit

class NameModelEntity: Entity, HasModel {
    
    var size: Float!
    var color: UIColor!
    var text: String!
    
    init(size: Float, color: UIColor, text: String) {
        super.init()
        self.size = size
        self.color = color
        self.text = text
        
        let textMesh = generateTextShape(textToGenerate: text)
        let materials = [generateMaterial()]
        model = ModelComponent(mesh: textMesh, materials: materials)
    }
    
    private func generateTextShape(textToGenerate: String) -> MeshResource {
        
        return MeshResource.generateText(textToGenerate, extrusionDepth: size, font: .init(name: "Helvetica", size: 0.03)!, containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping)
    }
    
    private func generateMaterial() -> Material {
        SimpleMaterial(color: color, isMetallic: false)
    }
    
    
    required init() {
        fatalError("Init() has not been implemented")
    }
}
