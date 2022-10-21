//
//  ImageDetectionViewModel.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 6/9/2022.
//

import Foundation
import SwiftUI
import Combine

class ImageDetectionViewModel: ObservableObject {
    
    
    var name: String = ""
    var manager: ImageDetectionManager
    @Published var predictionLabel: String = ""
    @Published var otherPossiblePredictions: [String] = []
    
    init(manager: ImageDetectionManager) {
        self.manager = manager
    }
    
    func detect(_ image: UIImage?) {
        
        let sourceImage = image
        
//        guard let resizedImage = sourceImage?.cropToBounds(image: sourceImage!, width: 299, height: 299) else {
//            fatalError("Unable to resize the image for the model")
//        }

        guard let resizedImage = sourceImage?.resizeImage(targetSize: CGSize(width: 299, height: 299)) else {
            fatalError("Unable to resize the image")
        }

        
        if let label = self.manager.detect(resizedImage).0 {
            self.predictionLabel = label
        }
        let otherLabel = self.manager.detect(resizedImage).1
            otherPossiblePredictions.append(contentsOf: otherLabel)
        
        //Update the prediction Label with the image prediction
    }

}
