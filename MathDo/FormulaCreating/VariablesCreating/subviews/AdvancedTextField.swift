//
//  AdvancedTextField.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 29.01.2022.
//

import UIKit


final class AdvancedTextField: UITextField {

        var textPadding = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
    
    private func setParameters() {
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.black.cgColor
    }
}
