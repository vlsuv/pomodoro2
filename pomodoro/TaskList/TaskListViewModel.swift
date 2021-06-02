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
import CoreData

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

protocol TaskListViewModelType {
    var inputs: TaskListViewModelInputs { get }
    var outputs: TaskListViewModelOutputs { get }
}

class TaskListViewModel: TaskListViewModelType, TaskListViewModelInputs, TaskListViewModelOutputs {
    
    // MARK: - Properties
    var inputs: TaskListViewModelInputs { return self }
    var outputs: TaskListViewModelOutputs { return self }
    
    weak var coordinator: TaskListCoordinator?
    
    private let coreDataManager: CoreDataManager

    var data: BehaviorRelay<[Task]> = .init(value: [Task]())
    var sections: BehaviorRelay<[TaskListSection]> = .init(value: [TaskListSection]())

    private let disposeBag: DisposeBag
    
    // MARK: - Init
    init() {
        disposeBag = DisposeBag()
        
        coreDataManager = CoreDataManager()
        
        coreDataManager.fetchAllTasks().bind(to: data).disposed(by: disposeBag)
        data.map{ [TaskListSection(header: "", items: $0)] }.bind(to: sections).disposed(by: disposeBag)
        
        bindDataWhenUpdateContext()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    private func bindDataWhenUpdateContext() {
        coreDataManager.observeChangeDataForTasks()
            .bind(to: data)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Input Handlers
    func viewWillDisappear() {
        coordinator?.viewWillDisappear()
    }
    
    func didTapAddTaskButton() {
        coordinator?.showNewTask()
    }
    
    func didTapDeleteTaskButton(atIndexPath indexPath: IndexPath) {
        
        let task = data.value[indexPath.row]
        
        coreDataManager.delete(task: task).subscribe { completable in
            switch completable {
            case .error(let error):
                print("delete error: \(error)")
            case .completed:
                print("task deleted")
            }
        }
        .disposed(by: disposeBag)
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
