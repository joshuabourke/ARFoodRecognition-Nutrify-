//
//  ListItemModel.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 12/9/2022.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var foodNameAndImage = [LastScannedFoods]()
    
    }

struct LastScannedFoods: Identifiable {
    var id: String
    var foodName: String
    var foodImage: UIImage
}


