//
//  NewTaskTextFieldCell.swift
//  pomodoro
//
//  Created by vlsuv on 28.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift

class NewTaskTextFieldCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "NewTaskTextFieldCell"
    
    var textField: UITextField = {
        let textField = UITextField()
        return textField
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
    
    func configure(placeholderText: String, text: String) {
        Observable.just(placeholderText)
            .bind(to: textField.rx.text )
            .disposed(by: disposeBag)
        
        Observable.just(text)
            .bind(to: textField.rx.text )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Handlers
    private func addSubviews() {
        [textField].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstaints() {
        textField.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor)
    }
}
