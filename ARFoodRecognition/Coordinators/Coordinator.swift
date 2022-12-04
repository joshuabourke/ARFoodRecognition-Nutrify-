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

    //This predictiontitle is the title or string for once the vision model has said yes it is a food.
    var predictionTitle: String = ""
    
    @StateObject var lastScannedFoods: ViewModel
    
    @StateObject var imDetection: ImageDetection
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueuem1")
    //This prediction is the string from the vision model that runs everyframe
    var latestPrediction: String = ""
    //These Bindings are for passing infomation from the Coordinator to the contentView
    @Binding var passedPrediction: String
    @Binding var passedImage: UIImage
    @Binding var itemIsNotFood: Bool
    @Binding var removeAllNodes: Bool

    init(passPrediction: Binding<String>, passedImage: Binding<UIImage>, itemIsNotFood: Binding<Bool>, imDetection: StateObject<ImageDetection>, removeAllNodes: Binding<Bool>, lastScannedFood: StateObject<ViewModel>){
        _imDetection = imDetection
        _passedPrediction = passPrediction
        _passedImage = passedImage
        _itemIsNotFood = itemIsNotFood
        _removeAllNodes = removeAllNodes
        _lastScannedFoods = lastScannedFood
    }
    
    var visionRequests = [VNRequest]()

    var textEntities = [ModelEntity]()
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        
        addNameAndSphereToScene()
        
    }
    
    func addNameAndSphereToScene() {
        guard let arView = arView else {return}
        
        if itemIsNotFood{

        } else{
            imDetection.imageDetectionVM.detect(getImage(arView: arView))
            predictionTitle = imDetection.imageDetectionVM.predictionLabel
            
            let screenCentre: CGPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
            //Might want to try other allowing planes for future testing.
            let results = arView.raycast(from: screenCentre, allowing: .existingPlaneInfinite, alignment: .horizontal)
            
        if let result = results.first {
            let radians = Float.pi
            
            
            let parentAnchor = AnchorEntity(raycastResult: result)
            let sphere = ModelEntity(mesh: MeshResource.generateSphere(radius: 0.01), materials: [SimpleMaterial(color: .green, isMetallic: false)])
            //            let foodName = NameModelEntity(size: 0.003, color: .label, text: latestPrediction)
            
            let foodName = ModelEntity(mesh: MeshResource.generateText(predictionTitle, extrusionDepth: 0.003, font: .init(name: "AppleSDGothicNeo-Medium", size: 0.02)!, containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .white, isMetallic: true)])
            
            let foodNameMiddleValue = (foodName.model?.mesh.bounds.max.x)! - (foodName.model?.mesh.bounds.min.x)!
            
            let parentEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.01))
            
            foodName.transform.rotation = simd_quatf(angle: radians, axis: SIMD3<Float>(0,1,0))
            foodName.position.x = foodNameMiddleValue / 2
            foodName.position.y += 0.01
            //            let name = ModelEntity(mesh: MeshResource.generateText(latestPrediction, extrusionDepth: 0.005, font: .systemFont(ofSize: 0.03), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping), materials: [SimpleMaterial(color: .white, isMetallic: false)])
            //            name.transform.rotation = simd_quatf(angle: radians, axis: SIMD3<Float>(0,1,0))
            //            name.position.x += 0.05
            
            
            //These 2 lines here are to take a screen shot of the ARSession. This will include the ARnode in the picture that the user will be able to see.
            //            arView.snapshot(saveToHDR: false) { image in
            //                self.passedImage = image ?? UIImage()
            //            }
            
            //This is a frame from the ARScene. This function takes in the ARView then returns a UIImage on tap when the function has run
            passedImage = getImage(arView: arView)
            
            //This is just passing the prediction to the other view to display it for the user.
            passedPrediction = imDetection.imageDetectionVM.predictionLabel
            
            //            previousFoods(image: passedImage, name: passedPrediction)
            lastScannedFoods.foodNameAndImage.append(LastScannedFoods(id: UUID().uuidString, foodName: predictionTitle, foodImage: getImage(arView: arView)))
            //The food name and the sphere are both added to the parent entity for the parent entity to then track the camera. This give it the affect that the text will be facing the camera.
            parentEntity.addChild(foodName)
            parentEntity.addChild(sphere)
            
            textEntities.append(parentEntity)
            parentAnchor.addChild(parentEntity)
            arView.scene.anchors.append(parentAnchor)
            

        }
            
        }
        
    }
    
    //This function is checking to see if the user has tapped removeAllNodes. Then it will delete all of the nodes from the scene.
    func removeAllNodesFromScene() {
        guard let arView = arView else {return}
        if removeAllNodes {
            arView.scene.anchors.removeAll()
            removeAllNodes = false
        }
    }
    
    //The function checkIfFoodOrNotFood runs every frame at the moment using the apple vision frame work. This bascially checks if the camera is looking at a food or isnt.
    //If the camera is looking at some food it will then allow the user to be able to place a node into the scene. If not it will prompt the user to find a food for the camera to look at.
    func checkIfFoodOrNotFood() {
        if latestPrediction == "not" {
            itemIsNotFood = true
        } else {
            itemIsNotFood = false
        }
    }
    
    //The session function is just to keep track of where the camera is for the nodes to look at.
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let arView = arView else {return}
        
        checkIfFoodOrNotFood()
        removeAllNodesFromScene()
        
        updateSubscription = arView.scene.subscribe(to: SceneEvents.Update.self, { event in
            self.textEntities.forEach { entity in
                entity.look(at: arView.cameraTransform.translation, from: entity.position(relativeTo: nil), relativeTo: nil)
            }
        })
    }
    
    //This functions is to toggle the itemIsNotFood off after 3 seconds.
    private func hasNotFoodAlertTimeFinished() async {
        //Delaying the toggle off for 3 seconds
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        itemIsNotFood = false
    }

        //This will have to be something that I come back to in the future.
//    func previousFoods(image: UIImage, name: String) {
//        lastScannedFoods.foodNameAndImage.append(LastScannedFoods(id: UUID().uuidString, foodName: name, foodImage: image))
//    }
    
    //This function here is how I am able to take a screen shot from the scene and use it for the ML Model.
    func getImage(arView: ARView) -> UIImage {
     
        UIGraphicsBeginImageContextWithOptions(arView.bounds.size, arView.isOpaque, 0.0)
        arView.drawHierarchy(in: arView.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: (image?.cgImage)!)
        
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
            
            var objectName: String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            objectName = objectName.components(separatedBy: "_")[0]
            self.latestPrediction = objectName

        }
    }
        
    func foodOrNotFoodModel() -> VNCoreMLModel {
        
        
        guard let notFoodModel = try? VNCoreMLModel(for:NutrifyFoodNotFood_1().model) else {
            fatalError("Could not load model. Enrusre model has been inserted into the xcode project")
        }

        return notFoodModel
    }
    
    func modelAndClassifications() {
        //This is to be run on view did load or view did update

        let model = foodOrNotFoodModel()

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
