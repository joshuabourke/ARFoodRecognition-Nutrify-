//
//  ExtensionBinding.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 28/11/2022.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue},
            set:{ newValue in
                self.wrappedValue = newValue
                handler(newValue)
            })
    }
}
