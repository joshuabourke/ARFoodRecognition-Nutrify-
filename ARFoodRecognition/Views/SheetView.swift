//
//  SheetView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 15/11/2022.
//

import SwiftUI

struct SheetView: View {
    //MARK: - PROPERTIES
    @Binding var arScannedImage: UIImage
    @Binding var arScannedName: String
    @State var viewModel: ViewModel = ViewModel()
    @State var didTapSave: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - CORE DATA
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saved.savedDate, ascending: false)])
    
    var savings: FetchedResults<Saved>
    
    //MARK: - BODY
    var body: some View {
        ScrollView(showsIndicators:false) {
            VStack{
                HStack{
                    Spacer()
                    
                    Button {
                        print("Sheet Close button has been pressed.")
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title)
                    }

                }//: HSTACK Buttons
                .padding()
                Image(uiImage: arScannedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300)
                    .clipped()
                    .cornerRadius(8)
                    .shadow(radius: 8)
                    .padding()
                
                HStack{
                    Text(arScannedName)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button {
                        print("Trying to save food to list of saved foods.")
                        addItem()
                        didTapSave.toggle()
                    } label: {
                        Image(systemName: didTapSave ? "bookmark.fill" : "bookmark")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }//: HSTACK Title
                .padding()
                

                
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                    .padding()
                Spacer()
            }
        }//: VSTACK The Whole View
    }
    
    //MARK: - FUNCTIONS
    
    //MARK: - CORE DATA SAVING FOODS
    private func addItem() {
        let data = self.arScannedImage.jpegData(compressionQuality: 0.5)
        withAnimation {
            let newItem = Saved(context: moc)
            newItem.savedFoodImage = data
            newItem.savedDate = Date()
            newItem.savedFoodID = UUID()
            newItem.savedFoodName = arScannedName
            newItem.savedIsFoodSaved = didTapSave
            do {
                try moc.save()
            } catch {
                //Replace this implementation with code to handle the error appropriately.
                //FatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error trying to save to core Data \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SheetView_Previews: PreviewProvider {
    static var previews: some View {
        SheetView(arScannedImage: .constant(UIImage(systemName: "photo")!), arScannedName: .constant("Hammimelon"))
    }
}
