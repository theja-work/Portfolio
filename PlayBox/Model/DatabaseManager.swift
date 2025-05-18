//
//  DatabaseManager.swift
//  PlayBox
//
//  Created by Thejas on 15/01/25.
//

import Foundation
import CoreData
import GoogleSignIn

struct DBManager {
    
    private let dataBase = Storage.store
    
    func createObject<T:NSManagedObject>(object:T.Type , predicate : NSPredicate?) -> T?  {
        
        dataBase.create(object, predicate: predicate)
    }
    
    func getObject<T:NSManagedObject>(object:T.Type , predicate : NSPredicate?) -> T? {
        
        dataBase.read(object, predicate: predicate)?.first
    }
    
    func updateChanges<T:NSManagedObject>(object:T.Type , predicate : NSPredicate?) {
        
        do {
            try dataBase.update(object, predicate: predicate)
        }
        
        catch {
            fatalError("Unable to update changs to DB : \(error.localizedDescription)")
        }
        
    }
    
    func deleteObject<T:NSManagedObject>(object:T.Type , predicate : NSPredicate?) {
        
        do {
            try dataBase.delete(object, predicate: predicate)
        }
        
        catch {
            fatalError("Unable to delete object from DB : \(error.localizedDescription)")
        }
        
    }
    
    func isLoggedinUser(readFromDb : Bool = false) -> Bool {
        dataBase.isLoggedinUser(readFromDB: readFromDb)
    }
    
    func getUser() -> User? {
        dataBase.getCurrentUser()
    }
    
    func deleteUser() {
        
        dataBase.deleteAccount()
    }
    
    func login() {
        dataBase.login()
    }
    
    func saveProfilePic(image:UIImage) {
        if let user = getUser() , let imageData = image.pngData() {
            
            user.adult?.profilePic = imageData
            
            dataBase.saveContext()
            
        }
    }
    
}
