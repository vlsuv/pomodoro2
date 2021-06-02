//
//  FetcherDataService.swift
//  pomodoro
//
//  Created by vlsuv on 31.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RxSwift

class CoreDataManager {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    private let dataService = CoreDataService()
    
    func fetchAllTasks() -> Observable<[Task]> {
        return dataService.fetchData(request: Task.fetchRequest())
    }
    
    func observeChangeDataForTasks() -> Observable<[Task]> {
        return dataService.observeChangeDataInContext(request: Task.fetchRequest())
    }
    
    func addNewTask(name: String, description: String, workInterval: Int) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            guard let self = self, let context = self.context else {
                completable(.error(CoreDataServiceError.otherError))
                return Disposables.create()
            }
            
            let item = Task(context: context)
            item.id = UUID()
            item.name = name
            item.discription = description
            item.workInterval = Int16(workInterval)
            
            do {
                try context.save()
                completable(.completed)
            } catch {
                completable(.error(CoreDataServiceError.failedToSaveContext))
            }
            
            return Disposables.create()
        }
    }
    
    func delete(task: Task) -> Completable {
        return dataService.delete(task)
    }
}
