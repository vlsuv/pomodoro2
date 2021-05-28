//
//  TaskListCoordinator.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class TaskListCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func start() {
        let taskListViewModel = TaskListViewModel()
        taskListViewModel.coordinator = self
        
        let taskListController = TaskListController()
        taskListController.viewModel = taskListViewModel
        
        navigationController.pushViewController(taskListController, animated: true)
    }
    
    // MARK: - Handlers
    func viewWillDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
}
