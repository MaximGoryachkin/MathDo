//
//  FormulaView.swift
//  MathDo
//
//  Created by Максим Горячкин on 19.01.2022.
//

import UIKit

final class FormulaView: UIView {
    
    var formulaVC: FormulaViewProtocol!
    var formula: Formula!
    var flag = true
    
    private lazy var resultView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var variableTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
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
    
    convenience init(viewController: FormulaViewProtocol, formula: Formula) {
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
    
    public func addVariableValue(_ value: Double ,for indexPath: IndexPath) {
        formula.variables[indexPath.row].value = value
        variableTableView.reloadData()
    }
    
    private func setupLayout() {
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
    
    @objc func resultButtonPressed() {
        flag.toggle()
        resultView.backgroundColor = flag ? .red : .yellow
        print("Result:", FormulaReader.shared.getResult(formula.body, variables: formula.variables))
        
    }
    
    private func setButtonView() {
        resultButtonView.addTarget(self, action: #selector(resultButtonPressed), for: .touchUpInside)
        
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
        let cell = FormulaTableViewCell(style: .default, reuseIdentifier: "variableCell")
        cell.variableLabel.text = String(formula.variables[indexPath.row].character)
        cell.descriptionLabel.text = formula.variables[indexPath.row].description
        if let value = formula.variables[indexPath.row].value {
            cell.valueLabel.text = String(value)
        } else {
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Variables"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        formulaVC.presentSetValueAlert(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
