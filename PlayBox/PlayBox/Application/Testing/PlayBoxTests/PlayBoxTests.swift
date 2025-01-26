//
//  PlayBoxTests.swift
//  PlayBoxTests
//
//  Created by Thejas on 10/01/25.
//

import Testing
import UIKit
import CoreData
import GoogleSignIn
@testable import PlayBox

struct PlayBoxTests {
    
    var appDelegate: AppDelegate!
    var appRoute : AppRoutes!

    @Test func testAppDelegate() async throws {
        
        let viewController = await HomeViewController()
        
        await viewController.loadViewIfNeeded()
        
        let bgColor = await viewController.view.backgroundColor
        
        #expect(bgColor == UIColor.systemGreen)
        
    }

}
