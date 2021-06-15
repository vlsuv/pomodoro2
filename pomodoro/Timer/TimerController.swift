//
//  TimerController.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift

class TimerController: UIViewController {
    
    // MARK: - Properties
    var viewModel: TimerViewModelType?
    
    var contentView: TimerView!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        setupContentView()
        setupTargets()
        setupBindings()
        configureNavigationController()
    }
    
    // MARK: - Targets
    @objc private func didTapTimerButton() {
        viewModel?.inputs.didTapTimerButton()
    }
    
    @objc private func didTapStopTimerButton() {
        viewModel?.inputs.didTapStopTimerButton()
    }
    
    @objc private func didTapTaskListButton() {
        viewModel?.inputs.didTapTaskListButton()
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        let taskListButton = UIBarButtonItem(title: "Tasks", style: .plain, target: self, action: #selector(didTapTaskListButton))
        navigationItem.rightBarButtonItem = taskListButton
    }
    
    private func setupContentView() {
        contentView = TimerView(frame: view.bounds)
        view.addSubview(contentView)
    }
    
    private func setupTargets() {
        contentView.timerButton.addTarget(self, action: #selector(didTapTimerButton), for: .touchUpInside)
        contentView.stopTimerButton.addTarget(self, action: #selector(didTapStopTimerButton), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel?.outputs.timerState
            .asDriver()
            .drive(onNext: { [weak self] timerState in
                
                switch timerState {
                case .start:
                    self?.contentView.timerButton.isSelected = true
                case .pause:
                    self?.contentView.timerButton.isSelected = false
                case .stop:
                    self?.contentView.timerButton.isSelected = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel?.outputs.currentTime
            .asDriver()
            .drive(onNext: { [weak self] time in
                
                self?.contentView.timeLabel.text = time
            })
            .disposed(by: disposeBag)
        
        viewModel?.outputs.task
            .asDriver()
            .drive(onNext: { [weak self] task in
                self?.contentView.taskNameLabel.text = task?.name
            })
            .disposed(by: disposeBag)
    }
}
