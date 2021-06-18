//
//  TaskListController.swift
//  pomodoro
//
//  Created by vlsuv on 25.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxRealmDataSources
import RxRealm

class TaskListController: UIViewController {
    // MARK: - Properties
    var viewModel: TaskListViewModelType!
    
    private var tableView: UITableView = UITableView()
    
    private var dataSource: RxTableViewRealmDataSource<Task>!
    
    private var addTaskButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        configureNavigationController()
        configureTableView()
        setupTableViewControlEvents()
        setupButtonControlEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.inputs.viewWillDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationItem.rightBarButtonItems = [editButton, addTaskButton]
    }
}

// MARK: TableViewConfiguration
extension TaskListController {
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        dataSource = RxTableViewRealmDataSource(cellIdentifier: "cell", cellType: UITableViewCell.self) { cell, ip, task in
            cell.textLabel?.text = task.name
        }
        
        viewModel.outputs.tasks
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        tableView.tableFooterView = UITableView()
    }
    
    private func setupTableViewControlEvents() {
        tableView.rx.itemDeleted
            .asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.inputs.didTapDeleteTaskButton(atIndexPath: indexPath)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .asObservable()
            .subscribe(onNext: { [weak self] sourceIndex, destinationIndex in
                self?.viewModel?.inputs.didMovedTask(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asObservable()
            .subscribe (onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                
                self?.viewModel.inputs.didSelectTask(atIndexPath: indexPath)
            }).disposed(by: disposeBag)
    }
    
    private func setupButtonControlEvents() {
        editButton.rx.tap
            .asObservable().subscribe(onNext: { [weak self] in
                self?.tableView.isEditing.toggle()
            })
            .disposed(by: disposeBag)
        
        addTaskButton.rx.tap
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel?.inputs.didTapAddTaskButton()
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension TaskListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, view, succes in
            self?.viewModel.inputs.didEditTask(atIndexPath: indexPath)
            succes(true)
        }
        editAction.backgroundColor = UIColor.gray
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
