//
//  DataService.swift
//  pomodoro
//
//  Created by vlsuv on 31.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

enum CoreDataServiceError: Error {
    case failedToFetchData
    case failedToSaveContext
    case otherError
}

class CoreDataService {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func fetchData<T>(request: NSFetchRequest<NSFetchRequestResult>) -> Observable<T> {
        return Single<T>.create { [weak self] single -> Disposable in
            do {
                let data = try self?.context?.fetch(request) as! T
                single(.success(data))
            } catch {
                single(.failure(CoreDataServiceError.failedToFetchData))
            }
            return Disposables.create()
        }
        .asObservable()
    }
    
    func observeChangeDataInContext<T>(request: NSFetchRequest<NSFetchRequestResult>) -> Observable<T> {
        let notification = Notification.Name.NSManagedObjectContextObjectsDidChange
        
        return NotificationCenter.default.rx.notification(notification).flatMap { [weak self] notification -> Observable<T> in
            guard let self = self else { return .error(CoreDataServiceError.otherError)}
            
            return self.fetchData(request: request).asObservable()
        }
    }
    
    func delete<T: NSManagedObject>(_ entity: T) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            self?.context?.delete(entity)
            
            do {
                try self?.context?.save()
                completable(.completed)
            } catch {
                completable(.error(CoreDataServiceError.failedToSaveContext))
            }
            
            return Disposables.create()
        }
    }
}
