//
//  TestingLeftView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 2/12/2022.
//

import SwiftUI

struct TestingLeftView: View {
    //MARK: - PROPTERTIES
    @Binding var didLeftViewAppear: Bool
    var titleForView: String
    //MARK: - BODY
    var body: some View {
        VStack{
            Spacer()
            Text("HELLO THIS IS THE \(titleForView) VIEW.")
                .foregroundColor(.primary)
                .background(Color.secondary)
            Spacer()
        }//: VSTACK

    }
}
    //MARK: - PREVIEW
struct TestingLeftView_Previews: PreviewProvider {
    static var previews: some View {
        TestingLeftView(didLeftViewAppear: .constant(false), titleForView: "LEFT")
    }
}

