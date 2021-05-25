//
//  TimerCoordinator.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TimerCoordinator: Coordinator {
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let timerViewModel = TimerViewModel()
        timerViewModel.coordinator = self
        
        let timerController = TimerController()
        timerController.viewModel = timerViewModel
        
        navigationController.viewControllers = [timerController]
    }
}
