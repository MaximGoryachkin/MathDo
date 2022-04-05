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
    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
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
}

extension FormulaViewController: FormulaViewProtocol {
    func presentErrorAlert(text: String) {
        showAlert(title: "Error", message: text, style: .alert)
    }
    
    func presentSetValueAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Set the value", message: "You shuold set the value of variable", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "Enter", style: .default) { [weak self] _ in
            guard let valueString = alert.textFields?.first?.text else { return }
            if let value = Double(valueString) {
                let variables = self?.formula.variables?.array as? [VariableModel]
                variables?[indexPath.row].variableValue = value
                self?.formulaView.variableTableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self?.presentErrorAlert(text: "Enter one dot between numbers, not more!")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(enterAction)
        alert.addAction(cancelAction)
        alert.actions.first?.isEnabled = false
        
        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                   object: textField,
                                                   queue: OperationQueue.main, using: {_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                enterAction.isEnabled = textIsNotEmpty
            })
        }
        
        
        present(alert, animated: true)
    }
}
