//
//  StringHelper.swift
//  TestAPI
//
//  Created by Saranyu's Macbook Pro on 11/02/24.
//

import Foundation
import UIKit

public class StringHelper {
    
   public class func isNilOrEmpty(string:String?) -> Bool
    {
        if string == nil { return true }
        
        if string?.count == 0 { return true }
        
        if string?.trimmingCharacters(in: .whitespaces).count == 0 { return true }
        
        return false
    }
    
    public class func hasSpace(string:String?) -> Bool
    {
        guard let str = string else { return false }
        
        if str.contains(" ")
        {
            return true
        }
        
        return false
    }
    
}
