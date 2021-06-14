//
//  NewTaskCoordinator.swift
//  pomodoro
//
//  Created by vlsuv on 28.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

enum NewTaskPageType {
    case newTask
    case editTask(task: Task)
}

class NewTaskCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    let navigationController: UINavigationController
    
    var modalNavigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    
    var type: NewTaskPageType
    
    // MARK: - Init
    init(navigationController: UINavigationController, type: NewTaskPageType) {
        self.navigationController = navigationController
        self.type = type
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func start() {
        let newTaskViewModel = NewTaskViewModel(type: type)
        newTaskViewModel.coordinator = self
        
        let newTaskController = NewTaskController()
        newTaskController.viewModel = newTaskViewModel
        
        modalNavigationController = UINavigationController()
        modalNavigationController?.viewControllers = [newTaskController]
        
        guard let modalNavigationController = modalNavigationController else { return }
        
        navigationController.present(modalNavigationController, animated: true, completion: nil)
    }
    
    // MARK: - Handlers
    func viewDidDisappear() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishCreatingTask() {
        parentCoordinator?.childDidFinish(self)
        modalNavigationController?.dismiss(animated: true, completion: nil)
    }
}
