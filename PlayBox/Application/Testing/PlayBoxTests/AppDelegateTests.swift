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

struct AppDelegateTests_SwiftTesting {
    
    var appDelegate: AppDelegate!
    var mockWindow: UIWindow!

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
        appDelegate.window?.makeKeyAndVisible()
    }

    override func tearDown() {
        appDelegate = nil
        mockWindow = nil
        super.tearDown()
    }

    // ✅ Test if routeApp correctly loads the Login Screen
    func testRouteAppLoadsLoginScreen() {
        appDelegate.routeApp(route: .Login)
        
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "LoginNC")
        
    }

    // ✅ Test if routeApp correctly loads the Home Screen
    func testRouteAppLoadsHomeScreen() {
        appDelegate.routeApp(route: .Home)
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "appTBC")
    }
    
    // ✅ Test if routeApp correctly loads the Login Screen
    func testRouteAppLoadsLoginScreenUsingMethods() {
        appDelegate.loadLoginScreen()
        
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "LoginNC")
        
    }

    // ✅ Test if routeApp correctly loads the Home Screen
    func testRouteAppLoadsHomeScreenUsingMethod() {
        appDelegate.loadAppCoordinator()
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "appTBC")
    }
    
    // ✅ Test if routeApp correctly loads the Login Screen
    func testRouteAppLoadsLoginScreenWithWindowBeingNil() {
        appDelegate.window = nil
        appDelegate.loadLoginScreen()
        XCTAssertNotNil(appDelegate.window)
        XCTAssertTrue(appDelegate.window?.frame == UIScreen.main.bounds)
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "LoginNC")
        
    }

    // ✅ Test if routeApp correctly loads the Home Screen
    func testRouteAppLoadsHomeScreenWithWindowBeingNil() {
        appDelegate.window = nil
        appDelegate.loadAppCoordinator()
        XCTAssertNotNil(appDelegate.window)
        XCTAssertTrue(appDelegate.window?.frame == UIScreen.main.bounds)
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "appTBC")
    }
    
    // Test failure cases of loading login screen
    func testRouteAppLoadsLoginScreenFailedCase() {
        appDelegate.routeApp(route: .Login)
        
        XCTAssertFalse(appDelegate.window?.rootViewController?.restorationIdentifier == "")
        
    }

    // Test failure cases of loading home screen
    func testRouteAppLoadsHomeScreenFailedCase() {
        appDelegate.routeApp(route: .Home)
        XCTAssertFalse(appDelegate.window?.rootViewController?.restorationIdentifier == "")
    }
    
    // ✅ Test if setting rootViewController changes the window’s root controller
    func testSetRootViewController() {
        let mockViewController = UIViewController()
        appDelegate.setRootViewController(rootViewController: mockViewController, animated: false)
        
        XCTAssertEqual(appDelegate.window?.rootViewController, mockViewController)
    }
    
    func testSetRootViewControllerFailureCase() {
        
        appDelegate.setRootViewController(rootViewController: nil)
        
        XCTAssertNil(appDelegate.window?.rootViewController)
    }
    
    func testSetRootViewControllerFailureCaseWithWindowNil() {
        
        appDelegate.window = nil
        
        appDelegate.setRootViewController(rootViewController: nil)
        
        XCTAssertNotNil(appDelegate.window)
        XCTAssertTrue(appDelegate.window?.frame == UIScreen.main.bounds)
        XCTAssertNil(appDelegate.window?.rootViewController)
    }

    // ✅ Test logout should route to the Login screen
    func testLogoutRoutesToLogin() {
        appDelegate.logout()
        XCTAssertTrue(appDelegate.window?.rootViewController?.restorationIdentifier == "LoginNC")
    }
    
    func testLogoutRoutesToLoginFailed() {
        appDelegate.logout()
        XCTAssertFalse(appDelegate.window?.rootViewController?.restorationIdentifier == "")
    }
    
    func testDidFinishLaunchingWithOptions() {
        let application = UIApplication.shared
        let options: [UIApplication.LaunchOptionsKey: Any] = [:]
        
        let result = appDelegate.application(application, didFinishLaunchingWithOptions: options)
        
        XCTAssertTrue(result, "App should return true on successful launch")
    }

}
