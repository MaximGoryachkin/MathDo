//
//  FomulaCreatingViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 09.01.2022.
//

import UIKit

@objc protocol FormulaCreatingProtocol {
    @objc func addVariableButtonTapped(sender: UIButton)
}

protocol VariableDisplayProtocol {
    var formula: Formula? { get set }
    var variables: [Variable] { get set }
    func addNewVariable(variable: Variable)
    func addNewVariables(variables: [Variable])
    func removeVariable(in cell: VariableCreatingCell)
    func editVariable(in cell: VariableCreatingCell, newText: String)
    func scrollToBottom()
}

 final class FormulaCreatingViewController: UIViewController {

    var formula: Formula?
    var variables: [Variable] = []
    var saveAction: UIAlertAction?
     
     private lazy var formulaCreatingView: FormulaCreatingView = { FormulaCreatingView(viewController: self) }()
     
    override func viewDidLoad() {
        setupGUI()
    }
     
     override func loadView() {
         view = formulaCreatingView
     }
     
    @objc func doneButtonDidTapped(sender: UIButton) {
        FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "", variables: variables) { success, sender, error  in
            if let error = error {
                guard let variables = sender as? [Variable] else {showError(error); return }
                addNewVariables(variables: variables)
                formulaCreatingView.showWarning(text: "Added variables")
            } else if success {
                showSaveAlert()
            }
        }
     }
     
     private func saveFormula(name: String) {
         FormulaReader.shared.correctInputExpression(expression: &formulaCreatingView.formulaTextField.text, with: variables)
         FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "") { success, sender, error in
             print(success)
              formula = Formula(name: name, body: formulaCreatingView.formulaTextField.text!, favourite: true, description: "", variables: variables)
             guard let formula = formula else { return }
             DatabaseManager.shared.save(formula)
         }
     }
     
     private func showSaveAlert() {
         showAlertWithTextField(title: "Save formula", message: "", buttonTitle: "Save", style: .alert, placeholder: "formula name", delegate: self) { [weak self] text, action, buttonTapped  in
             action.isEnabled = false
             self?.saveAction = action
             if buttonTapped {
             self?.saveFormula(name: text)
             }
         }
     }
     
     private func showError(_ error: Error) {
         switch (error as NSError).code {
         case 8:
             formulaCreatingView.showWarning(text: error.localizedDescription)
         default:
             showAlert(title: "Wrong syntax", message: error.localizedDescription, style: .alert)
         }
     }
     
     private func setupGUI() {
         navigationItem.title = "Formula creating"
         let doneItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidTapped(sender:)))
         let infoItem = UIBarButtonItem(title: "info", style: .plain, target: nil, action: nil)
         infoItem.image = UIImage(systemName: "info.circle")
         navigationItem.rightBarButtonItem = doneItem
         navigationItem.rightBarButtonItems?.append(infoItem)
     }
}

extension FormulaCreatingViewController: FormulaCreatingProtocol {
   @objc func addVariableButtonTapped(sender: UIButton) {
       let variablesCreatingVC = VariableCreatingViewController(variableDisplay: self)
       present(variablesCreatingVC, animated: true)
       
    }   
}

extension FormulaCreatingViewController: VariableDisplayProtocol {
    
  
    func addNewVariable(variable: Variable) {
        formulaCreatingView.addNewVariable(variable: variable)
    }
    
    func addNewVariables(variables: [Variable]) {
        variables.forEach { [weak self] variable in
            self?.formulaCreatingView.addNewVariable(variable: variable)
        }
    }
    
    func editVariable(in cell: VariableCreatingCell, newText: String) {
        formulaCreatingView.editVariableFromTableView(cell: cell, newText: newText)
    }
    
    func removeVariable(in cell: VariableCreatingCell) {
        formulaCreatingView.removeVariableFromTableView(cell: cell)
    }
    
    func scrollToBottom() {
        formulaCreatingView.scrollToBottom()
    }
}

extension FormulaCreatingViewController: VariableCreatingCellDelegate {
    
    func removeButtonTapped(in cell: VariableCreatingCell) {
        removeVariable(in: cell)
    }
    
    func editButtonTapped(in cell: VariableCreatingCell) {
        guard let indexPath = formulaCreatingView.getIndexPath(of: cell) else { return }
        let title = "Edit"
        let message = "Editing description of variable \(variables[indexPath.row].character)"
        let oldDescription = variables[indexPath.row].description ?? ""
        showAlertWithTextField(title: title, message: message, buttonTitle: "Save", style: .alert, placeholder: "Variable description", delegate: nil, textFieldText: oldDescription) { [weak self] text, button, buttonTapped in
            if buttonTapped {
                self?.editVariable(in: cell, newText: text)
            }
        }
        
    }
}

extension FormulaCreatingViewController: AlertTextFieldDelegate {
   @objc func textDidChange(sender: UITextField) {
        guard let text = sender.text, text != "" else { saveAction?.isEnabled = false; return }
        saveAction?.isEnabled = true
    }
}

