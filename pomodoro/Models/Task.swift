//
//  Task.swift
//  pomodoro
//
//  Created by vlsuv on 14.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Task: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var taskDescription: String?
    @objc dynamic var workInterval: Int = 0
    @objc dynamic var order: Int = 0
    
    convenience init(id: String = UUID().uuidString, name: String, description: String? = nil, workInterval: Int, order: Int) {
        self.init()
        self.id = id
        self.name = name
        self.taskDescription = description
        self.workInterval = workInterval
        self.order = order
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Task {
    func workIntervalSec() -> Double {
        return Double(self.workInterval * 60)
    }
}

extension Task: IdentifiableType {
    public typealias Identity = String
    
    public var identity: Identity { return id }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
