//
//  CrosshairView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 10/9/2022.
//

import SwiftUI

struct CrosshairView: View {
    //MARK: - PROPERTIES
    
    @State var heightAndWidth: CGFloat = 299
    @State var lineWidth: CGFloat = 2
    @Binding var itemIsNotFood: Bool
    
    var body: some View {
        
        
        ZStack {
            //MARK: - ROUNDED CROSS HAIR
            RoundedRectangle(cornerRadius: 16)
                .trim(from: 0.55, to: 0.7)
                .stroke(Color.white,lineWidth: lineWidth)
                .frame(width: heightAndWidth, height: heightAndWidth, alignment: .center)
                .foregroundColor(.white)
                .shadow(color: Color.black, radius: 2, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 16)
                .trim(from: 0.8, to: 0.95)
                .stroke(Color.white,lineWidth: lineWidth)
                .frame(width: heightAndWidth, height: heightAndWidth, alignment: .center)
                .foregroundColor(.white)
                .shadow(color: Color.black, radius: 2, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 16)
                .trim(from: 0.05, to: 0.2)
                .stroke(Color.white,lineWidth: lineWidth)
                .frame(width: heightAndWidth, height: heightAndWidth, alignment: .center)
                .foregroundColor(.white)
                .shadow(color: Color.black, radius: 2, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 16)
                .trim(from: 0.3, to: 0.45)
                .stroke(Color.white,lineWidth: lineWidth)
                .frame(width: heightAndWidth, height: heightAndWidth, alignment: .center)
                .foregroundColor(.white)
                .shadow(color: Color.black, radius: 2, x: 0, y: 0)
                
        }
            
    }
}

struct CrosshairView_Previews: PreviewProvider {
    static var previews: some View {
        CrosshairView(itemIsNotFood: .constant(false))
    }
}
