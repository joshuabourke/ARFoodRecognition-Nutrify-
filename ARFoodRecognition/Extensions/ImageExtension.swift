//
//  ImageExtension.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 15/11/2022.
//

import Foundation
import SwiftUI
import UIKit

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}
