//
//  MockChildCoordinator.swift
//  pomodoroTests
//
//  Created by vlsuv on 11.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
@testable import pomodoro

class MockChildCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    var parentCoordinator: Coordinator?
    var coodinatorStartCalls: Int = 0
    
    func start() {
        coodinatorStartCalls += 1
    }
    
    func finishCoordinator() {
        parentCoordinator?.childDidFinish(self)
    }
}
