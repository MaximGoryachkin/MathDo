//
//  FormulaView.swift
//  MathDo
//
//  Created by Максим Горячкин on 19.01.2022.
//

import UIKit

final class FormulaView: UIView {
    
    weak var formulaVC: FormulaViewController!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .link
        return stackView
    }()
    
    private lazy var imageView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    convenience init(viewController: FormulaViewController) {
        self.init()
        formulaVC = viewController
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    private func setupLayout() {
        stackView.addArrangedSubview(imageView)
        addSubview(stackView)
        setStackViewSettings()
        setImageViewSettings()
        print(stackView.frame)
    }
    
    private func setStackViewSettings() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor))
        constraints.append(stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setImageViewSettings() {
        var constraints = [NSLayoutConstraint]()

        constraints.append(imageView.widthAnchor.constraint(equalToConstant: 50))
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 150))

        NSLayoutConstraint.activate(constraints)
    }
    
}
