//
//  FormulaViewController.swift
//  MathDo
//
//  Created by Максим Горячкин on 12.01.2022.
//

import UIKit

protocol FormulaViewProtocol {
    func presentSetValueAlert(for: IndexPath)
    func presentErrorAlert(text: String)
}

final class FormulaViewController: UIViewController {
    
    var formula: Formula!
    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    lazy var formulaView = {
        FormulaView(viewController: self, formula: formula)
    }()
    
    override func loadView() {
        self.view = formulaView
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = formula.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(presentInfo))
    }
    
    @objc func presentInfo() {
        showAlert(title: "About formula",
                  message: "Formula: \(formula.body)\n Description: \(formula.description ?? "Is empty")",
                  style: .alert)
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
                self?.formulaView.formula.variables[indexPath.row].value = value
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
