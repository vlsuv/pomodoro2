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
import RxRealm
import RealmSwift


protocol TaskListViewModelInputs {
    func viewWillDisappear()
    func didTapAddTaskButton()
    func didTapDeleteTaskButton(atIndexPath indexPath: IndexPath)
    func didMovedTask(sourceIndex: IndexPath, destinationIndex: IndexPath)
}

protocol TaskListViewModelOutputs {
    var sections: BehaviorRelay<[TaskListSection]> { get }
    func dataSource() -> RxTableViewSectionedAnimatedDataSource<TaskListSection> 
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

    private let disposeBag: DisposeBag
    
    var sections: BehaviorRelay<[TaskListSection]> = .init(value: [TaskListSection]())
    
    // MARK: - Init
    init() {
        disposeBag = DisposeBag()
        
        taskManager.fetchObserveTasks().map { [TaskListSection(header: "", items: $0)] }.bind(to: sections).disposed(by: disposeBag)
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
}

// MARK: - RxDataSource
extension TaskListViewModel {
    func dataSource() -> RxTableViewSectionedAnimatedDataSource<TaskListSection> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<TaskListSection> (configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.name
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
