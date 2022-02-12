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
     
     private lazy var formulaCreatingView: FormulaCreatingView = { FormulaCreatingView(viewController: self) }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
    }
     
     override func loadView() {
         view = formulaCreatingView
     }
     
    @objc func doneButtonDidTapped(sender: UIButton) {
        FormulaReader.shared.correctInputExpression(expression: &formulaCreatingView.formulaTextField.text)
        FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "") { success, error in
        }
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

