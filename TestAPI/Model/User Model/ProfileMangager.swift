//
//  ProfileMangager.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 14/02/24.
//

import Foundation
import CoreData

struct ProfileMangager {
    
    private let _persistentRepository = ProfileDataRepository()
    
    func createProfile(user:UserProfile) {
        
        _persistentRepository.create(user: user)
    }
    
    func getProfileBy(id:UUID) -> UserProfile? {
        return _persistentRepository.getUserBy(id: id)
    }
    
    func getProfileBy(user_id:String) -> UserProfile? {
        return _persistentRepository.getUserBy(user_id: user_id)
    }
    
    func getAllProfiles() -> [UserProfile]? {
        return _persistentRepository.getAllUsers()
    }
    
    func updateProfile(user:UserProfile) -> Bool {
        return _persistentRepository.updateUser(user: user)
    }
    
    func deleteProfile(user:UserProfile) -> Bool {
        return _persistentRepository.deleteUser(user: user)
    }
    
    func hasLoggedInUser() -> Bool {
        
        if let uuid = AppUserDefaults.getCurrentUserUUID() {
            return true
        }
        
        return false
    }
    
}
