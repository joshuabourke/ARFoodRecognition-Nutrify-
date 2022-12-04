//
//  MiniDockView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 15/11/2022.
//

import SwiftUI

struct MiniDockView: View {
    //MARK: - PROPERTIES
    @Binding var expanded: Bool
    @Binding var miniDockName: String
    @Binding var miniDockImage: UIImage
    @Binding var showEmptyScannedFoodAlert: Bool
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack{
                Image(uiImage: miniDockImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 8)
                Text("Scanned Food:")
                    .font(.body)
                    .fontWeight(.bold)
                
                Spacer(minLength: 0)
                
                Text(miniDockName)
                    .font(.title2)
                    .fontWeight(.bold)
            }//: HSTACK
            .padding(.top, 12)
            .padding(.horizontal, 8)
            Divider().padding(0)
        }//: VSTACK
        .environmentObject(ViewModel())
        .background(Color(UIColor.systemBackground))
        .offset(y: -48)
        .onTapGesture {
            if miniDockName == ""{
                print("There scan a food First")
                showEmptyScannedFoodAlert.toggle()
            } else {
                expanded.toggle()
            }
        }
    }
}
    //MARK: - PREVIEW
struct MiniDockView_Previews: PreviewProvider {
    static var previews: some View {
        MiniDockView(expanded: .constant(false), miniDockName: .constant("Hamimelon"), miniDockImage: .constant(UIImage(systemName: "photo")!), showEmptyScannedFoodAlert: .constant(false))
    }
}
