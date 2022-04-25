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
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formulas = DatabaseManager.shared.fetchFormulas()
        tableView.reloadData()
        setLeftBarButton()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formulas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "function")
        content.text = formulas[indexPath.row].name
        content.secondaryText = formulas[indexPath.row].formulaDescription
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
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
            if formulas.isEmpty {
                navigationItem.leftBarButtonItem = nil
                navigationItem.rightBarButtonItem?.isEnabled.toggle()
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
    
    private func setNavigationItems() {
        let addItem = UIBarButtonItem(title: "Add",
                                      style: .plain,
                                      target: self,
                                      action: #selector(routeToFomulaCreatingVC))
        let backItem = UIBarButtonItem(title: "",
                                             style: .plain,
                                             target: nil,
                                             action: nil)
        
        navigationItem.title = "MathDo"
        navigationItem.rightBarButtonItem = addItem
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setLeftBarButton() {
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .plain,
                                         target: self,
                                         action: #selector(editButtonAction(sender:)))
        if !formulas.isEmpty {
            navigationItem.leftBarButtonItem = editButton
        }
    }
    
    @objc private func routeToFomulaCreatingVC() {
        let formulaCreatingVC = FormulaCreatingViewController()
        self.navigationController?.isEditing = false
        show(formulaCreatingVC, sender: nil)
    }
    
    @objc private func editButtonAction(sender: UIBarButtonItem) {
        var isEditing = self.tableView.isEditing
        if isEditing {
            isEditing.toggle()
            sender.title = "Edit"
            sender.style = UIBarButtonItem.Style.plain
            self.navigationItem.rightBarButtonItem?.isEnabled.toggle()
            self.navigationController?.setEditing(isEditing, animated: true)
        } else {
            isEditing.toggle()
            sender.title = "Done"
            sender.style = UIBarButtonItem.Style.done
            self.navigationItem.rightBarButtonItem?.isEnabled.toggle()
            self.navigationController?.setEditing(isEditing, animated: true)
        }
    }
}

