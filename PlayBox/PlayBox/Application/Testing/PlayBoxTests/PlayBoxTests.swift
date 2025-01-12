//
//  PlayBoxTests.swift
//  PlayBoxTests
//
//  Created by Thejas on 10/01/25.
//

import Testing
import UIKit
import CoreData
@testable import PlayBox

struct PlayBoxTests {

    @Test func testBackgroundColor() async throws {
        
        let viewController = await ViewController()
        
        await viewController.loadViewIfNeeded()
        
        let bgColor = await viewController.view.backgroundColor
        
        #expect(bgColor == .systemBlue)
        
    }
    
    @Test func testCoreData() async throws {
        
        if let delegate = await UIApplication.shared.delegate as? AppDelegate {
            
            #expect(await delegate.persistentContainer != nil)
            
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            
            await delegate.persistentContainer.persistentStoreDescriptions = [description]
            
            await delegate.persistentContainer.loadPersistentStores { storeDescription, error in
                
                if let error = error as? NSError {
                    #expect(error != nil)
                }
                
                #expect(storeDescription != nil)
                
            }
            
            await delegate.saveContext()
            
            #expect(await delegate.changesSaved == false)
            
            
        }
    }

}
