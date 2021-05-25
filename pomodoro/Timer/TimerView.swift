//
//  TimerView.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TimerView: UIView {
    
    // MARK: - Properties
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = Color.black
        return label
    }()
    
    var timerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.black
        let normalAttributedString = NSAttributedString(string: "Start", attributes: [
            NSAttributedString.Key.foregroundColor: Color.white,
        ])
        let selectedAttributedString = NSAttributedString(string: "Pause", attributes: [
            NSAttributedString.Key.foregroundColor: Color.white,
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(selectedAttributedString, for: .selected)
        return button
    }()
    
    var stopTimerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.black
        let normalAttributedString = NSAttributedString(string: "Stop", attributes: [
            NSAttributedString.Key.foregroundColor: Color.white,
        ])
        button.setAttributedTitle(normalAttributedString, for: .normal)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    private func setupConstraints() {
        timeLabel.anchor(centerX: centerXAnchor,
                         centerY: centerYAnchor)
        
        timerButton.anchor(top: timeLabel.bottomAnchor,
                           left: leftAnchor,
                           right: rightAnchor,
                           topPadding: 10,
                           leftPadding: 18,
                           rightPadding: 18,
                           height: 45)
        
        stopTimerButton.anchor(top: timerButton.bottomAnchor,
                               left: timerButton.leftAnchor,
                               right: timerButton.rightAnchor,
                               topPadding: 10,
                               height: 45)
    }
    
    private func addSubviews() {
        [timeLabel, timerButton, stopTimerButton]
            .forEach { addSubview($0) }
    }
}
