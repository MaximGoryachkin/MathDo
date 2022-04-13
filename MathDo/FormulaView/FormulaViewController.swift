//
//  FormulaViewController.swift
//  MathDo
//
//  Created by Максим Горячкин on 12.01.2022.
//

import UIKit

protocol FormulaViewProtocol {
    var formula: FormulaModel! {get set}
    func presentSetValueAlert(for: IndexPath)
    func presentErrorAlert(text: String)
    func presentInfo()
}

final class FormulaViewController: UIViewController {
    
    var formula: FormulaModel!
    var inputTextField: UITextField?
//    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    lazy var formulaView = {
        FormulaView(viewController: self, formula: &formula)
    }()
    
    override func loadView() {
        self.view = formulaView
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadFormula()
        setupGUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadFormula()
        formulaView.refreshFormula()
        let editButton = navigationItem.rightBarButtonItems?.last
        editButton?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FormulaReader.shared.removeSteps()
    }
    
    @objc func presentInfo() {
//        showAlert(title: "About formula",
//                  message: "Formula: \(formula.body ?? "")\n Description: \(formula.description)",
//                  style: .alert)
        
        let formulaInfoVC = FormulaInfoViewController(formula: formula)
        if let presentationController = formulaInfoVC.presentationController as? UISheetPresentationController  {
            presentationController.detents = [.medium(), .large()]
        }
        formulaInfoVC.modalPresentationStyle = .custom
        present(formulaInfoVC, animated: true)
        
    
    }
    
    @objc func editTapped(sender: UIButton) {
        sender.isEnabled = false
       
        show(FormulaCreatingViewController(savingType: .editing(formula: formula)), sender: nil)
        
    }
    
    private func setupGUI() {
        navigationItem.title = formula.name
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped(sender:)))
        editItem.isEnabled = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(presentInfo))
        navigationItem.rightBarButtonItems?.append(editItem)
    }
    
    private func loadFormula() {
        let id = formula.objectID.uriRepresentation()
        formula = DatabaseManager.shared.fetchFormula(by: id)
    }
    
    @objc func addMinusInTextField(sender: UIBarButtonItem) {
        guard let inputTextField = inputTextField else { return }
        guard let text = inputTextField.text else { return }
        guard let startIndex = inputTextField.text?.startIndex else { return }
        if sender.title == "minus" {
            inputTextField.text?.insert("-", at: startIndex)
            sender.title = "plus"
        } else {
            inputTextField.text? = text.replacingOccurrences(of: "-", with: "")
            sender.title = "minus"
        }
        
    }
}

extension FormulaViewController: FormulaViewProtocol {
    
    func presentErrorAlert(text: String) {
        showAlert(title: "Error", message: text, style: .alert)
    }
    
    func presentSetValueAlert(for indexPath: IndexPath) {
        
        showAlertWithTextField(title: "Set the value", message: "You should set the value of variable", buttonTitle: "Set", style: .alert, placeholder: "Value", delegate: nil, textFieldText: "") { [weak self] text, button, buttonTapped, textField in
            
            textField.keyboardType = .decimalPad
            textField.delegate = self
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let minus: UIBarButtonItem = UIBarButtonItem(title: "minus", style: .done, target: self, action: #selector(self?.addMinusInTextField))
                    
            let items = [minus, flexSpace]
            toolBar.items = items
            toolBar.barStyle = .default
            textField.inputAccessoryView = toolBar
            
            self?.inputTextField = textField
            if buttonTapped {
                guard let valueString = textField.text else { return }
                          if let value = Double(valueString) {
                              let variables = self?.formula.variables?.array as? [VariableModel]
                              variables?[indexPath.row].variableValue = value
                              self?.formulaView.variableTableView.reloadRows(at: [indexPath], with: .automatic)
                          } else {
                              self?.presentErrorAlert(text: "Enter one dot between numbers, not more!")
                          }
            } else if let variables = self?.formula.variables?.array[indexPath.row] as? VariableModel {
                let variableString = String(variables.variableValue)
                guard variables.variableValue != 0 else { return }
                textField.text = variableString
            }
        }
    }
}

extension FormulaViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
    }
    
}
