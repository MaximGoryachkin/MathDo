//
//  FormulaView.swift
//  MathDo
//
//  Created by Максим Горячкин on 19.01.2022.
//

import UIKit

final class FormulaView: UIView {
    
    var formulaVC: FormulaViewProtocol!
    var formula: FormulaModel!
    var flag = true
    
    lazy var variableTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "variableCell")
        return view
    }()
    
    private lazy var resultView: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textAlignment = .center
        view.font = UIFont(name: "Avenir", size: 100)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.1
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resultLabelTapped(sender:)))
        view.addGestureRecognizer(guestureRecognizer)
        return view
    }()
    
    private lazy var resultButtonView: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        view.tintColor = .white
        view.setTitle("Get Result", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        view.layer.cornerRadius = 10
        view.addTarget(self, action: #selector(resultButtonPressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(viewController: FormulaViewProtocol, formula: inout FormulaModel) {
        self.init()
        formulaVC = viewController
//        self.formula = formula
        setPrimarySetting()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    public func refreshFormula(){
        variableTableView.reloadData()
    }
    
    
    
    private func addVariableValue(_ value: Double ,for indexPath: IndexPath) {
        guard let variables = formula.variables?.array as? [VariableModel] else { return }
        variables[indexPath.row].variableValue = value
    }
    
    private func setPrimarySetting() {
        addSubview(resultView)
        addSubview(variableTableView)
        addSubview(resultButtonView)
        setResultView()
        setVariableTableView()
//        setButtonView()
    }
    
    private func setupLayout() {
//        setResultView()
//        setVariableTableView()
        setButtonView()
    }
    
    private func setResultView() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(resultView.leadingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(resultView.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor))
        constraints.append(resultView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor))
        constraints.append(resultView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append(resultView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.25))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setVariableTableView() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(variableTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
        constraints.append(variableTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor))
        constraints.append(variableTableView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 10))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func resultButtonPressed() {
        do {
            guard let variables = formulaVC.formula.variables?.array as? [VariableModel] else { return }
            guard let body = formulaVC.formula.body else { return }
            let result = try FormulaReader.shared.getResult(body, variables: variables)
            resultView.text = result
        } catch(let error) {
            formulaVC.presentErrorAlert(text: error.localizedDescription)
        }
    }
    
    @objc private func resultLabelTapped(sender: UIGestureRecognizer) {
        formulaVC.presentInfo()
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
        formulaVC.formula.variables?.array.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FormulaTableViewCell(style: .default, reuseIdentifier: "variableCell")
        guard let variable = formulaVC.formula.variables?.array[indexPath.row] as? VariableModel else { return UITableViewCell()}
        cell.variableLabel.text = variable.character
        cell.descriptionLabel.text = variable.variableDescription
        cell.valueLabel.text = String(variable.variableValue )
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
