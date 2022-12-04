//
//  CameraActionBar.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 2/12/2022.
//

import SwiftUI

struct CameraActionBar: View {
    //MARK: - PROPERTIES
    @Binding var showPhotoSheetView: Bool
    @Binding var showLeftView: Bool
    @Binding var showRightView: Bool
    @ObservedObject var viewModel: ViewModel
    //MARK: - BODY
    var body: some View {
        NavigationView {
                GeometryReader { geo in
                    VStack{
                        Spacer(minLength: 0)
                        HStack(spacing: 20){
                            TopThreePredictionButtons(predictionButtonTitle: "Apple")
                            TopThreePredictionButtons(predictionButtonTitle: "Banana")
                            TopThreePredictionButtons(predictionButtonTitle: "Steak")
                        }//: HSTACK This will be for the top 3 predictions
                        
                        CameraBar(showPhotoSheetView: $showPhotoSheetView)
                        
                        .sheet(isPresented: $showPhotoSheetView) {
                            Text("This is the photo sheet view.")
                        }
                    }//: VTSACK This is containing the whole view.
                    .frame(width: geo.size.width, height: geo.size.height)
                    //This is to open the left screen.
                    .offset(x: self.showLeftView ? geo.size.width : 0)
                    .disabled(self.showLeftView ? true : false)
                    //This is to open the right screen.
                    .offset(x: self.showRightView ? -geo.size.width : 0)
                    .disabled(self.showRightView ? true : false)
                    
                    //MARK: - TO SHOW LEFT OR RIGHT SCREEN.
                    if self.showLeftView {
                        TestingLeftView(didLeftViewAppear: $showLeftView, titleForView: "LEFT")
                            .frame(width: geo.size.width)
                            .transition(.move(edge: .leading))
                    }
                    if self.showRightView {
                        FoodListView(viewModel: viewModel)
                            .frame(width: geo.size.width)
                            .transition(.move(edge: .trailing))
                    }
                }//: GEO
                .background(.opacity(0))

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
        .background(.opacity(0))
    }
}
    //MARK: - PREVIEW
struct CameraActionBar_Previews: PreviewProvider {
    static var previews: some View {
        CameraActionBar(showPhotoSheetView: .constant(false), showLeftView: .constant(false), showRightView: .constant(false), viewModel: ViewModel())
    }
}

