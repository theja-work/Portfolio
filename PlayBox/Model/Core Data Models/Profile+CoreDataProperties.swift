//
//  Profile+CoreDataProperties.swift
//  PlayBox
//
//  Created by Thejas on 19/01/25.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var age: Int16
    @NSManaged public var createdOn: Date?
    @NSManaged public var gender: String?
    @NSManaged public var profilePic: Data?
    @NSManaged public var status: String?
    @NSManaged public var mainUser: User?
    @NSManaged public var childUser: User?

}

extension Profile : Identifiable {

}
