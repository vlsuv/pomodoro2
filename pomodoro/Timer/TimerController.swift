//
//  TimerController.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TimerController: UIViewController {
    
    // MARK: - Properties
    var viewModel: TimerViewModelType = TimerViewModel()
    
    private var contentView: TimerView!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        setupContentView()
        setupTargets()
        
        viewModel.didChangeTimerState = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .start:
                self.contentView.timerButton.isSelected = true
            case .pause:
                self.contentView.timerButton.isSelected = false
            case .stop:
                self.contentView.timerButton.isSelected = false
            }
        }
        
        viewModel.didChangeTime = { [weak self] time in
            guard let self = self else { return }
            
            self.contentView.timeLabel.text = time
        }
    }
    
    // MARK: - Targets
    @objc private func didTapTimerButton() {
        viewModel.didTapTimerButton()
    }
    
    // MARK: - Handlers
    private func setupContentView() {
        contentView = TimerView(frame: view.bounds)
        view.addSubview(contentView)
    }
    
    private func setupTargets() {
        contentView.timerButton.addTarget(self, action: #selector(didTapTimerButton), for: .touchUpInside)
    }
}
