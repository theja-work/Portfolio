//
//  AppUserDefaults.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 11/02/24.
//

import Foundation
import CoreData


public enum AppUserDefaults {
    
    case userId
    case current_video_id
    case current_user_uuid
    case all_users_uuid
    
    var key: String {
        switch self {
        
        case .userId :                      return "user_id"
        case .current_video_id :            return "current_video_id"
        case .current_user_uuid:            return "current_user_uuid"
        case .all_users_uuid :              return "all_users_uuid"
        
        }
    }
    
    var value: Any? {
        return UserDefaults.standard.object(forKey: key) as Any?
    }
    
    public func setValue(_ valueToSet: Any) {
        UserDefaults.standard.set(valueToSet, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func remove() {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func getUserID() -> String? {
        
        if let value : String = AppUserDefaults.userId.value as? String {
            return value
        }
        
        return nil
    }
    
    public static func getCurrentUserUUID() -> UUID? {
        
        if let uuid_string = AppUserDefaults.current_user_uuid.value as? String {
            
            if let uuid = UUID(uuidString: uuid_string) {
                return uuid
            }
        }
        
        return nil
    }
    
    
    
    public static func getAllUsersUUID() -> [String]? {
        
        if let value:[String] = AppUserDefaults.all_users_uuid.value as? [String] {
            return value
        }
        
        return nil
    }
    
    public static func getCurrentVideoId() -> String? {
        
        if let value : String = AppUserDefaults.current_video_id.value as? String {
            return value
        }
        
        return nil
    }
    
    
    
}
