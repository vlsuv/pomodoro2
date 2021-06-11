//
//  TaskListCoordinatorTest.swift
//  pomodoroTests
//
//  Created by vlsuv on 11.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import pomodoro

class TaskListCoordinatorTest: XCTestCase {
    
    var sutTaskListCoordinator: TaskListCoordinator?
    var mockNavigationController: MockNavigationController?

    override func setUpWithError() throws {
        mockNavigationController = MockNavigationController()
        sutTaskListCoordinator = TaskListCoordinator(navigationController: mockNavigationController!)
    }

    override func tearDownWithError() throws {
        mockNavigationController = nil
        sutTaskListCoordinator = nil
    }
    
    func testInitSutTaskListCoordinator() {
        XCTAssertNotNil(sutTaskListCoordinator)
    }
    
    func testInitMockNavigationController() {
        XCTAssertNotNil(mockNavigationController)
    }
    
    func testWhenTapStartModalNavigationControllerPresentTaskListController() {
        sutTaskListCoordinator?.start()
        
        XCTAssertNotNil((sutTaskListCoordinator?.navigationController as! MockNavigationController).viewControllerPresent is TaskListController)
    }
    
    func testWhenViewWillDisappearCalledInParentCoordinator() {
        let spyCoordinator = SpyCoordinator()
        
        sutTaskListCoordinator?.parentCoordinator = spyCoordinator
        
        XCTAssertTrue(sutTaskListCoordinator?.parentCoordinator === spyCoordinator)
        
        sutTaskListCoordinator?.viewWillDisappear()
        
        XCTAssertTrue(spyCoordinator.childDidFinishCalls)
    }
    
    func testChildDidFinish() {
        let mockChildCoordinator = MockChildCoordinator()
        
        mockChildCoordinator.parentCoordinator = sutTaskListCoordinator
        sutTaskListCoordinator?.childCoordinators.append(mockChildCoordinator)
        
        XCTAssertEqual(sutTaskListCoordinator?.childCoordinators.count, 1)
        XCTAssertTrue(sutTaskListCoordinator?.childCoordinators.first === mockChildCoordinator)
        
        mockChildCoordinator.finishCoordinator()
        
        XCTAssertEqual(sutTaskListCoordinator?.childCoordinators.count, 0)
    }
    
    func testWhenTapShowNewTaskChildCoordinators() {
        sutTaskListCoordinator?.showNewTask()
        
        XCTAssertEqual(sutTaskListCoordinator?.childCoordinators.count, 1)
        XCTAssertTrue(sutTaskListCoordinator?.childCoordinators.first is NewTaskCoordinator)
    }
    
    
    
}

