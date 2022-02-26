//
//  AttributedTextField.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 23.02.2022.
//

import UIKit

enum CustomBorderStyle {
    case bottom(borderColor: UIColor)
    case top(borderColor: UIColor)
    case none
}

final class AttributedTextField: UITextField {
    
    public var bottomLine =  CALayer()
    
    private var rect = CGRect()
    private var customBorderStyle: CustomBorderStyle = .none
    
    private var textPadding = UIEdgeInsets(
         top: 10,
         left: 15,
         bottom: 10,
         right: 15
     )
    
    convenience init(borderStyle: CustomBorderStyle) {
        self.init()
        customBorderStyle = borderStyle
        switch customBorderStyle {
        case .bottom(let borderColor):
            rect = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
            addBottomBorder(frame: rect)
            bottomLine.backgroundColor = borderColor.cgColor
        case .top(borderColor: let borderColor):
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
            addBottomBorder(frame: rect)
            bottomLine.backgroundColor = borderColor.cgColor
        case .none:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch customBorderStyle {
        case .bottom(_):
            bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        case .top(_):
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
        case .none:
            break
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    private func addBottomBorder(frame: CGRect) {
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.red.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
