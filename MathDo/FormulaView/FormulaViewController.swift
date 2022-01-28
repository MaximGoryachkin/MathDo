//
//  FormulaViewController.swift
//  MathDo
//
//  Created by Максим Горячкин on 12.01.2022.
//

import UIKit

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
    }

}
