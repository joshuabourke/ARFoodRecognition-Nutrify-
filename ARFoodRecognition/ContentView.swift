//
//  ContentView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 5/9/2022.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ContentView : View {
    //MARK: - Properties
    @State var title: String = ""
    @State private var image: UIImage?
    @State var recordsIsOn: Bool = false
    @State var expanded: Bool = false
    @State var receivedPrediction: String = ""
    @State var receivedImage: UIImage = UIImage()
    @StateObject var viewModel = ViewModel()
    @State var currentSelection: Int = 0
    
    @Namespace var animation
    
    
    
    //MARK: - BODY
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            
            TabView(selection: $currentSelection) {
                //MARK: - TAB 1
                ZStack{
                    ARViewContainer(receivedImage: $receivedImage, receivedPredition: $receivedPrediction)
                        .edgesIgnoringSafeArea(.all)
                    
                    CrosshairView()
                }//: ZSTACK
                
                    .tag(0)
                    .tabItem {
                        Image(systemName: "cube")
                        Text("AR View")
                    }
                
                //MARK: - TAB 2
                Text("This will be where I show a list of the saved foods.")
                    .tag(1)
                    .tabItem {
                        Image(systemName: "bookmark")
                        Text("Saved")
                    }
                
            }//: TABBAR
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//                appearance.backgroundColor = UIColor(Color.primary.opacity(0.2))
                
                //Use this appearance when scrolling behind tabview:
                UITabBar.appearance().standardAppearance = appearance
                
                //Use this appearance when scrolled all the way up:
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }

            VStack{
                    
                ListView(expandedImage: $receivedImage, expanded: $expanded, expandedFoodName: $receivedPrediction, animation: animation)

            }//: VSTACK 
        }//: ZSTACK

    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var receivedImage: UIImage
    @Binding var receivedPredition: String
    
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let defaultScaleFactor = arView.contentScaleFactor
        let worldTrackingConfig = ARWorldTrackingConfiguration()
        worldTrackingConfig.planeDetection = [.horizontal]
        arView.session.delegate = context.coordinator.self
        arView.session.run(worldTrackingConfig)
        arView.renderOptions.remove(.disableAREnvironmentLighting)
        arView.renderOptions.remove(.disableMotionBlur)
        arView.renderOptions.remove(.disableFaceMesh)
        arView.renderOptions.remove(.disableGroundingShadows)
        arView.renderOptions.remove(.disableCameraGrain)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))

        context.coordinator.arView = arView
        arView.addCoachingOverlay()
        arView.contentScaleFactor = 0.3 * defaultScaleFactor
//        arView.debugOptions.insert(.showStatistics)
        
        return arView
        
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.modelAndClassifications()
        context.coordinator.loopCoreMLUpdate()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(passPrediction: $receivedPredition, passedImage: $receivedImage)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
#endif
