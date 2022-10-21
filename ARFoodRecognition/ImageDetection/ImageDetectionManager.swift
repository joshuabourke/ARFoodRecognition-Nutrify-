//
//  ImageDetectionManager.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 6/9/2022.
//

import Foundation
import UIKit
import CoreML

class ImageDetectionManager {
    
    //The correct way to init a model https://developer.apple.com/forums/thread/671446
    
//    let model: EmojiFoodClassifier_1 = {
//        do {
//            let config = MLModelConfiguration()
//            return try EmojiFoodClassifier_1(configuration: config)
//        } catch {
//            print("Error trying to config the model \(error)")
//            fatalError("Couldn't create MLModel")
//        }
//    }()
    let model = EmojiFoodClassifier_1()

    var predictionLabel: String = ""
    var otherPossiblePredictions: [String] = []
    
    func detect(_ img: UIImage) -> (String?, [String]) {
        
        guard let pixelBuffer = img.toCVPixelBuffer() else {
            return ("", [])
        }
        
        let prediction = try? model.prediction(image: pixelBuffer)
        
        if let output = prediction {
            let results = output.classLabelProbs.sorted {$0.1 > $1.1}
            let result = results.prefix(3).map { (key, value) in
                return "\(key)"
                // \(String(format: "%.2f", value * 100))% Add this above to display the percentage
            }
            predictionLabel = result[0]
            otherPossiblePredictions = [result[1], result[2]]
        }
        return (predictionLabel, otherPossiblePredictions)
    }
    
}
