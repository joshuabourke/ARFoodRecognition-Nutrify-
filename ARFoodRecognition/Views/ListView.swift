//
//  ListView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 23/9/2022.
//

import SwiftUI

struct ListView: View {
    //MARK: - PROPERTIES
    @Binding var expandedImage: UIImage
    @Binding var expanded: Bool
    @Binding var expandedFoodName: String
    
    var animation: Namespace.ID
    
    var height = UIScreen.main.bounds.height / 3
    
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var offset: CGFloat = 0

    
    //MARK: - BODY
    var body: some View {

        VStack {
            Capsule()
                .fill(Color.gray)
                .frame(width: expanded ? 60 : 0, height: expanded ? 4 : 0)
                .opacity(expanded ? 1 : 0)
                .padding(.top, expanded ? safeArea?.top : 0)
            
            HStack {
                //Centering Image
                if expanded{Spacer(minLength: 0)}
                
                Image(uiImage: expandedImage)
                    .resizable()
                    .frame(width: expanded ? UIScreen.main.bounds.width - 20 : 35, height: expanded ? 500 : 55)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)
                    .shadow(radius: 8)
                
                if !expanded {
                    Text("Scanned Food")
                        .font(.title2)
                        .fontWeight(.bold)
                        .matchedGeometryEffect(id: "Label", in: animation)
                }
                
                Spacer(minLength: 0)
                
                //Buttons to be on the minidock for when it is closed
                if !expanded {
                    Button {
                        print("Saved Item")
                    } label: {
                        Image(systemName: "bookmark")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }//: HSTACK
            .padding(.horizontal)
            ScrollView {
                VStack(spacing: 15) {
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            //Buttons for when it has been expanded
                            if expanded {
                                Text(expandedFoodName)
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .fontWeight(.bold)
                                    .matchedGeometryEffect(id: "Label", in: animation)
                                    .padding()
                            }
                            Spacer(minLength: 0)
                            
                            Button {
                                print("Something will happen here")
                            } label: {
                                Image(systemName: "ellipis.circle")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                            
                        }//: HSTACK
                        .padding()
                        .padding(.top, 20)
                        
                        Button {
                            print("Something is going to happen here")
                        } label: {
                            Image(systemName: "bookmark")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        
                        
                        HStack(spacing: 22){
                            Button {
                                print("Something is going to happen here")
                            } label: {
                                Image(systemName: "arrow.up.message")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }

                            Button {
                                print("Something is going to happen here")
                            } label: {
                                Image(systemName: "airplayaudio")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }
                            
                            Button {
                                print("Something is going to happen here")
                            } label: {
                                Image(systemName: "list.bullet")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            }


                        }//: HSTACK
                        .padding(.bottom, safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
                        Text("This is going to be testing to see if i can scroll down further with out it wigging out")
                        .padding()
                    }//: VSTACK
                    //This is what is going to give a stretch effect
                    .frame(height: expanded ? nil : 0)
                .opacity(expanded ? 1 : 0)
            }//: SCROLLVIEW
            
        }//: VSTACK
        //Expanding to full screen when clicked...
        .frame(maxHeight: expanded ? .infinity : 80)
        //Moving the miniplayer above the tabbar....
        //approx tab bar height is 49
        .background(VStack(spacing: 0){
            BlurView()
            Divider()
        }//: VSTACK
            .onTapGesture {
                withAnimation(.spring()) { expanded = true}
            }
        )//:Background
        .cornerRadius(expanded ? 20 : 0)
        .offset(y: expanded ? 0 : -48)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
        .ignoresSafeArea()
    }
    //MARK: - FUNCTIONS

    func onended(value: DragGesture.Value) {
        //This is only allowing it to fire if expanded is also true
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)){
            //If value is > than height / 3 then close the view...
            if value.translation.height > height {
                expanded = false
            }
            offset = 0
        }
    }

    func onchanged(value: DragGesture.Value) {
        
        if value.translation.height > 0 && expanded {
            offset = value.translation.height
        }
        
    }

    
}

