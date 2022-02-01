//
//  VariableView.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 29.01.2022.
//

import UIKit

final class VariableView: UIView {

    private lazy var label: UILabel = {
        UILabel()
    }()
    
    private lazy var textLayer: CATextLayer = {
        CATextLayer()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCharacter(_ char: Character) {
        label.text = String(char)
    }
    
    public func setColor(_ color: UIColor) {
        let color = color.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3) {
            self.label.layer.backgroundColor = color.withAlphaComponent(1).cgColor
            self.label.textColor = color.inverted.withAlphaComponent(1)
            self.label.layer.borderColor = color.inverted.withAlphaComponent(1).cgColor
            self.label.layer.borderWidth = 3
        }
    }
    
  
    private func setParameters() {
        let size = 80
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        label.layer.borderWidth = 1.5
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        addSubview(label)
    }

}
