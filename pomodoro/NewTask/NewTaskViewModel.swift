//
//  NewTaskViewModel.swift
//  pomodoro
//
//  Created by vlsuv on 28.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

protocol NewTaskViewModelInputs {
    func viewDidDisappear()
    func didTapDoneButton()
    func didTapCancelButton()
}

protocol NewTaskViewModelOutputs {
    func dataSource() -> RxTableViewSectionedReloadDataSource<NewTaskSectionModel>
    var sections: [NewTaskSectionModel]! { get set }
    var isValid: BehaviorSubject<Bool> { get set }
}

protocol NewTaskViewModelType {
    var inputs: NewTaskViewModelInputs { get }
    var outputs: NewTaskViewModelOutputs { get }
}

class NewTaskViewModel: NewTaskViewModelType, NewTaskViewModelInputs, NewTaskViewModelOutputs {
    
    // MARK: - Properties
    var inputs: NewTaskViewModelInputs { return self }
    var outputs: NewTaskViewModelOutputs { return self }
    
    weak var coordinator: NewTaskCoordinator?
    
    private let coreDataManager: CoreDataManager
    
    private let disposeBag = DisposeBag()
    
    var sections: [NewTaskSectionModel]!
    
    private let taskName: BehaviorSubject<String>
    private let taskDescription: BehaviorSubject<String>
    private let workInterval: BehaviorSubject<Int>
    
    var isValid: BehaviorSubject<Bool>
    
    // MARK: - Init
    init() {
        coreDataManager = CoreDataManager()
        
        taskName = .init(value: "")
        taskDescription = .init(value: "")
        workInterval = .init(value: 25)
        
        isValid = .init(value: false)
        
        setupSections()
        setupBindings()
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    private func setupSections() {
        sections = [
            .descriptionSection(items: [
                .textFieldSectionItem(placeholderText: "Name", bind: taskName),
                .textFieldSectionItem(placeholderText: "Description", bind: taskDescription)
            ]),
            .timeSection(items: [
                .pickerSectionItem(titleText: "Work Interval", timeInterval: Array(10...50), bind: workInterval)
            ])
        ]
    }
    
    private func setupBindings() {
        taskName.map { text -> Bool in
            return !text.isEmpty
        }
        .bind(to: isValid)
        .disposed(by: disposeBag)
    }
    
    // MARK: - Input Handlers
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    func didTapDoneButton() {
        guard let name = try? taskName.value(), let description = try? taskDescription.value(), let workInterval = try? workInterval.value() else { return }
        
        coreDataManager.addNewTask(name: name, description: description, workInterval: workInterval)
            .subscribe { [weak self] completable in
                switch completable {
                case .error(let error):
                    print("add task error: \(error)")
                case .completed:
                    self?.coordinator?.didFinishCreatingTask()
                }
        }
        .disposed(by: disposeBag)
    }
    
    func didTapCancelButton() {
        coordinator?.didFinishCreatingTask()
    }
}

// MARK: - RxDataSource
extension NewTaskViewModel {
    func dataSource() -> RxTableViewSectionedReloadDataSource<NewTaskSectionModel> {
           return RxTableViewSectionedReloadDataSource<NewTaskSectionModel>  (configureCell: { dataSource, tableView, indexPath, item in
               switch dataSource[indexPath] {
               case .textFieldSectionItem(placeholderText: let placeholder, bind: let bind):
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskTextFieldCell.identifier, for: indexPath) as? NewTaskTextFieldCell else { return UITableViewCell() }
                   
                   if let text = try? bind.value() {
                       cell.configure(placeholderText: placeholder, text: text)
                   }
                   
                   cell.textField.rx.text.changed.subscribe(onNext: { text in
                       guard let text = text else { return }
                       bind.onNext(text)
                   })
                       .disposed(by: cell.disposeBag)
                   
                   return cell
               case .pickerSectionItem(titleText: let titleText, timeInterval: let timeInderval, bind: let bind):
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskTimePickerCell.identifier, for: indexPath) as? NewTaskTimePickerCell else { return UITableViewCell() }
                   
                   if let selectedTime = try? bind.value() {
                       cell.configure(titleText: titleText, timeInterval: timeInderval, selectedTime: selectedTime)
                   }
                   
                   cell.timePicker.rx.modelSelected(Int.self)
                       .subscribe(onNext: { models in
                           guard let model = models.first else { return }
                           
                           bind.onNext(model)
                       })
                       .disposed(by: cell.disposeBag)
                   
                   return cell
               }
           }, titleForFooterInSection: { _, _ in
               return " "
           })
       }
}
