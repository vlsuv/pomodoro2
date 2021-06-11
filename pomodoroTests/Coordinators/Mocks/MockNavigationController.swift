//
//  MockNavigationController.swift
//  pomodoroTests
//
//  Created by vlsuv on 11.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
@testable import pomodoro

class MockNavigationController: UINavigationController {
    var viewControllerPresent: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.viewControllerPresent = viewController
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.viewControllerPresent = viewControllerToPresent
    }
}
