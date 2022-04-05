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
    var formula: FormulaModel? { get set }
    var variables: NSOrderedSet? { get set }
    func addNewVariable(variable: VariableModel)
    func addNewVariables(variables: [VariableTemporaryModel])
    func removeVariable(in cell: VariableCreatingCell)
    func editVariable(in cell: VariableCreatingCell, newText: String)
    func scrollToBottom()
}

final class FormulaCreatingViewController: UIViewController {
    
    var formula: FormulaModel?
    var variables: NSOrderedSet? = NSOrderedSet()
    var saveAction: UIAlertAction?
    private var savingType = SavingType.creating
    
    private lazy var formulaCreatingView: FormulaCreatingView = { FormulaCreatingView(viewController: self) }()
    
    convenience init(savingType: SavingType) {
        self.init()
        self.savingType = savingType
        switch savingType {
        case .creating:
            break
        case .editing(let formula):
            self.formula = formula
        }
    }
    
    override func viewDidLoad() {
        setupGUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DatabaseManager.shared.cancelAllChanges()
    }
    
    override func loadView() {
        view = formulaCreatingView
    }
     
    @objc func doneButtonDidTapped(sender: UIButton) {
        print("tip")
        guard let variablesArray = variables?.array as? [VariableModel] else { return }
        print("top")
        FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "", variables: variablesArray) { success, sender, error  in
            if let error = error {
                guard let variables = sender as? [VariableTemporaryModel] else {showError(error); return }
                addNewVariables(variables: variables)
                formulaCreatingView.showWarning(text: "Added variables")
            } else if success {
                showSaveAlert()
            }
        }
     }
    
    @objc func cancelButtonDidTapped() {
        showAlert(title: "Are you sure?", message: "Do you want cancel editing?", buttonTitle: "Yes", secondButtonTitle: "No", style: .actionSheet) { [weak self] action in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func infoButtonDidTapped() {
        let syntaxManualVC = SyntaxManualViewController()
        if let presentationController = syntaxManualVC.presentationController as? UISheetPresentationController  {
            presentationController.detents = [.medium()]
        }
        syntaxManualVC.modalPresentationStyle = .custom
        present(syntaxManualVC, animated: true)
        
    }
    
    private func loadFormula(formula: FormulaModel) {
        guard let variables = formula.variables else { return }
        self.variables = variables
        formulaCreatingView.loadExistedFormula(formula)
        navigationItem.title = formula.name
    }
     
    private func saveFormula(name: String) {
        FormulaReader.shared.correctInputExpression(expression: &formulaCreatingView.formulaTextField.text, with: variables)
        FormulaReader.shared.verifyFormulaSyntax(expression: formulaCreatingView.formulaTextField.text ?? "") { success, sender, error in
            print(success)
            
            switch savingType {
            case .creating:
                formula = FormulaModel(context: DatabaseManager.shared.getContext()
                )
                formula?.name = name
                formula?.body = formulaCreatingView.formulaTextField.text!
                formula?.favourite = false
                formula?.id = formula?.objectID.uriRepresentation()
                formula?.formulaDescription = ""
                formula?.variables = variables
                
                guard let formula = formula else { return }
                DatabaseManager.shared.save(formula)
                
            case .editing(let formula):
                formula.name = name
                formula.body = formulaCreatingView.formulaTextField.text!
                formula.variables = variables
                
                DatabaseManager.shared.save(formula)
            }
        }
    }
    
     
    private func showSaveAlert() {
        showAlertWithTextField(title: "Save formula", message: "", buttonTitle: "Save", style: .alert, placeholder: "formula name", delegate: self) { [weak self] text, action, buttonTapped, textField   in
            action.isEnabled = false
            self?.saveAction = action
            textField.text = self?.formula?.name
            if buttonTapped {
                self?.saveFormula(name: text)
                self?.navigationController?.popViewController(animated: true)
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
         var doneButtonTitle: String
         switch savingType {
         case .creating:
             doneButtonTitle = "Done"
         case .editing(let formula):
             doneButtonTitle = "Save"
             navigationItem.hidesBackButton = true
             let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonDidTapped))
             navigationItem.leftBarButtonItem = cancelItem
             loadFormula(formula: formula)
         }
         
         
         let doneItem = UIBarButtonItem(title: doneButtonTitle, style: .done, target: self, action: #selector(doneButtonDidTapped(sender:)))
         let infoItem = UIBarButtonItem(title: "info", style: .plain, target: self, action: #selector(infoButtonDidTapped))
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
  
    func addNewVariable(variable: VariableModel) {
        formulaCreatingView.addNewVariable(variable: variable)
    }
    
    func addNewVariables(variables: [VariableTemporaryModel]) {
        variables.forEach { [weak self] variable in
            self?.formulaCreatingView.addNewVariable(temporaryVariable: variable)
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
        guard let variable = variables?.array[indexPath.row] as? VariableModel else { return }
        let message = "Editing description of variable \(variable.character)"
        let oldDescription = variable.variableDescription ?? ""
        showAlertWithTextField(title: title, message: message, buttonTitle: "Save", style: .alert, placeholder: "Variable description", delegate: nil, textFieldText: oldDescription) { [weak self] text, button, buttonTapped, textField in
//            textField.text = self?.formula?.name
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

