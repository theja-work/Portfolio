//
//  Storage.swift
//  PlayBox
//
//  Created by Thejas on 15/01/25.
//

import Foundation
import CoreData
import GoogleSignIn

final class Storage {
    
    static let store = Storage()
    
    private init(){}
    
    private var container : NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "PlayBox")
        
        container.loadPersistentStores { storeDescription, error in
            
            if let error = error as? NSError {
                fatalError("Unable to loader persistent stores : \(error.localizedDescription)")
            }
            
        }
//        
//        let entities = container.managedObjectModel.entities
//        for entity in entities {
//            print(entity.name ?? "Unnamed entity")
//        }
        
        return container
    }()
    
    private var context : NSManagedObjectContext {
        container.viewContext
    }
    
    func create<T:NSManagedObject>(_ type:T.Type , predicate : NSPredicate? = nil) -> T?  {
        
        if let objects = read(type, predicate: predicate) , !objects.isEmpty {
            return objects.first
        }
        
        let object = T(context: context)
        
        saveContext()
        
        return object
        
    }
    
    func read<T:NSManagedObject>(_ type:T.Type, predicate : NSPredicate?) -> [T]? {
        
        let request = T.fetchRequest()
        request.predicate = predicate
        
        do {
            if let objects = try context.fetch(request) as? [T] , !objects.isEmpty {
                return objects
            }
        }
        
        catch {
            fatalError("Unable to read objects : \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func update<T:NSManagedObject>(_ type:T.Type , predicate : NSPredicate?) throws {
        
        guard let _ = read(type, predicate: predicate)?.first else { throw StorageErrors.ObjectDoesNotExist }
        
        saveContext()
        
    }
    
    func delete<T:NSManagedObject>(_ type:T.Type , predicate : NSPredicate?) throws {
        
        guard let objects = read(type, predicate: predicate) else { throw StorageErrors.ObjectDoesNotExist }
        
        for object in objects {
            context.delete(object)
        }
        
        saveContext()
        
    }
    
    func resetCoreDataStore(persistentContainer: NSPersistentContainer) {
        
        guard let storeUrl = persistentContainer.persistentStoreDescriptions.first?.url else { return }
        
        let coordinator = persistentContainer.persistentStoreCoordinator
        
        do {
            // Remove the store file
            try coordinator.destroyPersistentStore(at: storeUrl, ofType: NSSQLiteStoreType, options: nil)
            
            // Recreate the persistent store
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
            
            print("Core Data store has been reset.")
        } catch {
            print("Failed to reset Core Data store: \(error)")
        }
    }
    
    func saveContext() {
        
        do {
            if context.hasChanges {
                try context.save()
            }
        }
        
        catch {
            fatalError("Error saving changes to storage : \(error.localizedDescription)")
        }
        
    }
    
    func isRecordExists<T:NSManagedObject>(_ type : T.Type , predicate : NSPredicate?) -> Bool {
        
        read(type, predicate: predicate) != nil
    }
    
    func login() {
        
        if let profile = GIDSignIn.sharedInstance.currentUser?.profile {
            
            let predicate = NSPredicate(format: "email == %@", profile.email)
            
            guard let _ = NSEntityDescription.entity(forEntityName: "User", in: context) else {
                fatalError("Failed to find an NSEntityDescription for 'User'")
            }
            
            guard let _ = NSEntityDescription.entity(forEntityName: "Profile", in: context) else {
                fatalError("Failed to find an NSEntityDescription for 'Profile'")
            }
            
            if !isRecordExists(User.self, predicate: predicate) , let user = create(User.self, predicate: predicate) {
                
                user.email = profile.email
                user.name = profile.name
                
                let createdOn = Date()
                
                let adultPredicate = NSPredicate(format: "createdOn == %@", createdOn as CVarArg)
                
                if let adult = create(Profile.self , predicate: adultPredicate) {
                    
                    adult.age = 30
                    adult.gender = "Male"
                    adult.createdOn = createdOn
                    
                    user.adult = adult
                }
                
                let childPredicate = NSPredicate(format: "createdOn == %@", createdOn + 10 as CVarArg)
                
                if let child = create(Profile.self , predicate: childPredicate) {
                    
                    child.age = 63
                    child.gender = "Female"
                    child.createdOn = createdOn + 10
                    
                    user.child = child
                }
                
                print("User created successfully")
            }
            
            saveContext()
            
        }
        
    }
    
    func deleteAccount() {
        
        if let email = GIDSignIn.sharedInstance.currentUser?.profile?.email {
            
            let predicate = NSPredicate(format: "email == %@", email)
            
            if let user = read(User.self, predicate: predicate) , !user.isEmpty {
                
                do {
                    
                    try delete(User.self, predicate: predicate)
                    
                    GIDSignIn.sharedInstance.signOut()
                }
                
                catch {
                    fatalError("Error deleting user : \(error.localizedDescription)")
                }
                
            }
            
        }
        
    }
    
    func isLoggedinUser(readFromDB : Bool = false) -> Bool {
        
        if readFromDB {
            let request = User.fetchRequest()
            
            do {
                let users = try context.fetch(request)
                
                return users.count != 0
            }
            
            catch {
                print("Error reading logged in user : \(error.localizedDescription)")
            }
        }
        else {
            return GIDSignIn.sharedInstance.hasPreviousSignIn()
        }
        
        return false
    }
    
    func getCurrentUser() -> User? {
        
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            fatalError("No Previous login detected")
        }
        
        if let email = GIDSignIn.sharedInstance.currentUser?.profile?.email {
            
            let predicate = NSPredicate(format: "email == %@", email)
            
            guard let users = read(User.self, predicate: predicate) else {return nil}
            
            if let createdOn = users.first?.adult?.createdOn?.formatted() {
                print("\(email) created on : \(createdOn)")
            }
            
            return users.first
            
        }
        
        return nil
    }
    
}

enum StorageErrors : Error {
    case ObjectExist
    case ObjectDoesNotExist
    
}
