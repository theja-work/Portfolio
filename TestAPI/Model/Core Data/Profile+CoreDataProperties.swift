//
//  Profile+CoreDataProperties.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 14/02/24.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var age: String?
    @NSManaged public var email_id: String?
    @NSManaged public var mobile: String?
    @NSManaged public var name: String?
    @NSManaged public var profilePicture: Data?
    @NSManaged public var user_id: String?
    @NSManaged public var watch_history_data: Data?
    @NSManaged public var id: UUID?
    
    func convertToUser() -> UserProfile {
        return UserProfile(age: self.age ,email_id: self.email_id,mobile: self.mobile,name: self.name,profilePicture: self.profilePicture,user_id: self.user_id,watch_history_data: self.watch_history_data, id: self.id!)
    }

}

extension Profile : Identifiable {

}
