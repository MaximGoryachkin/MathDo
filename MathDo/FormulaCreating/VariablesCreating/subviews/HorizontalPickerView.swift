//
//  HorizontalPickerView.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 28.01.2022.
//

import UIKit


final class HorizontalPickerView: UIPickerView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        let rotationAngle = -90 * (CGFloat.pi/180)
        transform = CGAffineTransform.init(rotationAngle: rotationAngle)
    }

}
