//
//  NewTaskController.swift
//  pomodoro
//
//  Created by vlsuv on 28.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NewTaskController: UIViewController {
    
    // MARK: - Properties
    var viewModel: NewTaskViewModelType!
    
    private var tableView: UITableView = UITableView()
    
    private var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
        return button
    }()
    
    private var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<NewTaskSectionModel>!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        
        dataSource = viewModel.outputs.dataSource()
        
        configureNavigationController()
        configureTableView()
        setupBindings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.inputs.viewDidDisappear()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    // MARK: - Handlers
    private func configureNavigationController() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.register(NewTaskTextFieldCell.self, forCellReuseIdentifier: NewTaskTextFieldCell.identifier)
        tableView.register(NewTaskTimePickerCell.self, forCellReuseIdentifier: NewTaskTimePickerCell.identifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        
        tableView.isScrollEnabled = false
    }
    
    private func setupBindings() {
        Observable.just(viewModel.outputs.sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.isValid
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .asObservable()
            .subscribe { [weak self] in
                self?.viewModel?.inputs.didTapDoneButton()
        }
        .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel?.inputs.didTapCancelButton()
        }
        .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .asObservable()
            .subscribe { [weak self] _ in
                self?.viewModel.inputs.didTapDoneButton()
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension NewTaskController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
