//
//  FormulaTableViewCell.swift
//  MathDo
//
//  Created by Максим Горячкин on 02.02.2022.
//

import UIKit

final class FormulaTableViewCell: UITableViewCell {
    
    var variableLabel: UILabel = {
        let label = UILabel()
        label.textColor = .link
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        selectionStyle = .default
        addSubview(variableLabel)
        addSubview(descriptionLabel)
        addSubview(valueLabel)
        setVariableLabelConstarints()
        setDescriptionLabelConstraints()
        setValueLabelConstraints()
    }
    
    private func setVariableLabelConstarints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(variableLabel.widthAnchor.constraint(equalToConstant: contentView.frame.height))
        constraints.append(variableLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setDescriptionLabelConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(descriptionLabel.leadingAnchor.constraint(equalTo: variableLabel.trailingAnchor, constant: 5))
        constraints.append(descriptionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.width / 3))
        constraints.append(descriptionLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setValueLabelConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15))
        constraints.append(valueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: contentView.frame.height))
        constraints.append(valueLabel.heightAnchor.constraint(equalToConstant: contentView.frame.height))
        
        NSLayoutConstraint.activate(constraints)
    }
}
