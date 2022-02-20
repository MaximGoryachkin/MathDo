//
//  ViewController.swift
//  MathDo
//
//  Created by Максим Горячкин on 06.01.2022.
//

import UIKit

final class StartViewController: UITableViewController {
    
    var formulas = Array<Formula>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonSettings()
        setNavigationBarSettings()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        formulas = DatabaseManager.shared.fetchFormulas()
        tableView.reloadData()
    }
    
    @objc private func routeToFomulaCreatingVC() {
        let formulaCreatingVC = FormulaCreatingViewController()
        show(formulaCreatingVC, sender: nil)
    }
    
    private func setButtonSettings() {
        let addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(routeToFomulaCreatingVC))
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = addItem
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    private func setNavigationBarSettings() {
        navigationItem.title = "MathDo"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formulas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "function")
        content.text = formulas[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formulaVC = FormulaViewController()
        formulaVC.formula = formulas[indexPath.row]
        show(formulaVC, sender: nil)
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        DatabaseManager.shared.delete(formula: formulas[indexPath.row]) {
            formulas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { action, view, _ in
            view.backgroundColor = .green
        }
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
}

