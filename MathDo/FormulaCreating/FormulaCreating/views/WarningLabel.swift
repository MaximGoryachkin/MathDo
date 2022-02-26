//
//  WarningLabel.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 20.02.2022.
//

import UIKit

final class WarningLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init() {
        self.init()
        text = ""
    }
    
    
    public func highlightWarning(text: String) {
        self.text = text
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear) { [weak self] in
            self?.textColor = .red
            self?.alpha = 1.0
            self?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { [weak self] finished in
            self?.fadeOut()
        }
    }
    
    private func fadeOut(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 0.0
        } completion: { [weak self] isFinished in
            if isFinished { 
                self?.text = ""
            }
        }

    }

}
