//
//  ButtonView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 23/9/2022.
//

import SwiftUI

struct ButtonView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var viewModel: ViewModel
    @Binding var recordsIsOn: Bool
    @Binding var image: UIImage
    @Binding var title: String
    //MARK: - BODY
    var body: some View {
        Button {
            print("Last scanned Item has been tapped.")
            recordsIsOn.toggle()
        } label: {
            Image(uiImage: image)
                    .resizable()
                    .frame(width: recordsIsOn ? 300 : 40, height: recordsIsOn ? 300 : 70)
                    .cornerRadius(8)
                    .shadow(radius: 8)
                
            Text(title)
                    .font(.body.bold())
                    .padding(.trailing)
        }//: SCANNED ITEM BUTTON
    }
}
//MARK: - PREVIEW
struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(recordsIsOn: .constant(false), image: .constant(UIImage()), title: .constant("Test"))
    }
}
