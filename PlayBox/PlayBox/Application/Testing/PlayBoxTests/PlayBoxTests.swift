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
import XCTest
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

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate!
    var mockWindow: UIWindow!

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        mockWindow = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window = mockWindow
    }

    override func tearDown() {
        appDelegate = nil
        mockWindow = nil
        super.tearDown()
    }

    // ✅ Test if routeApp correctly loads the Login Screen
    func testRouteAppLoadsLoginScreen() {
        appDelegate.routeApp(route: .Login)
        XCTAssertTrue(appDelegate.window?.rootViewController is UINavigationController)
    }

    // ✅ Test if routeApp correctly loads the Home Screen
    func testRouteAppLoadsHomeScreen() {
        appDelegate.routeApp(route: .Home)
        XCTAssertTrue(appDelegate.window?.rootViewController is UITabBarController)
    }

    // ✅ Test if setting rootViewController changes the window’s root controller
    func testSetRootViewController() {
        let mockViewController = UIViewController()
        appDelegate.setRootViewController(rootViewController: mockViewController, animated: false)
        
        XCTAssertEqual(appDelegate.window?.rootViewController, mockViewController)
    }

    // ✅ Test logout should route to the Login screen
    func testLogoutRoutesToLogin() {
        appDelegate.logout()
        XCTAssertTrue(appDelegate.window?.rootViewController is UINavigationController)
    }

    // ✅ Test application(_:open:options:) handles Google Sign-In URL
    func testGoogleSignInHandlesURL() {
        let url = URL(string: "com.googleusercontent.apps.303494541957-2gj7v5hsb9fcbhkeplen528sjpb2nscu.apps.googleusercontent.com:/oauth2redirect")!
        let handled = appDelegate.application(UIApplication.shared, open: url, options: [:])
        XCTAssertTrue(handled)
    }
}
