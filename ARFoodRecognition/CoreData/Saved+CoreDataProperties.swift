//
//  Saved+CoreDataProperties.swift
//  ARFoodRecognition
//
//  Created by Josh Bourke on 21/11/2022.
//

import Foundation
import CoreData

extension Saved {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Saved> {
        return NSFetchRequest<Saved>(entityName: "Saved")
    }
    
    @NSManaged public var savedFoodName: String?
    @NSManaged public var savedIsFoodSaved: Bool
    @NSManaged public var savedDate: Date
    @NSManaged public var savedFoodImage: Data?
    @NSManaged public var savedFoodID: UUID
    
}

extension Saved: Identifiable {
    
}
