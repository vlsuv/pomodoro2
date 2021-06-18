//
//  TaskListViewModel.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RealmSwift
import RxRealm
import RxRealmDataSources


protocol TaskListViewModelInputs {
    func viewWillDisappear()
    func didTapAddTaskButton()
    func didTapDeleteTaskButton(atIndexPath indexPath: IndexPath)
    func didMovedTask(sourceIndex: IndexPath, destinationIndex: IndexPath)
    func didEditTask(atIndexPath indexPath: IndexPath)
    func didSelectTask(atIndexPath indexPath: IndexPath)
}

protocol TaskListViewModelOutputs {
    var tasks: Observable<(AnyRealmCollection<Results<Task>.ElementType>, RealmChangeset?)> { get }
}

protocol TaskListViewModelType: class {
    var inputs: TaskListViewModelInputs { get }
    var outputs: TaskListViewModelOutputs { get }
}

class TaskListViewModel: TaskListViewModelType, TaskListViewModelInputs, TaskListViewModelOutputs {
    // MARK: - Properties
    var inputs: TaskListViewModelInputs { return self }
    var outputs: TaskListViewModelOutputs { return self }
    
    weak var coordinator: TaskListCoordinator?
    
    private var taskManager: TaskDataManagerType {
        return TaskDataManager.shared
    }
    
    var tasks: Observable<(AnyRealmCollection<Results<Task>.ElementType>, RealmChangeset?)> {
        return TaskDataManager.shared.changeSetTasks()
    }
    
    private let disposeBag: DisposeBag
    
    // MARK: - Init
    init() {
        disposeBag = DisposeBag()
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
        taskManager.deleteTask(atIndex: indexPath.row).subscribe { completable in
            switch completable {
            case .error(let error):
                print(error)
            case .completed:
                print("Task deleted")
            }
        }
        .disposed(by: disposeBag)
    }
    
    func didMovedTask(sourceIndex: IndexPath, destinationIndex: IndexPath) {
        taskManager.movedTask(sourceIndex: sourceIndex.row, destinationIndex: destinationIndex.row).subscribe { completable in
            switch completable {
            case .error(let error):
                print(error)
            case .completed:
                print("Task moved")
            }
        }
        .disposed(by: disposeBag)
    }
    
    func didEditTask(atIndexPath indexPath: IndexPath) {
        let task = taskManager.getTask(atIndex: indexPath.row)
        coordinator?.showEditTask(task)
    }
    
    func didSelectTask(atIndexPath indexPath: IndexPath) {
        let task = taskManager.getTask(atIndex: indexPath.row)
        NotificationCenter.default.post(name: .DidSelectTask, object: task)
    }
}
