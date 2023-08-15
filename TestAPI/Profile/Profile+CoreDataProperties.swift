//
//  Profile+CoreDataProperties.swift
//  TestAPI
//
//  Created by Thejas K on 15/08/23.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var age: String?
    @NSManaged public var mobile: String?
    @NSManaged public var name: String?
    @NSManaged public var profilePicture: Data?

}

extension Profile : Identifiable {

}
