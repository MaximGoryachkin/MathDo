//
//  FormulaView.swift
//  MathDo
//
//  Created by Максим Горячкин on 19.01.2022.
//

import UIKit

final class FormulaView: UIView {
    
    weak var formulaVC: FormulaViewController!
    var formula: Formula!
    
    private lazy var resultView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var variableTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "variableCell")
        return view
    }()
    
    private lazy var resultButtonView: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.tintColor = .white
        view.setTitle("Get Result", for: .normal)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(viewController: FormulaViewController, formula: Formula) {
        self.init()
        formulaVC = viewController
        self.formula = formula
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
        print(frame)
        print(safeAreaLayoutGuide.layoutFrame)
    }
    
    func setupLayout() {
        addSubview(resultView)
        addSubview(variableTableView)
        addSubview(resultButtonView)
        setResultView()
        setVariableTableView()
        setButtonView()
    }
    
    private func setResultView() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(resultView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(resultView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor))
        constraints.append(resultView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor))
        constraints.append(resultView.heightAnchor.constraint(equalToConstant: safeAreaLayoutGuide.layoutFrame.height / 4))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setVariableTableView() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(variableTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(variableTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor))
        constraints.append(variableTableView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 10))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setButtonView() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(resultButtonView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(resultButtonView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10))
        constraints.append(resultButtonView.topAnchor.constraint(equalTo: variableTableView.bottomAnchor, constant: 10))
        constraints.append(resultButtonView.heightAnchor.constraint(equalToConstant: safeAreaLayoutGuide.layoutFrame.height / 10))
        constraints.append(resultButtonView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension FormulaView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formula.variables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "variableCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = formula.variables[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Variables"
    }
    
}
