//
//  NewTaskCoordinator.swift
//  pomodoro
//
//  Created by vlsuv on 28.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

class NewTaskCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let navigationController: UINavigationController
    
    var modalNavigationController: UINavigationController?
    
    var parentCoordinator: Coordinator?
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func start() {
        let newTaskViewModel = NewTaskViewModel()
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
