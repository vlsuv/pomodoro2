//
//  AppCoordinator.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get }
    func childDidFinish(_ childCoordinator: Coordinator)
    func start()
}

extension Coordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {}
}

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private(set) var childCoordinators: [Coordinator] = [Coordinator]()
    
    private let window: UIWindow
    
    let navigationController: UINavigationController
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let timerCoordinator = TimerCoordinator(navigationController: navigationController)
        timerCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
