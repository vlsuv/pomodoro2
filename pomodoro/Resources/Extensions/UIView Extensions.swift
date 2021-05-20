//
//  UIView Extensions.swift
//  pomodoro
//
//  Created by vlsuv on 20.05.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, topPadding: CGFloat? = 0, leftPadding: CGFloat? = 0, rightPadding: CGFloat? = 0, bottomPadding: CGFloat? = 0, height: CGFloat? = nil, width: CGFloat? = nil, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            if let topPadding = topPadding {
                self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
            }
        }
        
        if let bottom = bottom {
            if let bottomPadding = bottomPadding {
                self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
            }
        }
        
        if let left = left {
            if let leftPadding = leftPadding {
                self.leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
            }
        }
        
        if let right = right {
            if let rightPadding = rightPadding {
                self.rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
            }
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
