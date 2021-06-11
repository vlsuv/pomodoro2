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
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    let navigationController: UINavigationController
    
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
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) else { return }
        
        childCoordinators.remove(at: index)
    }
    
    func showNewTask() {
        let newTaskCoordinator = NewTaskCoordinator(navigationController: navigationController)
        
        newTaskCoordinator.parentCoordinator = self
        childCoordinators.append(newTaskCoordinator)
        
        newTaskCoordinator.start()
    }
}
