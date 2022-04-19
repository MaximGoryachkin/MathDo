//
//  FormulaSavingViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 17.04.2022.
//

import UIKit

protocol FormulaSavingDelegate: AnyObject {
    func formulaSavingVCDidClose()
}

final class FormulaSavingViewController: UIViewController {

    public weak var delegate: FormulaSavingDelegate?
    private var savingType: SavingType = .creating
    private weak var formulaCreatingVC: VariableDisplayProtocol!
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .systemRed
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.addTarget(self, action: #selector(buttonDidTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 1
        button.setTitle(savingType == .creating ? "Create" : "Save", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.addTarget(self, action: #selector(buttonDidTap(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var savingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = savingType == .creating ? "Create formula" : "Save formula"
        return label
    }()
    
    private lazy var nameTextField: AttributedTextField = {
        let textField = AttributedTextField(borderStyle: .bottom(borderColor: .black))
        textField.placeholder = "Name"
        textField.backgroundColor = .white
        textField.text = formulaCreatingVC?.formula?.name
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var descriptionTextField: AttributedTextView = {
        let textField = AttributedTextView(borderStyle: .bottom(borderColor: .black))
        textField.placeholderText = "Description (optional)"
        textField.placeholderTextColor = .lightGray
        textField.backgroundColor = .white
        textField.text = formulaCreatingVC.formula?.formulaDescription
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
//    private lazy var saveButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle(savingType == .creating ? "Create" : "Save", for: .normal)
//        button.layer.cornerRadius = 10
//        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
//        button.tintColor = .white
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
//        button.addTarget(self, action: #selector(saveFormula(sender:)), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//    convenience init(formula: FormulaModel? = nil, savingType: SavingType) {
//        self.init()
//        self.savingType = savingType
//        switch savingType {
//        case .creating:
//            print("formula:", formula)
//            self.formulaCreatingVC.formula = formula
//        case .editing(let formula):
//            self.formulaCreatingVC.formula = formula
//        }
//    }
//    
    convenience init(formulaCreatingVC: VariableDisplayProtocol, savingType: SavingType) {
        self.init()
        self.formulaCreatingVC = formulaCreatingVC
        self.savingType = savingType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParameters()
        setConstraints()
    }
    
    
    @objc private func buttonDidTap(sender: UIButton) {
        switch sender.tag {
        case 0:
            dismiss(animated: true)
        case 1:
            sender.isEnabled = false
            saveFormula()
        default:
            break
        }
    }
    
    private func setupParameters() {
        view.backgroundColor = #colorLiteral(red: 0.9245480299, green: 0.9361869693, blue: 0.9359821677, alpha: 1)
        horizontalStackView.addArrangedSubview(cancelButton)
        horizontalStackView.addArrangedSubview(savingLabel)
        horizontalStackView.addArrangedSubview(saveButton)
        view.addSubview(horizontalStackView)
        
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(descriptionTextField)
//        stackView.addArrangedSubview(saveButton)
        view.addSubview(stackView)
    }
    
    private func setConstraints() {
        
        horizontalStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        horizontalStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
//        stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        saveButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2).isActive = true
        stackView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    private func saveFormula() {
        guard let formula = formulaCreatingVC.formula else { return }
        formula.name = nameTextField.text
        formula.formulaDescription = descriptionTextField.text
        print("name:", formula.name)
        DatabaseManager.shared.save(formula)
        print("try to popToRoot")
        dismiss(animated: true) { [weak self] in
            self?.delegate?.formulaSavingVCDidClose()
        }
    }

}
