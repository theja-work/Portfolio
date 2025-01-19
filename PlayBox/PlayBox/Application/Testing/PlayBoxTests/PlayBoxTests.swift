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
        
        let viewController = await HomeViewController()
        
        await viewController.loadViewIfNeeded()
        
        let bgColor = await viewController.view.backgroundColor
        
        #expect(bgColor == UIColor.systemGreen)
        
    }
    
    @Test func testCoreData() async throws {
        
        
    }

}
