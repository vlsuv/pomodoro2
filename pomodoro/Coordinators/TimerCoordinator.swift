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
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    let navigationController: UINavigationController
    
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
    
    // MARK: - Handlers
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        
        childCoordinators.remove(at: index)
    }
    
    func showTaskList() {
        let taskListCoordinator = TaskListCoordinator(navigationController: navigationController)
        
        taskListCoordinator.parentCoordinator = self
        childCoordinators.append(taskListCoordinator)
        
        taskListCoordinator.start()
    }
}
