//
//  AppUtilities.swift
//  PlayBox
//
//  Created by Thejas on 12/02/25.
//

import Foundation

final class AppUtilities {
    
    static let shared = AppUtilities()
    
    private init(){}
    
    func log(_ message: String,
             file: String = #file,
             function: String = #function,
             line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):\(function)] \(line) - \(message)")
    }
    
}
