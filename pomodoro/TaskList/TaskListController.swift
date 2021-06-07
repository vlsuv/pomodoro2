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
import RxDataSources

class TaskListController: UIViewController {
    
    // MARK: - Properties
    var viewModel: TaskListViewModelType!
    
    private var tableView: UITableView = UITableView()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<TaskListSection>!
    
    var addTaskButton: UIBarButtonItem = {
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
        
        dataSource = viewModel.outputs.dataSource()
        
        configureNavigationController()
        configureTableView()
        setupBindings()
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
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .asObservable()
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.inputs.didTapDeleteTaskButton(atIndexPath: indexPath)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(Task.self)
            .subscribe { model in
                
        }.disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .asObservable()
            .subscribe(onNext: { [weak self] sourceIndex, destinationIndex in
                self?.viewModel?.inputs.didMovedTask(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
    }
    
    private func setupBindings() {
        viewModel?.outputs.sections
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
            
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
