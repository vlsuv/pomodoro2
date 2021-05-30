//
//  TaskListSectionModel.swift
//  pomodoro
//
//  Created by vlsuv on 30.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RxDataSources

struct TaskListSection {
    var header: String
    var items: [Item]
}

extension TaskListSection: AnimatableSectionModelType {
    typealias Item = Task
    
    var identity: String {
        return header
    }
    
    init(original: TaskListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
