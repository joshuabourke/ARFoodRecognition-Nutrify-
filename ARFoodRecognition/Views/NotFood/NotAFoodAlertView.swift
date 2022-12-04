//
//  NotAFoodAlertView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 22/11/2022.
//

import SwiftUI

struct NotAFoodAlertView: View {
    //MARK: - PROPERTIES
    
    @Binding var thatIsNotAFood: Bool
    
    //MARK: - BODY
    var body: some View {
        VStack{
            HStack{
                
                Text(thatIsNotAFood ? "No Food Detected" : "Food Detected")
                    .font(.body)
                    .fontWeight(.bold)
                
            }//: HSTACK
            .padding(.horizontal)
            .background(thatIsNotAFood ? Color(UIColor.red) : Color(UIColor.green))
            .opacity(0.8)
            .cornerRadius(8)
            
            
        }//: VSTACK
//        .opacity(thatIsNotAFood ? 1 : 0)
    }
}
    //MARK: - PREVIEW
struct NotAFoodAlertView_Previews: PreviewProvider {
    static var previews: some View {
        NotAFoodAlertView(thatIsNotAFood: .constant(false))
    }
}
