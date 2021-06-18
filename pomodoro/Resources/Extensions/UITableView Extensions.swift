//
//  UITableView Extensions.swift
//  pomodoro
//
//  Created by vlsuv on 15.06.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxRealm

extension UITableView {
  func applyChangeset(_ changes: RealmChangeset) {
    beginUpdates()
    deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
    insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
    reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
    endUpdates()
  }
}
