//
//  NewTaskCoordinatorTest.swift
//  pomodoroTests
//
//  Created by vlsuv on 11.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import pomodoro

class NewTaskCoordinatorTest: XCTestCase {
    
    var sutNewTaskCoordinator: NewTaskCoordinator?
    var mockNavigationController: MockNavigationController?

    override func setUpWithError() throws {
        mockNavigationController = MockNavigationController()
        sutNewTaskCoordinator = NewTaskCoordinator(navigationController: mockNavigationController!)
    }

    override func tearDownWithError() throws {
        mockNavigationController = nil
        sutNewTaskCoordinator = nil
    }
    
    func testInitSutNewTaskCoordinator() {
        XCTAssertNotNil(sutNewTaskCoordinator)
    }
    
    func testInitMockNavigationController() {
        XCTAssertNotNil(mockNavigationController)
    }
    
    func testModalNavigationWhenTapStart() {
        sutNewTaskCoordinator?.start()
        
        XCTAssertNotNil(sutNewTaskCoordinator?.modalNavigationController)
    }
    
    func testWhenTapStartModalNavigationControllerPresent() {
        sutNewTaskCoordinator?.start()
        
        XCTAssertTrue((sutNewTaskCoordinator?.navigationController as! MockNavigationController).viewControllerPresent === sutNewTaskCoordinator?.modalNavigationController)
    }
    
    func testViewDidDisappear() {
        let spyCoordinator = SpyCoordinator()
        
        sutNewTaskCoordinator?.parentCoordinator = spyCoordinator
        
        sutNewTaskCoordinator?.viewDidDisappear()
        
        XCTAssertTrue(spyCoordinator.childDidFinishCalls)
    }
    
    func testWhenFinishCreatingTask() {
        let spyCoordinator = SpyCoordinator()
        
        sutNewTaskCoordinator?.parentCoordinator = spyCoordinator
        
        sutNewTaskCoordinator?.didFinishCreatingTask()
        
        XCTAssertTrue(spyCoordinator.childDidFinishCalls)
    }
}
