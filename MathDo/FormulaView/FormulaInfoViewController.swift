//
//  FormulaInfoViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 02.04.2022.
//

import UIKit


final class FormulaInfoViewController: UIViewController {
    
    var formula: FormulaModel!
    private var steps = Array<String>()
    private var numbersIsShown = false
    
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
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:)))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var stepsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FormulaTableViewCell.nameOfClass)
        return tableView
    }()
    
    convenience init(formula: FormulaModel) {
        self.init()
        self.formula = formula
        setupPrimarySettings()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        steps = FormulaReader.shared.getSteps()
        stepsTableView.reloadData()
    }
    
    @objc private func labelTapped(sender: UILabel) {
        if numbersIsShown {
            bodyLabel.text = formula.body
            numbersIsShown = false
        } else {
            replaceVariablesWithNumbers()
            numbersIsShown = true
        }
    }
    
    private func setupGUI() {
        view.backgroundColor = .white
        bodyLabel.text = formula.body
    }

    private func setupPrimarySettings() {
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        view.addSubview(stepsTableView)
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 20)
        titleLabel.center.x = view.safeAreaLayoutGuide.layoutFrame.midX
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        bodyLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 20).isActive = true
        
        stepsTableView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor).isActive = true
        stepsTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        stepsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func replaceVariablesWithNumbers() {
        var text = formula.body
        
        guard let variables = formula.variables?.array as? [VariableModel] else { return }
        
        variables.forEach { variable in
            let number =  FormatManager.shared.formatNumber(number: variable.variableValue, style: .none)
            let character = String(variable.character)
            text = text?.replacingOccurrences(of: character, with: number)
        }
        bodyLabel.text = text
    }
}

extension FormulaInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FormulaTableViewCell(style: .default, reuseIdentifier: FormulaTableViewCell.nameOfClass)
        let step = steps[indexPath.row]
        cell.variableLabel.text = String(indexPath.row + 1)
        cell.variableLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell.descriptionLabel.text = step
        cell.valueLabel.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Steps"
    }
    
}
