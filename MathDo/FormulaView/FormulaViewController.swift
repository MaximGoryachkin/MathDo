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
    }
}

extension FormulaViewController: FormulaViewProtocol {
    func presentErrorAlert(text: String) {
        showAlert(title: "Error", message: text, style: .alert)
    }
    
    func presentSetValueAlert(for indexPath: IndexPath) {
        let alert = UIAlertController(title: "Set the value", message: "You shuold set the value of variable", preferredStyle: .alert)
        alert.addTextField()
        let action = UIAlertAction(title: "Enter", style: .cancel) { [weak self] _ in
            guard let valueString = alert.textFields?.first?.text else { return }
            let value = Double(valueString) ?? 0.0
            self?.formulaView.addVariableValue(value ,for: indexPath)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
