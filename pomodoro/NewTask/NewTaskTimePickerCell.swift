//
//  NewTaskTimePickerCell.swift
//  pomodoro
//
//  Created by vlsuv on 28.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift

class NewTaskTimePickerCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "NewTaskTimePickerCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    var timePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    var disposeBag = DisposeBag()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(titleText: String, timeInterval: [Int], selectedTime: Int) {
        titleLabel.text = titleText
        
        Observable.just(timeInterval)
            .bind(to: timePicker.rx.itemTitles) { _, item in
                return "\(item)"
        }
        .disposed(by: disposeBag)
        
        if let index = timeInterval.firstIndex(of: selectedTime) {
            timePicker.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Handlers
    private func addSubviews() {
        [titleLabel, timePicker].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstaints() {
        titleLabel.anchor(top: contentView.topAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          height: 12)
        
        timePicker.anchor(top: titleLabel.bottomAnchor,
                          left: contentView.leftAnchor,
                          right: contentView.rightAnchor,
                          bottom: contentView.bottomAnchor)
    }
}
