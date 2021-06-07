//
//  TimerControllerTest.swift
//  pomodoroTests
//
//  Created by vlsuv on 03.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import XCTest
import RxCocoa
import RxBlocking

@testable import pomodoro

class TimerControllerTest: XCTestCase {
    
    var sut: TimerController?
    var mockTimerViewModel: MockTimerViewModel?

    override func setUpWithError() throws {
        sut = TimerController()
        
        mockTimerViewModel = MockTimerViewModel()
        sut?.viewModel = mockTimerViewModel
        
        sut?.loadView()
        sut?.viewDidLoad()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockTimerViewModel = nil
    }
    
    func testInitTimerController() {
        XCTAssertNotNil(sut, "TimerController is nil")
    }
    
    func testWhenInitViewModelIsNotNil() {
        XCTAssertNotNil(sut?.viewModel, "MockTimerViewModel is nil")
    }
    
    func testWhenInitTimerViewIsNotNilAndAddedToView() {
        guard let contentView = sut?.contentView, let subviews = sut?.view.subviews else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(contentView, "TimerView is nil")
        XCTAssertTrue(subviews.contains(contentView), "view does not contains TimerView")
    }
    
    func testWhenTapTaskListButtonHandleCall() {
        guard let taskListButton = sut?.navigationItem.rightBarButtonItem, let action = taskListButton.action else {
            XCTFail()
            return
        }
        
        sut?.performSelector(onMainThread: action, with: taskListButton, waitUntilDone: true)
        XCTAssertTrue(mockTimerViewModel!.showTaskList)
    }
    
    func testWhenTapToTimerButtonCallStartTimer() throws {
        guard let timerButton = sut?.contentView.timerButton else {
            XCTFail()
            return
        }
        
        timerButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(try sut?.viewModel?.outputs.timerState.toBlocking().first(), TimerState.start)
        XCTAssertTrue(timerButton.isSelected)
    }
    
    func testWhenTwoTapTimerButtonCallPause() throws {
        guard let timerButton = sut?.contentView.timerButton else {
            XCTFail()
            return
        }
         
        timerButton.sendActions(for: .touchUpInside)
        timerButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(try sut?.viewModel?.outputs.timerState.toBlocking().first(), TimerState.pause)
        XCTAssertFalse(timerButton.isSelected)
    }
    
    func testWhenTapStopButtonCallStop() throws {
        guard let stopTimerButton = sut?.contentView.stopTimerButton, let timerButton = sut?.contentView.timerButton else {
            XCTFail()
            return
        }
        
        stopTimerButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(try sut?.viewModel?.outputs.timerState.toBlocking().first(), TimerState.stop)
        XCTAssertFalse(timerButton.isSelected)
    }
    
}

extension TimerControllerTest {
    class MockTimerViewModel: TimerViewModelType, TimerViewModelInputs, TimerViewModelOutputs {
        
        var inputs: TimerViewModelInputs { return self }
        var outputs: TimerViewModelOutputs { return self }
        
        var currentTime: BehaviorRelay<String>
        var timerState: BehaviorRelay<TimerState>
        
        var showTaskList: Bool = false
        
        init() {
            self.currentTime = .init(value: "00:00")
            self.timerState = .init(value: .stop)
        }
        
        func didTapTimerButton() {
            if timerState.value == .start {
                timerState.accept(.pause)
            } else {
                timerState.accept(.start)
            }
        }
        
        func didTapStopTimerButton() {
            timerState.accept(.stop)
        }
        
        
        func didTapTaskListButton() {
            showTaskList = true
        }
    }
}


