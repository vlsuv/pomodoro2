//
//  NewTaskSectionModel.swift
//  pomodoro
//
//  Created by vlsuv on 30.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

enum NewTaskSectionModel {
    case descriptionSection(items: [NewTaskSectionItem])
    case timeSection(items: [NewTaskSectionItem])
}

enum NewTaskSectionItem {
    case textFieldSectionItem(placeholderText: String, bind: BehaviorSubject<String>)
    case pickerSectionItem(titleText: String, timeInterval: [Int], bind: BehaviorSubject<Int>)
}

extension NewTaskSectionModel: SectionModelType {
    typealias Item = NewTaskSectionItem
    
    var items: [NewTaskSectionItem] {
        switch self {
        case .descriptionSection(items: let items):
            return items.map { $0 }
        case .timeSection(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: NewTaskSectionModel, items: [NewTaskSectionItem]) {
        switch original {
        case .descriptionSection(items: let items):
            self = .descriptionSection(items: items)
        case .timeSection(items: let items):
            self = .timeSection(items: items)
        }
    }
}
