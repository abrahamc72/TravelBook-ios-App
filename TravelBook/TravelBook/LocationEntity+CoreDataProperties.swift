//
//  LocationEntity+CoreDataProperties.swift
//  TravelBook
//
//  Created by Abraham Cervantes on 4/20/22.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var dEntry: String?
    @NSManaged public var address: String?
    @NSManaged public var long: Double
    @NSManaged public var lat: Double
    @NSManaged public var picture:NSData?
    @NSManaged public var personalpicture:NSData?
}

extension LocationEntity : Identifiable {

}
