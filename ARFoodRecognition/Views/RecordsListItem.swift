//
//  RecordsListItem.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 10/9/2022.
//

import SwiftUI

struct RecordsListItem: View {
    //MARK: - PROPERTIES

    var title: String
    var image: UIImage
    
    //MARK: - BODY
    var body: some View {
        //These will be the items that I will add into the List. The List will be displaying a record of the foods the user has scanned in AR. They can they either use that view to gain some more infomation or.... They could interact with the node it self.
        VStack{
            
            Image(uiImage: image)
                .resizable()
                .frame(width: 300, height: 300)
                .rotationEffect(Angle(degrees: 90))
            
            Text(title)
                .font(.title.bold())
            

        }


    }
}
    //MARK: - PREVIEW
struct RecordsListItem_Previews: PreviewProvider {
    static var previews: some View {
        RecordsListItem(title: "Orange", image: UIImage(named: "banana")!)
    }
}
