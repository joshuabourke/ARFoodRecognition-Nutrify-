//
//  ARView+Extension.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 5/9/2022.
//

import Foundation
import RealityKit
import ARKit

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoachingOverlay(){
        let coachingView = ARCoachingOverlayView()
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(coachingView)
        
        coachingView.goal = .horizontalPlane
        coachingView.session = self.session
        coachingView.delegate = self
    }
    
}

