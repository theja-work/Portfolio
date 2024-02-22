//
//  Storage.swift
//  TestAPI
//
//  Created by Thejas K on 20/02/24.
//

import Foundation
import CoreData

final class Storage {
    
    private init(){}
    static let shared = Storage()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TestAPI")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
    
    func fetchManagedObject<T:NSManagedObject>(managedObject:T.Type) -> [T]? {
        
        do {
            guard let result = try Storage.shared.context.fetch(managedObject.fetchRequest()) as? [T] else {return nil}
            
            return result
        }
        catch {
            print(error)
        }
        
        return nil
    }

}
