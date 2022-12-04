//
//  FoodListView.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 15/11/2022.
//

import SwiftUI
import CoreData

struct FoodListView: View {
    //MARK: - PROPERTIES
    
    @ObservedObject var viewModel: ViewModel
    @AppStorage("onBoarding") var isOnBaordingShowing: Bool = true
    
    //MARK: - CORE DATA
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saved.savedDate, ascending: false)])
    
    var savings: FetchedResults<Saved>
    
    @State var arrayOfPreviouslyScannedFoods = [LastScannedFoods]()
    
    var pickerNames = ["Saved Foods", "Previously Scanned"]
    @State var savedOrNotSavedIndex: String = "Saved Foods"
    
    let listOfpreviouslyScannedFoods = [
        LastScannedFoods(id: UUID().uuidString, foodName: "Apple", foodImage: UIImage(systemName: "photo")!),
        LastScannedFoods(id: UUID().uuidString, foodName: "Orange", foodImage: UIImage(systemName: "photo")!),
        LastScannedFoods(id: UUID().uuidString, foodName: "Pear", foodImage: UIImage(systemName: "photo")!)
    ]
    //MARK: - BODY
    var body: some View {
        let savedOrNotSaved = savedOrNotSavedIndex
        NavigationView {
            VStack {
                Picker("Scanned and Saved Foods", selection: $savedOrNotSavedIndex) {
                    ForEach(pickerNames, id:\.self) {
                        Text($0)
                    }
                }//: PICKER
                .pickerStyle(.segmented)
                
                switch savedOrNotSaved {
                case "Saved Foods":
                    listOfSavedFoods
                    
                case "Previously Scanned":
                    previouslyScannedFoods
                default:
                    listOfSavedFoods
                }
            }//: VSTACK
                .navigationTitle("Saved Foods")
                .toolbar {
                    //This is just purely so I can reopen the on boarding screen.
                    ToolbarItem(placement:.navigationBarTrailing) {
                        Button {
                            print("Restart Onboarding Screen.")
                            isOnBaordingShowing.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                        }

                    }
                }

        }//: NAVIGATION VIEW

    }
    
    private var listOfSavedFoods: some View {
        List {
            ForEach(savings, id: \.self.savedFoodID.description) { savedFood in
                FoodListViewItem(image: UIImage(data: savedFood.savedFoodImage!)!, title: savedFood.savedFoodName ?? "Couldn't Load Name")
            }//: LOOP
            .onDelete(perform: removeFromCoreData)
        }//: LIST
    }//: listOfSavedFoods.
    
    private var previouslyScannedFoods: some View {
        List{
            ForEach(viewModel.foodNameAndImage, id:\.id) { lastScanned in
                PreviousFoodListViewItem(image: lastScanned.foodImage, title: lastScanned.foodName, lastScannedFoods: lastScanned)
            }//: LOOP
        }//: LIST
    }//: previouslyScannedFoods.
    
    //MARK: - FUNCTIONS
    
    func save() throws {
        try self.moc.save()
    }
    
    func removeFromCoreData(at offsets: IndexSet) {
        for index in offsets {
            let storedFoodItem = savings[index]
            moc.delete(storedFoodItem)
            do {
                try save()
            } catch{
                print("\(error.localizedDescription)")
            }
        }
    }
}
    //MARK: - PREVIEW
struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView(viewModel: ViewModel())
    }
}
