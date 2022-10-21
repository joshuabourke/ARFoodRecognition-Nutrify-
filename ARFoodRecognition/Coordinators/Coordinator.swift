//
//  Coordinator.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 5/9/2022.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI
import Combine
import Vision

class Coordinator: NSObject, ARSessionDelegate {
    var updateSubscription: Cancellable!
    var arView: ARView?

    var imDetection = ImageDetection()
    var predictionTitle: String = ""
    
    let viewModel = ViewModel()
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueuem1")
    var latestPrediction: String = ""
    @Binding var passedPrediction: String
    @Binding var passedImage: UIImage

    init(passPrediction: Binding<String>, passedImage: Binding<UIImage>){
        _passedPrediction = passPrediction
        _passedImage = passedImage
    }
    

    
    var visionRequests = [VNRequest]()

    var textEntities = [ModelEntity]()
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            addNameAndSphereToScene()
        guard let arView = arView else {return}

            
            if let img = arView.session.currentFrame?.capturedImage {
                let ciimg = CIImage(cvImageBuffer: img)
                let finImage = UIImage(ciImage: ciimg)
                
                let finishedImage = finImage.resizeImage(targetSize: CGSize(width: 500, height: 500))
                //
                self.viewModel.foodNameAndImage.append(LastScannedFoods(id: UUID().uuidString, foodName: self.latestPrediction, foodImage: finishedImage))
                print("---------------- COUNT \(viewModel.foodNameAndImage.count)")
            }
        
    }
    
    func addNameAndSphereToScene() {
        guard let arView = arView else {return}
        
        
        let screenCentre: CGPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        //Might want to try other allowing planes for future testing.
        let results = arView.raycast(from: screenCentre, allowing: .existingPlaneInfinite, alignment: .horizontal)
        
        if let result = results.first {
            let radians = Float.pi
            
            
            let parentAnchor = AnchorEntity(raycastResult: result)
            let sphere = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01), materials: [SimpleMaterial(color: .green, isMetallic: false)])
//            let foodName = NameModelEntity(size: 0.003, color: .label, text: latestPrediction)
            
            let foodName = ModelEntity(mesh: MeshResource.generateText(latestPrediction, extrusionDepth: 0.005, font: .init(name: "Helvetica", size: 0.03)!, containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .white, isMetallic: false)])
            
            let foodNameMiddleValue = (foodName.model?.mesh.bounds.max.x)! - (foodName.model?.mesh.bounds.min.x)!
            
            let parentEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.01))
            
            foodName.transform.rotation = simd_quatf(angle: radians, axis: SIMD3<Float>(0,1,0))
            foodName.position.x = foodNameMiddleValue / 2
            foodName.position.y += 0.01
//            let name = ModelEntity(mesh: MeshResource.generateText(latestPrediction, extrusionDepth: 0.005, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .white, isMetallic: false)])
//            name.transform.rotation = simd_quatf(angle: radians, axis: SIMD3<Float>(0,1,0))
//            name.position.x += 0.05
            
            arView.snapshot(saveToHDR: false) { image in
                self.passedImage = image ?? UIImage()
            }
            
//            if let img = arView.session.currentFrame?.capturedImage {
//                let ciimg = CIImage(cvPixelBuffer: img)
//                let finImage = UIImage(ciImage: ciimg)
//                passedImage = finImage.resizeImage(targetSize: CGSize(width: 300, height: 300))
//            }
            
            passedPrediction = latestPrediction
            
            parentEntity.addChild(foodName)
            parentEntity.addChild(sphere)
            

            textEntities.append(parentEntity)
            parentAnchor.addChild(parentEntity)
            arView.scene.anchors.append(parentAnchor)
            


        }

    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let arView = arView else {return}
        
        updateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            self.textEntities.forEach { entity in
                entity.look(at: arView.cameraTransform.translation, from: entity.position(relativeTo: nil), relativeTo: nil)
            }
        })
    }

//    func timerRunningFunction() {
//
//        self.predictionTitle = self.imDetection.imageDetectionVM.predictionLabel
//        self.imageForImageDetection = self.getImageFromARSession()
//        self.imDetection.imageDetectionVM.detect(self.imageForImageDetection)
//    }
    
    
//    func runEveryFrame(){
//
//        let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//        timer.fire()
////        self.nameAnchor.look(at: arView.cameraTransform.translation, from: self.nameAnchor.position(relativeTo: nil), relativeTo: nil)
//
//        }
//
//    @objc func fireTimer(){
//        print("Timer has been fired")
////        timerRunningFunction()
//        print("PredictionLabel: \(self.predictionTitle)")
//        print("This is running")
//        print("latestPrediction: \(self.latestPrediction)")
//        modelAndClassifications()
//
//    }


    
    //To capture a still image from the ARSession to feed into the pixel Buffer for prediction. https://stackoverflow.com/questions/65215443/how-do-i-capture-still-photographs-in-a-realitykit-app
    func getImageFromARSession() -> UIImage {
        
        let finishedImage = UIImage()
        

        return finishedImage
    }

    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        //catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observation = request.results else {
            print("No Results")
            return
        }
        //Get Classifications
        let classifications = observation[0...1] // top 2 results
        .compactMap({ $0 as? VNClassificationObservation })
        .map({ "\($0.identifier) \(String(format: "- %.2f", $0.confidence))"})
        .joined(separator: "\n")
        
        
        DispatchQueue.main.async {
            //print classifications
            print(classifications)
            print("--")
            
            //display debug text on screen
//            var debugTextOnScreen: String = ""
//            debugTextOnScreen += classifications
//            print("Debug Text in console \(debugTextOnScreen)")
            
            var objectName:String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            self.latestPrediction = objectName
        }
    }
    
    func modelAndClassifications() {
        //This is to be run on view did load or view did update
        guard let model = try? VNCoreMLModel(for: _0_0_2_FoodVisionV2_100_foods_manually_cleaned().model) else {
            fatalError("Could not load model. Enrusre model has been inserted into the xcode project")
        }
        
        let classificationRequest = VNCoreMLRequest(model: model, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        
        visionRequests = [classificationRequest]
    }
    
    func loopCoreMLUpdate(){
        //Continuously run CoreMl whenever its ready. (preventing hiccups in frame rate)
        
        
        dispatchQueueML.async {
            //1. Run Update
            self.updateCoreML()
            
            //2. loop this function
            self.loopCoreMLUpdate()
        }
    }
    
    
    func updateCoreML(){
        //////////////////
        
        guard let arView = arView else {return}
        //Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (arView.session.currentFrame?.capturedImage)
        if pixbuff == nil {return}
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        //note: not entirely sure if the ciImage is being interpreted as RGB, but for not it works with the inception model.
        //note2: also uncertain if the pixelBuffer should be rotated before handing off to vision (VNImageRequestHandler) - regardless, for now, it still works well with the inception model.
        ////////////////////
        
        //prepare CoreML/Vision request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequest Handler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        ////////////////////
        //Run image request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        }catch {
            print(error)
        }
    }
    
}
