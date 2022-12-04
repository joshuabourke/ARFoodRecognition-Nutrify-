//
//  TopThreePredictionButtons.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 2/12/2022.
//

import SwiftUI

struct TopThreePredictionButtons: View {
    //MARK: - PROPERTIES
    var predictionButtonTitle: String
    
    //MARK: - BODY
    var body: some View {
        VStack{
            Button {
                print("This is going to be for the predictions")
            } label: {
                Text(predictionButtonTitle)
                    .font(.system(size: 14).bold())
                    .foregroundColor(.primary)
            }
        }//: VSTACK
        .padding(.vertical, 8)
        .padding(.horizontal,12)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}
    //MARK: - PREVIEW
struct TopThreePredictionButtons_Previews: PreviewProvider {
    static var previews: some View {
        TopThreePredictionButtons(predictionButtonTitle: "Apple")
    }
}
