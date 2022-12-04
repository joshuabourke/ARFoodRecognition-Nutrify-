//
//  CameraBar.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 2/12/2022.
//

import SwiftUI

struct CameraBar: View {
    //MARK: - PROPERTIES
    @Binding var showPhotoSheetView: Bool
    
    //MARK: - BODY
    var body: some View {
        HStack{
            Button {
                print("This will be the left hand side button. This is for the preview image")
                showPhotoSheetView.toggle()
            } label: {
                Image(systemName: "photo")
                    .font(.title)
            }
            .foregroundColor(.primary)
            .padding()

            Spacer()
            Button {
                print("This will be the middle button for taking a photo of placing a node")
            } label: {
                ZStack{
                    Circle()
                        .frame(height: 80)
                        .foregroundColor(.green)
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundColor(.white)
                        .frame(height: 70)
                }

            }
            Spacer()
            Button {
                print("This Button will be for something i am not sure about yet")
            } label: {
                Image(systemName: "bookmark")
                    .font(.title)
            }
            .foregroundColor(.primary)
            .padding()

        }//: HSTACK This is the camera bar for the bottom of the view.
        .frame(height: 95)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding()
    }
}
    //MARK: - PREVIEW
struct CameraBar_Previews: PreviewProvider {
    static var previews: some View {
        CameraBar(showPhotoSheetView: .constant(false))
    }
}

