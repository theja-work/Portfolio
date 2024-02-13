//
//  Profile+CoreDataClass.swift
//  TestAPI
//
//  Created by Thejas K on 15/08/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(Profile)
public class Profile: NSManagedObject {
    
    public class func logout(userID:String) {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}

        let user = Profile(context: context)

//        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Profile")
//
//        request.returnsObjectsAsFaults = false
//
//        do {
//
//            let result = try context.fetch(request)
//
//            for data in result as! [NSManagedObject] {
//                if let user_id = data.value(forKey: "user_id") as? String {
//
//                    if let value = AppUserDefaults.getUserID() {
//
//                        if user_id == value {
//
//                            let user = Profile(context: context)
//
//                            user.user_id = ""
//                            user.email_id = ""
//
//                            try context.save()
//
//                        }
//
//                    }
//
//                }
//            }
//
//        }
//        catch {
//            print(error)
//        }
        
        
        
        do {

            user.age = ""
            user.mobile = ""
            user.name = ""
            user.profilePicture = nil
            user.email_id = ""
            user.user_id = ""
            try context.save()

        }
        catch {
            print(error)
        }
        
    }
    
    public class func login(userID:String,email_id:String) {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return}
        
        let user = Profile(context: context)
        
        user.user_id = userID
        
        AppUserDefaults.userId.setValue(userID)
        
        user.email_id = email_id
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
        
    }
    
    public class func hasUserLoggedIn() -> Bool {
        
        var email_id = ""
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Profile")

        request.returnsObjectsAsFaults = false

        do {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return false}

            let result = try context.fetch(request)

            for data in result as! [NSManagedObject] {

                if let value = data.value(forKey: "email_id") as? String {
                    email_id = value
                }
            }

        }

        catch {
            print(error)
        }
        
        print("hasUserLoggedIn : \(email_id)")
        
        if !StringHelper.isNilOrEmpty(string: email_id) {
            return true
        }
        
        return false
        
    }
    
    public class func getUserID() -> String? {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
        
        let user = Profile(context: context)
        
        let user_id = user.user_id
        
        if !StringHelper.isNilOrEmpty(string: user_id) {
            return user_id
        }
        
        return nil
    }
    
    public class func getEmailId() -> String? {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
        
        let user = Profile(context: context)
        
        let email_id = user.email_id
        
        if !StringHelper.isNilOrEmpty(string: email_id) {
            return email_id
        }
        
        return nil
    }
    
    public class func getProfilePic() -> UIImage? {
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Profile")

        request.returnsObjectsAsFaults = false

        var profilePic : UIImage?
        
        do {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}

            let result = try context.fetch(request)

            for data in result as! [NSManagedObject] {

                if let value = data.value(forKey: "profilePicture") as? Data {

                    if let image = UIImage(data: value) {
                        profilePic = image
                    }

                }
            }

        }
        catch {
            print(error)
        }
        
        return profilePic
        
    }
    
}
