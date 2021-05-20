//
//  TimerViewModel.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

protocol TimerViewModelType {
    func didTapTimerButton()
    
    var didChangeTime: ((String) -> ())? { get set }
    var didChangeTimerState: ((TimerState) -> ())? { get set }
}

class TimerViewModel: TimerViewModelType {
    
    // MARK: - Properties
    private var timerManager: TimerManagerProtocol!
    
    var didChangeTime: ((String) -> ())?
    var didChangeTimerState: ((TimerState) -> ())?
    
    init() {
        setupTimerManager()
    }
    
    // MARK: - Handlers
    private func setupTimerManager() {
        timerManager = TimerManager()
        timerManager.delegate = self
    }
    
    func didTapTimerButton() {
        timerManager.changeState()
    }
}

// MARK: - TimerManagerDelegate
extension TimerViewModel: TimerManagerDelegate {
    func didChangeTimerState(to state: TimerState) {
        didChangeTimerState?(state)
    }
    
    func didChangeTime(to time: TimeInterval) {
        didChangeTime?(String(time))
    }
}
