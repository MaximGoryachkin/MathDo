//
//  VariableCreatingTableViewCell.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 30.01.2022.
//

import UIKit


protocol VariableCreatingCellDelegate: AnyObject {
    func removeButtonTapped(in cell: VariableCreatingCell)
    func editButtonTapped(in cell: VariableCreatingCell)
    func addVariableButtonTapped(from cell: VariableCreatingCell)
}

final class VariableCreatingCell: UITableViewCell {

   weak var delegate: VariableCreatingCellDelegate!
    
    private lazy var variableLabel: UILabel  = {
        let label = UILabel()
        label.textColor = .link
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private lazy var variableDescription: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        let trashImage = UIImage(systemName: "trash")
        button.setBackgroundImage(trashImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus")
        button.setBackgroundImage(plusImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        let trashImage = UIImage(systemName: "pencil")
        button.tag = 1
        button.setBackgroundImage(trashImage, for: .normal)
        button.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setPrimaryParameters()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setPrimaryParameters()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setParameters()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        removeButton.isHidden = !selected
        editButton.isHidden = !selected
        addButton.isHidden = !selected
    }
    
    @objc private func buttonDidTapped(sender: UIButton) {
        switch sender {
        case removeButton:
            delegate?.removeButtonTapped(in: self)
        case editButton:
            delegate?.editButtonTapped(in: self)
        case addButton:
            delegate?.addVariableButtonTapped(from: self)
        default:
            break
        }
    }
    
    public func setVariable(character: Character, description: String?) {
        variableLabel.text = String(character)
        variableDescription.text = description
    }
    
    private func setPrimaryParameters() {
        backgroundColor = .white
        selectionStyle = .none
        addSubview(variableLabel)
        addSubview(variableDescription)
    }
    
    private func setParameters() {
        let variableLabelWidth: CGFloat = 30
        addSubview(removeButton)
        addSubview(editButton)
        addSubview(addButton)
        
        variableLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        variableLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        variableLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        variableLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: variableLabelWidth).isActive = true
        variableDescription.heightAnchor.constraint(equalTo: variableLabel.heightAnchor).isActive = true
       
        variableDescription.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        addButton.heightAnchor.constraint(equalTo:  contentView.heightAnchor,multiplier: 0.7).isActive = true
        addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor, multiplier: 0.7).isActive = true
        addButton.leadingAnchor.constraint(greaterThanOrEqualTo: variableDescription.trailingAnchor, constant: 10).isActive = true
        addButton.centerYAnchor.constraint(equalTo: variableDescription.centerYAnchor).isActive = true
        
        editButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
        editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor, multiplier: 0.7).isActive = true
        editButton.leadingAnchor.constraint(greaterThanOrEqualTo: addButton.trailingAnchor, constant: 10).isActive = true
        
        removeButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
        removeButton.widthAnchor.constraint(equalTo: removeButton.heightAnchor, multiplier: 0.7).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true

        removeButton.leadingAnchor.constraint(greaterThanOrEqualTo: editButton.trailingAnchor, constant: 17).isActive = true
        removeButton.centerYAnchor.constraint(equalTo: editButton.centerYAnchor).isActive = true
        
        variableDescription.leadingAnchor.constraint(greaterThanOrEqualTo: variableLabel.trailingAnchor, constant: 10).isActive = true
        removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let widthConstant = self.bounds.width - variableLabel.bounds.width - removeButton.bounds.width - 40
        variableDescription.widthAnchor.constraint(lessThanOrEqualToConstant: widthConstant).isActive = true
    }
}
