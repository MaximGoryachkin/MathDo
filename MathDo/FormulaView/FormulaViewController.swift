//
//  FormulaViewController.swift
//  MathDo
//
//  Created by Максим Горячкин on 12.01.2022.
//

import UIKit

protocol FormulaViewProtocol {
    func presentAllert()
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
    func presentAllert() {
        let alert = UIAlertController(title: "Set the value", message: "You shuold set the value of variable", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addTextField { _ in
            //значение переменной в модели
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
