//
//  TimerManager.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol TimerManagerDelegate: class {
    func didChangeTimerState(to state: TimerState)
    func didChangeTime(to time: TimeInterval)
}

protocol TimerManagerProtocol {
    var delegate: TimerManagerDelegate? { get set }
    func changeState()
    func stopTimer()
}

enum TimerState {
    case start
    case pause
    case stop
}

class TimerManager: TimerManagerProtocol {
    
    // MARK: - Properties
    var delegate: TimerManagerDelegate?
    
    var timer: Timer?
    var endDate: Date?
    var secondsLeft: TimeInterval = 100 {
        willSet(newValue) {
            delegate?.didChangeTime(to: newValue)
        }
    }
    
    // MARK: - Status
    var active: Bool {
        return timer != nil && endDate != nil
    }
    
    var deactive: Bool {
        return timer == nil || (timer != nil && endDate == nil)
    }
    
    // MARK: - Handlers
    func changeState() {
        if deactive {
            startTimer()
        } else if active {
            pauseTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        secondsLeft = 100
        timer = nil
        endDate = nil
        
        delegate?.didChangeTimerState(to: .stop)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        endDate = Date().addingTimeInterval(secondsLeft)
        
        delegate?.didChangeTimerState(to: .start)
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        endDate = nil
        
        delegate?.didChangeTimerState(to: .pause)
    }
    
    @objc private func timerTick() {
        secondsLeft -= 1
        
        if secondsLeft == 0 {
            stopTimer()
        }
    }
}
