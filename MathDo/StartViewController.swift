//
//  ViewController.swift
//  MathDo
//
//  Created by Максим Горячкин on 06.01.2022.
//

import UIKit

final class StartViewController: UITableViewController {
    
    var formulas = Array<FormulaModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonSettings()
        setNavigationBarSettings()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formulas = DatabaseManager.shared.fetchFormulas()
        tableView.reloadData()
        if !formulas.isEmpty {
            navigationItem.leftBarButtonItem = editButtonItem
        } else {
            navigationItem.leftBarButtonItem = nil
        }
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
        if editingStyle == .delete {
            
            DatabaseManager.shared.delete(formula: formulas[indexPath.row]) {
                formulas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if formulas.isEmpty {
                    navigationItem.leftBarButtonItem = nil
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, _ in
            view.backgroundColor = .gray
            guard let formula = self?.formulas[indexPath.row] else { return }
            self?.show(FormulaCreatingViewController(savingType: .editing(formula: formula)), sender: nil)
        }
        favorite.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        favorite.title = "Edit"
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    @objc private func routeToFomulaCreatingVC() {
        let formulaCreatingVC = FormulaCreatingViewController()
        show(formulaCreatingVC, sender: nil)
    }
    
    private func setButtonSettings() {
        let addItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(routeToFomulaCreatingVC))
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = addItem
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    private func setNavigationBarSettings() {
        navigationItem.title = "MathDo"
    }
    
}

