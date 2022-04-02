//
//  FormulaInfoViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 02.04.2022.
//

import UIKit

class FormulaInfoViewController: UIViewController {
    
    var formula: FormulaModel!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.textAlignment = .center
        label.text = "Formula body"
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.font = UIFont(name: "Avenir", size: 50)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
    }
    
    convenience init(formula: FormulaModel) {
        self.init()
        self.formula = formula
        setupPrimarySettings()
    }
    
    private func setupGUI() {
        view.backgroundColor = .white
        bodyLabel.text = formula.body
    }

    private func setupPrimarySettings() {
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 20)
        titleLabel.center.x = view.safeAreaLayoutGuide.layoutFrame.midX
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        bodyLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20).isActive = true
        
        
    }

}
