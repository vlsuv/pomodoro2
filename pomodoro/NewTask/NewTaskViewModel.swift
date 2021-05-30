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
    var sections: [NewTaskSectionModel] { get set }
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
    
    private let disposeBag = DisposeBag()
    
    var sections: [NewTaskSectionModel] = [NewTaskSectionModel]()
    
    var taskName: BehaviorSubject<String> = .init(value: "")
    var taskDescription: BehaviorSubject<String> = .init(value: "")
    var workInterval: BehaviorSubject<Int> = .init(value: 25)
    
    // MARK: - Init
    init() {
        setupSections()
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
    
    // MARK: - Input Handlers
    func viewDidDisappear() {
        coordinator?.viewDidDisappear()
    }
    
    func didTapDoneButton() {
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
