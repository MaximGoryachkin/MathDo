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
    func removeVariable(in cell: VariableCreatingCell)
    func scrollToBottom()
}

 final class FormulaCreatingViewController: UIViewController {

    var formula: Formula?
    var variables: [Variable] = []
    var saveAction: UIAlertAction?
     
     private lazy var formulaCreatingView: FormulaCreatingView = { FormulaCreatingView(viewController: self) }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
    }
     
     override func loadView() {
         view = formulaCreatingView
     }
     
    @objc func doneButtonDidTapped(sender: UIButton) {
        FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "") { success, error in
            if let error = error {
                showError(error)
            } else if success {
                showSaveAlert()
            }
        }
     }
     
     private func saveFormula(name: String) {
         FormulaReader.shared.correctInputExpression(expression: &formulaCreatingView.formulaTextField.text)
         FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "") { success, error in
             print(success)
             formula = Formula(id: 1, name: name, body: formulaCreatingView.formulaTextField.text!, favourite: true, description: "", variables: variables)
             DatabaseManager.shared.save(formula!)
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
         showAlert(title: "Wrong syntax", message: error.localizedDescription, style: .alert)
     }
     
     private func setupGUI() {
         navigationItem.title = "Formula creating"
         let addItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidTapped(sender:)))
         navigationItem.rightBarButtonItem = addItem
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
    
    func removeVariable(in cell: VariableCreatingCell) {
        formulaCreatingView.removeVariableFormTableView(cell: cell)
    }
    
    func scrollToBottom() {
        formulaCreatingView.scrollToBottom()
    }
}

extension FormulaCreatingViewController: VariableCreatingCellDelegate {
    func removeButtonTapped(in cell: VariableCreatingCell) {
        removeVariable(in: cell)
    }
}

extension FormulaCreatingViewController: AlertTextFieldDelegate {
   @objc func textDidChange(sender: UITextField) {
        guard let text = sender.text, text != "" else { saveAction?.isEnabled = false; return }
        saveAction?.isEnabled = true
    }
}

