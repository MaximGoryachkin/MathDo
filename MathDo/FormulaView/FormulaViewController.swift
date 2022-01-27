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
    
    lazy var formulaView: FormulaView = { FormulaView(viewController: self) }()
    
    override func loadView() {
        view = formulaView
    }

}
