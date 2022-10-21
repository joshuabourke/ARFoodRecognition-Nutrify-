//
//  ImageDetection.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 6/9/2022.
//

import Foundation
import SwiftUI

class ImageDetection: ObservableObject {
    
    
    @ObservedObject var imageDetectionVM: ImageDetectionViewModel
    var imageDetectionManager: ImageDetectionManager
    
    init(){
        self.imageDetectionManager = ImageDetectionManager()
        self.imageDetectionVM = ImageDetectionViewModel(manager: imageDetectionManager)
    }
}
