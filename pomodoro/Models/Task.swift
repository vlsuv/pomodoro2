//
//  Task.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RxDataSources

struct Task {
    var id: UUID
    var name: String
}

extension Task: IdentifiableType, Equatable {
    typealias Identity = UUID
    
    var identity: Identity { return id }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
