//
//  TimerCoordinatorTest.swift
//  pomodoroTests
//
//  Created by vlsuv on 11.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import pomodoro

class TimerCoordinatorTest: XCTestCase {
    
    var sutTimerCoordinator: TimerCoordinator?
    var mockNavigationController: MockNavigationController?
    
    override func setUpWithError() throws {
        mockNavigationController = MockNavigationController()
        sutTimerCoordinator = TimerCoordinator(navigationController: mockNavigationController!)
    }
    
    override func tearDownWithError() throws {
        sutTimerCoordinator = nil
        mockNavigationController = nil
    }
    
    func testInitSutTimerCoordinator() {
        XCTAssertNotNil(sutTimerCoordinator)
    }
    
    func testInitMockNavigationController() {
        XCTAssertNotNil(mockNavigationController)
    }
    
    func testWhenTapStartViewControllerOfNavigationController() {
        sutTimerCoordinator?.start()
        
        XCTAssertEqual(sutTimerCoordinator?.navigationController.viewControllers.count, 1)
        XCTAssertTrue(sutTimerCoordinator?.navigationController.viewControllers.first is TimerController)
    }
    
    func testChildCoordinatorsWhenTapShowTaskList() {
        sutTimerCoordinator?.showTaskList()
        
        XCTAssertEqual(sutTimerCoordinator?.childCoordinators.count, 1)
        XCTAssertTrue(sutTimerCoordinator?.childCoordinators.first is TaskListCoordinator)
    }
    
    func testNavigationControllerPresentingWhenTapShowTaskList() {
        sutTimerCoordinator?.showTaskList()
        
        XCTAssertTrue((sutTimerCoordinator?.navigationController as! MockNavigationController).viewControllerPresent is TaskListController)
    }
    
    func testChildDidFinish() {
        let mockChildCoordinator = MockChildCoordinator()
        
        mockChildCoordinator.parentCoordinator = sutTimerCoordinator
        sutTimerCoordinator?.childCoordinators.append(mockChildCoordinator)
        
        XCTAssertEqual(sutTimerCoordinator?.childCoordinators.count, 1)
        XCTAssertTrue(mockChildCoordinator.parentCoordinator === sutTimerCoordinator)
        
        mockChildCoordinator.finishCoordinator()
        
        XCTAssertEqual(sutTimerCoordinator?.childCoordinators.count, 0)
    }
    
    func testWhenTapShowTaskListChildCoordinators() {
        sutTimerCoordinator?.showTaskList()
        
        XCTAssertEqual(sutTimerCoordinator?.childCoordinators.count, 1)
        XCTAssertTrue(sutTimerCoordinator?.childCoordinators.first is TaskListCoordinator)
    }
}
