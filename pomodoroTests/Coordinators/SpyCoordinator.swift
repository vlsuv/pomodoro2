//
//  SpyCoordinator.swift
//  pomodoroTests
//
//  Created by vlsuv on 11.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
@testable import pomodoro

class SpyCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    var childDidFinishCalls: Bool = false
    
    func start() {
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        childDidFinishCalls = true
    }
}
