//
//  TimerManagerTest.swift
//  pomodoroTests
//
//  Created by vlsuv on 04.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
@testable import pomodoro

class TimerManagerTest: XCTestCase {
    
    var sut: TimerManager?
    var mockViewModel: MockViewModel?

    override func setUpWithError() throws {
        sut = TimerManager()

        mockViewModel = MockViewModel()
        mockViewModel?.timerManager = sut
        
        sut?.delegate = mockViewModel
    }

    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
    }
    
    func testInitTimerManager() {
        XCTAssertNotNil(sut)
    }
    
    func testInitMockViewModel() {
        XCTAssertNotNil(mockViewModel)
    }
    
    func testCheckDelegateMockViewModel() {
        XCTAssertTrue(mockViewModel === sut?.delegate)
    }
    
    func testWhenTapChangeStateTimerActive() {
        sut?.changeState()
        
        XCTAssertTrue(sut!.active)
        XCTAssertNotNil(sut!.timer)
        XCTAssertNotNil(sut!.endDate)
        
        XCTAssertTrue(mockViewModel!.timerState == .start)
    }
    
    func testWhenTwoTapChangeStateTimerPause() {
        sut?.changeState()
        sut?.changeState()
        
        XCTAssertFalse(sut!.active)
        XCTAssertTrue(sut!.deactive)
        XCTAssertNil(sut!.endDate)
        
        XCTAssertTrue(mockViewModel!.timerState == .pause)
    }
    
    func testWhenTapStopTimerStateTimerStop() {
        sut?.changeState()
        sut?.stopTimer()
        
        XCTAssertFalse(sut!.active)
        XCTAssertTrue(sut!.deactive)
        XCTAssertNil(sut!.timer)
        XCTAssertNil(sut!.endDate)
        
        XCTAssertTrue(mockViewModel!.timerState == .stop)
    }
}

extension TimerManagerTest {
    class MockViewModel: TimerManagerDelegate {
        
        var timerManager: TimerManagerProtocol?
        
        var timerState: TimerState = .stop
        var changeTimerCall: Bool = false
        
        func didChangeTimerState(to state: TimerState) {
            timerState = state
        }
        
        func didChangeTime(to time: TimeInterval) {
            changeTimerCall = true
        }
    }
}
