//
//  OnBoardingPageView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 21/11/2022.
//

import SwiftUI

struct OnBoardingPageView: View {
    //MARK: - PROPERTIES
    let title: String
    let Subtitle: String
    let imageName: String
    let showDismissButton: Bool
    let shouldShowRealImage: Bool
    @Binding var shouldShowOnBoarding: Bool
    
    //MARK: - BODY
    var body: some View {
        VStack{
            if shouldShowRealImage{
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding()
            } else{
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding()
            }

            Text(title)
                .font(.title2)
                .bold()
                .padding()
            Text(Subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding()
            
            if showDismissButton {
                Button {
                    print("Finished OnBoarding")
                    shouldShowOnBoarding.toggle()
                } label: {
                    Text("Get Started")
                        .font(.body)
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }//: VSTACK
    }
}
    //MARK: - PREVIEW
struct OnBoardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingPageView(title: "Test", Subtitle: "I am just seeing how this is going to look for the onboarding screen and test it all out.", imageName: "bell", showDismissButton: true, shouldShowRealImage: false, shouldShowOnBoarding: .constant(false))
    }
}
