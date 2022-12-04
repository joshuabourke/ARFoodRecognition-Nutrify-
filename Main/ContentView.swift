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
    
    //expanded is to open the mini dock and show the sheet view.
    @State var expanded: Bool = false
    
    //MARK: - BINDINGS FROM COORDINATOR
    //These 2 properties receive their values from the Coordinator.
    @State var receivedPrediction: String = ""
    @State var receivedImage: UIImage = UIImage()
    //This is to check if the user has tried to scan food or not food.
    @State var itemIsNotFood: Bool = false
    //This bool is triggered from a button on the screen to clear all of the nodes in the scene.
    @State var removeAllNodes: Bool = false

    
    	
    @StateObject var viewModel = ViewModel()
    
    //TabBar
    @State var currentSelection: Int = 1
    
    //If the onboarding has been finished or not.
    @AppStorage("onBoarding") var isOnBaordingShowing: Bool = true
    
    //To check if the user has scanned a food or hasnt. Then let them know they have to do that.
    @State var showEmptyScannedFoodAlert: Bool = false
    
    @State var showPhotoSheetView: Bool = false
    @State var showLeftView: Bool = false
    @State var showRightView: Bool = false

    

    //MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack{
                
                ARViewContainer(receivedImage: $receivedImage, receivedPredition: $receivedPrediction, itemIsNotFood: $itemIsNotFood, removeAllNodes: $removeAllNodes, imDetection: ImageDetection(), lastScannedFood: ViewModel())
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    CameraBar(showPhotoSheetView: $showPhotoSheetView)
                }
                CrosshairView(itemIsNotFood: $itemIsNotFood)
                NotAFoodAlertView(thatIsNotAFood: $itemIsNotFood)
                    .offset(y: -200)
                //I am trying to push this down to the bottome right of the screen above the minidock.
                
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        RemoveAllNodesButton(removeAllNodes: $removeAllNodes)
                    }//: HSTACK
                    .padding()
                }//: VSTACK
                .offset(y: -120)
                
                
            }//: ZSTACK
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("This should take me to the right view")
                        withAnimation {
                            showRightView.toggle()
                        }
                    } label: {
                        if showRightView {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.primary)
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(20)
                                    .shadow(radius: 4)
                        } else {
                            Image(systemName: "gear")
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                                .shadow(radius: 4)
                        }
                    }
                    .disabled(showLeftView)
                    .opacity(showLeftView ? 0 : 1)

                }//THIS IS THE RIGHT HAND SIDE TOOL BAR BUTTON
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("This should take me to the left view")
                        withAnimation {
                            showLeftView.toggle()
                        }
                        
                    } label: {
                        if showLeftView {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.primary)
                                    .padding(8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(20)
                                    .shadow(radius: 4)
                        } else {
                            Image(systemName:"person.fill")
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                                .shadow(radius: 4)
                        }
                    }
                    .disabled(showRightView)
                    .opacity(showRightView ? 0 : 1)
                }// THIS IS THE LEFT HAND SIDE TOOL BAR BUTTON
            }//: TOOL BAR (Top of NAV VIEW
        }//: NAVIGATION VIEW
        
//        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
//
//            TabView(selection: $currentSelection) {
//                //MARK: - TAB 1
//
//                //Tab 1 is a zstack with the crosshair layed over the top of the ARView.
//                ZStack{
//                    ARViewContainer(receivedImage: $receivedImage, receivedPredition: $receivedPrediction, itemIsNotFood: $itemIsNotFood, removeAllNodes: $removeAllNodes, imDetection: ImageDetection(), lastScannedFood: ViewModel())
//                        .edgesIgnoringSafeArea(.all)
//
//
//                    CrosshairView(itemIsNotFood: $itemIsNotFood)
//                    NotAFoodAlertView(thatIsNotAFood: $itemIsNotFood)
//                        .offset(y: -200)
//                    //I am trying to push this down to the bottome right of the screen above the minidock.
//                    VStack {
//                        Spacer()
//                        HStack{
//                            Spacer()
//                            RemoveAllNodesButton(removeAllNodes: $removeAllNodes)
//                        }//: HSTACK
//                        .padding()
//                    }//: VSTACK
//                    .offset(y: -70)
//
//
//                }//: ZSTACK
//                    .tag(1)
//                    .tabItem {
//                        Image(systemName: "cube")
//                        Text("AR View")
//                    }
//
//                //MARK: - TAB 2
//                //Tab 2 is a list of the users saved foods.
//                FoodListView(viewModel: ViewModel())
//
//
//                    .tag(2)
//                    .tabItem {
//                        Image(systemName: "bookmark")
//                        Text("Saved")
//                    }
//
//            }//: TABBAR
//
//            .onAppear {
//
//                let appearance = UITabBarAppearance()
//                appearance.backgroundColor = UIColor.systemBackground
////                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//////                appearance.backgroundColor = UIColor(Color.primary.opacity(0.2))
////
//                //Use this appearance when scrolling behind tabview:
//                UITabBar.appearance().standardAppearance = appearance
//
//                //Use this appearance when scrolled all the way up:
//                UITabBar.appearance().scrollEdgeAppearance = appearance
//            }
//
//            //The alert is here for telling the user that they first need to scan a food to be able to see the detailed view. If they havent then this alert will also take them back to the ARView so they can do so.
//            .alert(isPresented: $showEmptyScannedFoodAlert){
//                Alert(title: Text("No Food Scanned"), message: Text("You must first scan a food before accessing the detailed view."), dismissButton: .default(Text("Ok"), action: {
//                    currentSelection = 1
//                }))
//            }
//
//            //This VStack is holding the mini dock view that is sitting on top of the Tabview. It has an offset of -48 on Y. This is because the tabbar should be roughly about 48 high.
//            VStack{
//                MiniDockView(expanded: $expanded, miniDockName: $receivedPrediction.onChange(checkingIfOnTapItIsFoodOrNotFood), miniDockImage: $receivedImage, showEmptyScannedFoodAlert: $showEmptyScannedFoodAlert)
//
//            }//: VSTACK
//            //The Onboarding view is a full screen over. This is shown to the users when they first log onto the app. Once they have finished it, it won't show again unless they toggle it back on in settings.
//            .fullScreenCover(isPresented: $isOnBaordingShowing) {
//                OnBoardingView(shouldShowOnBoarding: $isOnBaordingShowing)
//            }
//
//        }//: ZSTACK
//
//        //This is the sheetview that will be expanded once the user has scanned an image of a food. This will pop up once the user has tapped on the mini dock above the tab bar.
//        .sheet(isPresented: $expanded) {
//            SheetView(arScannedImage: $receivedImage, arScannedName: $receivedPrediction)
//        }

    }
    
    //MARK: - FUNCTION
    func checkingIfOnTapItIsFoodOrNotFood(to value: String) {
        if receivedPrediction == "not_food" {
            itemIsNotFood.toggle()
            print("THIS IS FIRERING BUT I CANT SEE THE NOT FOOD ALERT COME OUT AT ALL")
        } else if receivedPrediction == "food" {
            itemIsNotFood.toggle()

        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var receivedImage: UIImage
    @Binding var receivedPredition: String
    @Binding var itemIsNotFood: Bool
    @Binding var removeAllNodes: Bool
    @StateObject var imDetection: ImageDetection
    @StateObject var lastScannedFood: ViewModel
    
    
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
        Coordinator(passPrediction: $receivedPredition, passedImage: $receivedImage, itemIsNotFood: $itemIsNotFood, imDetection: _imDetection, removeAllNodes: $removeAllNodes, lastScannedFood: _lastScannedFood)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
