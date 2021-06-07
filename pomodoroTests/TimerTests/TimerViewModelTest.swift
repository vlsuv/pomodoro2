//
//  TimerViewModelTest.swift
//  pomodoroTests
//
//  Created by vlsuv on 03.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import pomodoro

class TimerViewModelTest: XCTestCase {
    
    var sut: TimerViewModel?
    var timerManagerMock: TimerManagerMock?
    var spyTimerCoordinator: SpyTimerCoordinator?
    
    override func setUpWithError() throws {
        sut = TimerViewModel()
        
        timerManagerMock = TimerManagerMock()
        timerManagerMock?.delegate = sut
        
        sut?.timerManager = timerManagerMock
        
        spyTimerCoordinator = SpyTimerCoordinator(navigationController: UINavigationController())
        sut?.coordinator = spyTimerCoordinator
    }
    
    override func tearDownWithError() throws {
        sut = nil
        timerManagerMock = nil
        spyTimerCoordinator = nil
    }
    
    func testInitTimerViewModel() {
        XCTAssertNotNil(sut)
    }
    
    func testWhenInitTimerViewModelTimerManagerIsNotNil() {
        XCTAssertNotNil(sut?.timerManager)
    }
    
    func testWhenInitTimerViewModelTimerCoordinatorIsNotNil() {
        XCTAssertNotNil(sut?.coordinator)
    }
    
    func testWhenTapTimerButtonChangeCurrentTimeAndTimerState() throws {
        sut?.didTapTimerButton()
        
        XCTAssertEqual(try sut?.currentTime.toBlocking().first(), "100.0")
        XCTAssertEqual(try sut?.timerState.toBlocking().first(), TimerState.start)
    }
    
    func testWhenTapStopTimerButtonChangeTimerStateToStop() throws {
        sut?.didTapStopTimerButton()
        
        XCTAssertEqual(try sut?.timerState.toBlocking().first(), TimerState.stop)
    }
    
    func testWhenTapTaskListButtonShowTaskList() {
        guard let spyTimerCoordinator = spyTimerCoordinator else {
            XCTFail()
            return
            
        }
        sut?.didTapTaskListButton()
        XCTAssertTrue(spyTimerCoordinator.showTaskListCall)
    }
}

extension TimerViewModelTest {
    class TimerManagerMock: TimerManagerProtocol {
        var delegate: TimerManagerDelegate?
        
        func changeState() {
            delegate?.didChangeTimerState(to: .start)
            delegate?.didChangeTime(to: 100)
        }
        
        func stopTimer() {
            delegate?.didChangeTimerState(to: .stop)
        }
    }
    
    class SpyTimerCoordinator: TimerCoordinator {
        var showTaskListCall: Bool = false
        
        override func showTaskList() {
            showTaskListCall = true
        }
    }
}
