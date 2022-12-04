//
//  OnBoardingView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 21/11/2022.
//

import SwiftUI

struct OnBoardingView: View {
    //MARK: - PROPERTIES
    @Binding var shouldShowOnBoarding: Bool
    //MARK: - BODY
    var body: some View {
        TabView{
            OnBoardingPageView(title: "How To", Subtitle: "How to use AR Nutrify, swipe through to find out more!", imageName: "questionmark", showDismissButton: false, shouldShowRealImage: false, shouldShowOnBoarding: $shouldShowOnBoarding)
                
            OnBoardingPageView(title: "Not a Food", Subtitle: "In the photo above you can see the app indicating that you are not looking at a food.", imageName: "FocusNotFoodImage.png", showDismissButton: false, shouldShowRealImage: true, shouldShowOnBoarding: $shouldShowOnBoarding)
            
            OnBoardingPageView(title: "Food", Subtitle: "In the photo above you can see that the indication has disappear and you are in fact looking at a food.", imageName: "FocusFoodImage.png", showDismissButton: false, shouldShowRealImage: true, shouldShowOnBoarding: $shouldShowOnBoarding)
            
            OnBoardingPageView(title: "Idea's", Subtitle: "We have more idea's to come and this is just the start!", imageName: "lightbulb", showDismissButton: true, shouldShowRealImage: false, shouldShowOnBoarding: $shouldShowOnBoarding)

            
        }//: TABVIEW
        .tabViewStyle(.page)
    }
}
    //MARK: - PREVIEW
struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(shouldShowOnBoarding: .constant(false))
    }
}
