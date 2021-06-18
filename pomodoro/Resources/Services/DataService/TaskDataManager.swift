//
//  FetcherDataService.swift
//  pomodoro
//
//  Created by vlsuv on 31.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

protocol TaskDataManagerType {
    func changeSetTasks() -> Observable<(AnyRealmCollection<Results<Task>.ElementType>, RealmChangeset?)>
    
    func addTask(name: String, description: String?, workInterval: Int) -> Completable
    func deleteTask(atIndex index: Int) -> Completable
    func movedTask(sourceIndex: Int, destinationIndex: Int) -> Completable
    func getTask(atIndex index: Int) -> Task
    func changeExistTask(handler: @escaping () -> ()) -> Completable
}

class TaskDataManager: TaskDataManagerType {
    
    // MARK: - Properties
    static let shared: TaskDataManagerType = TaskDataManager()
    
    private let realmService: RealmServiceProtocol
    
    private let disposeBag: DisposeBag
    
    private let tasks: Results<Task>
    
    // MARK: - Init
    private init() {
        self.disposeBag = DisposeBag()
        
        self.realmService = RealmService()
        
        tasks = realmService.fetchData(Task.self).sorted(byKeyPath: "order", ascending: true)
    }
}

// MARK: - Task Observables
extension TaskDataManager {
    func changeSetTasks() -> Observable<(AnyRealmCollection<Results<Task>.ElementType>, RealmChangeset?)> {
        return Observable.changeset(from: tasks).share()
    }
}

// Task Manage
extension TaskDataManager {
    func addTask(name: String, description: String?, workInterval: Int) -> Completable {
        let order = (tasks.last?.order ?? 0) + 1
        let task = Task(name: name, description: description, workInterval: workInterval, order: order)
        return realmService.add(task)
    }
    
    func deleteTask(atIndex index: Int) -> Completable {
        let task = tasks[index]
        return realmService.delete(task)
    }
    
    func movedTask(sourceIndex: Int, destinationIndex: Int) -> Completable {
        let movedHandler = { [weak self] in
            guard let self = self else { return }
            
            swap(&self.tasks[sourceIndex].order, &self.tasks[destinationIndex].order)
        }
        return realmService.writeChange(handler: movedHandler)
    }
    
    func getTask(atIndex index: Int) -> Task {
        return tasks[index]
    }
    
    func changeExistTask(handler: @escaping () -> ()) -> Completable {
        return realmService.writeChange(handler: handler)
    }
}
