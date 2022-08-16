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
        view.backgroundColor = UIColor(named: "BackgroundColorSet")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formulas = DatabaseManager.shared.fetchFormulas()
        setLeftBarButton()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formulas.count > 0 ? formulas.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = !formulas.isEmpty ? UIImage(systemName: "function") : nil
        content.text = !formulas.isEmpty ? formulas[indexPath.row].name : "No have formulas"
        content.secondaryText = !formulas.isEmpty ? formulas[indexPath.row].formulaDescription : ""
        cell.isUserInteractionEnabled = !formulas.isEmpty
        cell.contentConfiguration = content
        cell.accessoryType = !formulas.isEmpty ? .disclosureIndicator : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formulaVC = FormulaViewController()
        formulaVC.formula = formulas[indexPath.row]
        show(formulaVC, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard formulas.count > 0 else { return }
        DatabaseManager.shared.delete(formula: formulas[indexPath.row]) {
            tableView.performBatchUpdates {
                formulas.remove(at: indexPath.row)
                if formulas.isEmpty {
                    tableView.reloadData()
                } else {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            if formulas.isEmpty {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard formulas.count > 0 else { return nil }
        let favorite = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, _ in
            view.backgroundColor = .gray
            guard let formula = self?.formulas[indexPath.row] else { return }
            self?.show(FormulaCreatingViewController(savingType: .editing(formula: formula)), sender: nil)
        }
        //        favorite.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        favorite.backgroundColor = UIColor(named: "GreenColorSet")
        favorite.title = "Edit"
        return UISwipeActionsConfiguration(actions: [favorite])
    }
    
    @objc private func routeToFomulaCreatingVC() {
        let formulaCreatingVC = FormulaCreatingViewController()
        show(formulaCreatingVC, sender: nil)
    }
    
    private func setButtonSettings() {
        let addItem = UIBarButtonItem(title: "Add",
                                      style: .plain,
                                      target: self,
                                      action: #selector(routeToFomulaCreatingVC))
        let backBarButtton = UIBarButtonItem(title: "",
                                             style: .plain,
                                             target: nil,
                                             action: nil)
        
        navigationItem.rightBarButtonItem = addItem
        navigationItem.backBarButtonItem = backBarButtton
    }
    
    private func setNavigationBarSettings() {
        navigationItem.title = "MathDo"
    }
    
    private func setLeftBarButton() {
        if !formulas.isEmpty {
            navigationItem.leftBarButtonItem = editButtonItem()
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    private func editButtonItem() -> UIBarButtonItem {
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .plain,
                                         target: self,
                                         action: #selector(editButtonAction(sender:)))
        return editButton
    }
    
    @objc func editButtonAction(sender: UIBarButtonItem) {
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

