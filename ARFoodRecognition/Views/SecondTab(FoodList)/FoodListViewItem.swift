//
//  FoodListViewItem.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 15/11/2022.
//

import SwiftUI

struct FoodListViewItem: View {
    //MARK: - PROPERTIES
    var image: UIImage
    var title: String
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 8)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }//: VSTACK
            }//: HSTACK
            .padding(.horizontal,8)
            .padding(.vertical, 4)
        }//: VSTACK
    }
}

struct PreviousFoodListViewItem: View {
    //MARK: - PROPERTIES
    var image: UIImage
    var title: String
    var lastScannedFoods: LastScannedFoods
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack{
                Image(uiImage: lastScannedFoods.foodImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 8)
                VStack(alignment: .leading) {
                    Text(lastScannedFoods.foodName)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }//: VSTACK
            }//: HSTACK
            .padding(.horizontal,8)
            .padding(.vertical, 4)
        }//: VSTACK
    }
}
    //MARK: - PREVIEW
struct FoodListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodListViewItem(image: UIImage(systemName: "photo")!, title: "Hamimelon")
    }
}
