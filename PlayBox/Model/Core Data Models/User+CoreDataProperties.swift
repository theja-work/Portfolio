//
//  User+CoreDataProperties.swift
//  PlayBox
//
//  Created by Thejas on 19/01/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var adult: Profile?
    @NSManaged public var child: Profile?

}

extension User : Identifiable {

}
