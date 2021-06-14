//
//  RealmService.swift
//  pomodoro
//
//  Created by vlsuv on 14.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

enum RealmServiceError: Error {
    case failedToSaveRealm
    case failedToFetchData
}

protocol RealmServiceProtocol {
    func fetchData<T: Object>(_ object: T.Type) -> Results<T>
    func add<T: Object>(_ object: T) -> Completable
    func delete<T: Object>(_ object: T) -> Completable
    func writeChange(handler: @escaping () -> ()) -> Completable
}

class RealmService: RealmServiceProtocol {
    private let localRealm = try! Realm()
    
    func fetchData<T: Object>(_ object: T.Type) -> Results<T> {
        return localRealm.objects(object)
    }
    
    func add<T: Object>(_ object: T) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            do {
                try self?.localRealm.write {
                    self?.localRealm.add(object)
                }
                completable(.completed)
            } catch {
                completable(.error(RealmServiceError.failedToSaveRealm))
            }
            
            return Disposables.create()
        }
    }
    
    func delete<T: Object>(_ object: T) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            do {
                try self?.localRealm.write {
                    self?.localRealm.delete(object)
                }
                completable(.completed)
            } catch {
                completable(.error(RealmServiceError.failedToSaveRealm))
            }
            
            return Disposables.create()
        }
    }
    
    func writeChange(handler: @escaping () -> ()) -> Completable {
        return Completable.create { [weak self] completable -> Disposable in
            do {
                try self?.localRealm.write {
                    handler()
                }
                completable(.completed)
            } catch {
                completable(.error(RealmServiceError.failedToSaveRealm))
            }
            
            return Disposables.create()
        }
    }
}
