//
//  TaskListViewModel.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol TaskListViewModelInputs {
    func viewWillDisappear()
    func didTapAddTaskButton()
    func didTapDeleteTaskButton(atIndexPath indexPath: IndexPath)
    func didMovedTask(sourceIndex: IndexPath, destinationIndex: IndexPath)
}

protocol TaskListViewModelOutputs {
    var data: Driver<[Task]> { get set }
    func dataSource() -> RxTableViewSectionedAnimatedDataSource<TaskListSection> 
}

protocol TaskListViewModelType {
    var inputs: TaskListViewModelInputs { get }
    var outputs: TaskListViewModelOutputs { get }
}

class TaskListViewModel: TaskListViewModelType, TaskListViewModelInputs, TaskListViewModelOutputs {
    
    // MARK: - Properties
    var inputs: TaskListViewModelInputs { return self }
    var outputs: TaskListViewModelOutputs { return self }
    
    weak var coordinator: TaskListCoordinator?

    var data: Driver<[Task]> = .just([Task(id: UUID(), name: "Task1", description: "task1 dscr"), Task(id: UUID(), name: "Task2", description: "task2 dscr")])

    // MARK: - Init
    init() {
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Input Handlers
    func viewWillDisappear() {
        coordinator?.viewWillDisappear()
    }
    
    func didTapAddTaskButton() {
        coordinator?.showNewTask()
    }
    
    func didTapDeleteTaskButton(atIndexPath indexPath: IndexPath) {
        print("delete task atIndexPath: \(indexPath)")
    }
    
    func didMovedTask(sourceIndex: IndexPath, destinationIndex: IndexPath) {
        print("moved task from \(sourceIndex) to \(destinationIndex)")
    }
}

// MARK: - RxDataSource
extension TaskListViewModel {
    func dataSource() -> RxTableViewSectionedAnimatedDataSource<TaskListSection> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<TaskListSection> (configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "item: \(item.name)"
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, indexPath in
            return dataSource.sectionModels[indexPath].header
        }
        
        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        
        dataSource.canMoveRowAtIndexPath = { _, _ in
            return true
        }
        
        dataSource.titleForFooterInSection = { _, _ in
            return " "
        }
        
        return dataSource
    }
}
