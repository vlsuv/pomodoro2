//
//  Task+CoreDataProperties.swift
//  pomodoro
//
//  Created by vlsuv on 31.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//
//

import Foundation
import CoreData
import RxDataSources

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    static var request: NSFetchRequest<Task> {
        let entityName = String(describing: Task.self)
        let request = NSFetchRequest<Task>(entityName: entityName)
        return request
    }

    @NSManaged public var taskDescription: String?
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var workInterval: Int16

}

extension Task: IdentifiableType {
    public typealias Identity = UUID
    
    public var identity: Identity { return id }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
