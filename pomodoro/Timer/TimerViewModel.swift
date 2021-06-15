//
//  TimerViewModel.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TimerViewModelInputs {
    func didTapTimerButton()
    func didTapStopTimerButton()
    func didTapTaskListButton()
}

protocol TimerViewModelOutputs {
    var currentTime: BehaviorRelay<String> { get }
    var timerState: BehaviorRelay<TimerState> { get }
    var task: BehaviorRelay<Task?> { get }
}

protocol TimerViewModelType {
    var inputs: TimerViewModelInputs { get }
    var outputs: TimerViewModelOutputs { get }
}

class TimerViewModel: TimerViewModelType, TimerViewModelInputs, TimerViewModelOutputs {
    
    // MARK: - Properties
    var inputs: TimerViewModelInputs { return self }
    var outputs: TimerViewModelOutputs { return self }
    
    var timerManager: TimerManagerProtocol!
    
    private let disposeBag = DisposeBag()
    
    var currentTime: BehaviorRelay<String> = .init(value: "25:00")
    var timerState: BehaviorRelay<TimerState> = .init(value: .stop)
    
    var coordinator: TimerCoordinator?
    
    var task: BehaviorRelay<Task?> = .init(value: nil)
    
    init() {
        setupTimerManager()
        
        NotificationCenter.default.rx.notification(.DidSelectTask)
            .compactMap { $0.object as? Task }
            .bind(to: task)
            .disposed(by: disposeBag)
        
        task.compactMap { $0 }
            .subscribe (onNext: { [weak self] task in
                self?.updateTimer(with: task)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Handlers
    private func setupTimerManager() {
        timerManager = TimerManager()
        timerManager.delegate = self
    }
    
    // MARK: - Input Handlers
    func didTapTimerButton() {
        timerManager.changeState()
    }
    
    func didTapStopTimerButton() {
        timerManager.stopTimer()
    }
    
    func didTapTaskListButton() {
        coordinator?.showTaskList()
    }
}

// MARK: - TimerManagerDelegate
extension TimerViewModel: TimerManagerDelegate {
    func updateTimer(with task: Task) {
        timerManager.updateTimer(time: task.workIntervalSec())
    }
    
    func didChangeTimerState(to state: TimerState) {
        timerState.accept(state)
    }
    
    func didChangeTime(to time: TimeInterval) {
        currentTime.accept(toStringTime(time))
    }
}

// MARK: - Helpers
extension TimerViewModel {
    private func toStringTime(_ time: Double) -> String {
        return String(time)
    }
}
