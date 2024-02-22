//
//  ProfileDataRepository.swift
//  TestAPI
//
//  Created by Thejas K on 20/02/24.
//

import Foundation
import CoreData

protocol ProfileDataRepositoryProtocol {
    
    func create(user: UserProfile)
    func getUserBy(id: UUID) -> UserProfile?
    func getUserBy(user_id: String) -> UserProfile?
    func getAllUsers() -> [UserProfile]?
    func updateUser(user: UserProfile) -> Bool
    func deleteUser(user: UserProfile) -> Bool
    
}

struct DataRepo : ProfileDataRepositoryProtocol {
    
    func create(user: UserProfile) {
        let profile = Profile(context: Storage.shared.context)
        
        profile.email_id = user.email_id
        profile.user_id = user.user_id
        profile.id = user.id
        
        Storage.shared.saveContext()
    }
    
    func getUserBy(id: UUID) -> UserProfile? {
        
        let user = getProfileBy(id: id)
        guard user != nil else {return nil}
        return user?.convertToUser()
    }
    
    func getUserBy(user_id: String) -> UserProfile? {
        
        guard let profiles = getAllUsers() else {return nil}
        
        for profile in profiles {
            if profile.user_id == user_id {
                return profile
            }
        }
        
        return nil
    }
    
    func getAllUsers() -> [UserProfile]? {
        
        let profiles = Storage.shared.fetchManagedObject(managedObject: Profile.self)
        
        var userProfiles = [UserProfile]()
        
        profiles?.forEach({ user in
            userProfiles.append(user.convertToUser())
        })
        
        if userProfiles.count > 0 {
            return userProfiles
        }
        
        return nil
    }
    
    func updateUser(user: UserProfile) -> Bool {
        
        var profile = getProfileBy(id: user.id)
        
        guard profile != nil else {return false}
        
        profile?.email_id = user.email_id
        profile?.user_id = user.user_id
        profile?.age = user.age
        profile?.mobile = user.mobile
        profile?.profilePicture = user.profilePicture
        profile?.watch_history_data = user.watch_history_data
        profile?.name = user.name
        
        Storage.shared.saveContext()
        return true
    }
    
    func deleteUser(user: UserProfile) -> Bool {
        
        //guard let user_id = user.user_id else {return false}
        
        let user = getProfileBy(id: user.id)
        
        guard user != nil else {return false}
        
        Storage.shared.context.delete(user!)
        Storage.shared.saveContext()
        return true
    }
    
    private func getProfileBy(id:UUID) -> Profile? {
        
        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        let predicate = NSPredicate(format: "id==%@",id as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let user = try Storage.shared.context.fetch(fetchRequest).first
            guard user != nil else {return nil}
            
            return user
        }
        catch {
            print(error)
        }
        
        return nil
        
    }
    
}
