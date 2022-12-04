//
//  RemoveAllNodesButton.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 28/11/2022.
//

import SwiftUI

struct RemoveAllNodesButton: View {
    //MARK: - PROPERTIES
    @Binding var removeAllNodes: Bool
    
    //MARK: - BODY
    var body: some View {
        Button {
            removeAllNodes.toggle()
            print("This Button will remove all nodes from the scene")
        } label: {
            Image(systemName: "trash")
                .foregroundColor(.primary)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 4)        }

    }
}
    //MARK: - PREVIEW
struct RemoveAllNodesButton_Previews: PreviewProvider {
    static var previews: some View {
        RemoveAllNodesButton(removeAllNodes: .constant(false))
    }
}
