//
//  FormulaCreatingView.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 09.01.2022.
//

import UIKit


final class FormulaCreatingView: UIView {

  
    lazy var formulaTextField: AttributedTextField  = {
//        let formulaTextField = UITextField(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        let formulaTextField = AttributedTextField(borderStyle: .bottom(borderColor: .lightGray))
        formulaTextField.translatesAutoresizingMaskIntoConstraints = false
        formulaTextField.layer.masksToBounds = true
        formulaTextField.borderStyle = .none
        formulaTextField.layer.cornerRadius = 5
        formulaTextField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        formulaTextField.placeholder = "Write your formula"
        formulaTextField.backgroundColor = .white
        formulaTextField.autocorrectionType = .no
        formulaTextField.autocapitalizationType = .none
        return formulaTextField
    }()
    
    private weak var formulaCreatingVC: (FormulaCreatingProtocol & VariableDisplayProtocol & VariableCreatingCellDelegate)!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var variablesTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0
                                                 ), style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VariableCreatingCell.self, forCellReuseIdentifier: VariableCreatingCell.nameOfClass)
        tableView.contentInset.top -= 30
        tableView.rowHeight = 50
        tableView.separatorInset = .zero
        tableView.separatorColor = .lightGray
        return tableView
    }()
    
    private lazy var addVariableButton: UIButton = {
        let addVariableButton = UIButton(type: .system)
        addVariableButton.translatesAutoresizingMaskIntoConstraints = false
        addVariableButton.setTitle("New variable", for: .normal)
        addVariableButton.layer.cornerRadius = 10
        addVariableButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        addVariableButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addVariableButton.tintColor = .white
        addVariableButton.addTarget(formulaCreatingVC, action: #selector(formulaCreatingVC?.addVariableButtonTapped(sender:)), for: .touchUpInside)
        return addVariableButton
    }()
    
    private lazy var warningLabel: WarningLabel = {
        let warningLabel = WarningLabel(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        warningLabel.textColor = .black
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.textAlignment = .center
        return warningLabel
    }()
    
    private var layoutFinished = false
    
    convenience init(viewController: FormulaCreatingProtocol & VariableDisplayProtocol & VariableCreatingCellDelegate) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        formulaCreatingVC = viewController
        setPrimarySettings()
//        addSubview(UITextField())
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.layoutSubviews()
        if !layoutFinished  {
        setSecondarySettings()
        }
    }
    
    public func loadExistedFormula(_ formula: FormulaModel) {
        formulaTextField.text = formula.body
    }
    
    public func addNewVariable(variable: VariableModel) {
        variablesTableView.performBatchUpdates {
            guard let lastIndex = formulaCreatingVC.variables?.array.endIndex else { return }
//            formulaCreatingVC.variables?.insert(variable, at: lastIndex)
            let mutableVariables = formulaCreatingVC.variables?.mutableCopy() as! NSMutableOrderedSet
            mutableVariables.add(variable)
            formulaCreatingVC.variables = mutableVariables.copy() as? NSOrderedSet
            let indexPath = IndexPath.init(row: lastIndex, section: .zero)
            variablesTableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    public func addNewVariable(temporaryVariable: VariableTemporaryModel) {
        let context = DatabaseManager.shared.getContext()
        let variableModel = VariableModel(context: context)
        variableModel.character = String(temporaryVariable.character)
        addNewVariable(variable: variableModel)
    }
    
    public func removeVariableFromTableView(cell: VariableCreatingCell) {
        guard let indexPath = variablesTableView.indexPath(for: cell) else { return }
        variablesTableView.performBatchUpdates {
            guard let variable = formulaCreatingVC.variables?[indexPath.row] as? VariableModel else { return }
            let mutableVariables = formulaCreatingVC.variables?.mutableCopy() as! NSMutableOrderedSet
            mutableVariables.removeObject(at: indexPath.row)
            formulaCreatingVC.variables = mutableVariables.copy() as? NSOrderedSet
            variablesTableView.deleteRows(at: [indexPath], with: .automatic)
            DatabaseManager.shared.delete(variable: variable)
        }
    }
    
    public func editVariableFromTableView(cell: VariableCreatingCell, newText: String) {
        guard let indexPath = variablesTableView.indexPath(for: cell) else { return }
        variablesTableView.performBatchUpdates {
           guard let variable = formulaCreatingVC.variables?.array[indexPath.row] as? VariableModel else { return }
            variable.variableDescription = newText
            variablesTableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    public func getIndexPath(of cell: VariableCreatingCell) -> IndexPath? {
        variablesTableView.indexPath(for: cell)
    }
    public func scrollToBottom() {
        guard let variablesCount = formulaCreatingVC.variables?.array.count else { return }
        guard variablesCount > 0 else { return }
        guard let lastIndexOfVariables = formulaCreatingVC.variables?.array.indices.last else { return }
            DispatchQueue.main.async { [weak self] in
                let indexPath = IndexPath(row: lastIndexOfVariables, section: .zero)
                self?.variablesTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
    }
    
    public func showWarning(text: String) {
        warningLabel.highlightWarning(text: text)
    }
    
    private func setPrimarySettings() {
        backgroundColor = #colorLiteral(red: 0.9245480299, green: 0.9361869693, blue: 0.9359821677, alpha: 1)
        stackView.addArrangedSubview(formulaTextField)
        stackView.addArrangedSubview(warningLabel)
        stackView.addArrangedSubview(variablesTableView)
        stackView.addArrangedSubview(addVariableButton)
        addSubview(stackView)
        setupLayout()
        layoutSubviews()
    }
    
    
   private func setSecondarySettings() { // settings that depend on layout
//       formulaTextField.addInfoButton()
       let topMargin = warningLabel.frame.height + stackView.spacing
       stackView.layoutMargins = .init(top: topMargin, left: 0.0, bottom: 0.0, right: 0.0)
       layoutFinished = true
    }
    
    private func setupLayout() {
        setStackViewSettings()
        setFormulaTextFieldSettings()
        setWarningLabelSettings()
        setVariablesTableViewSettings()
        setAddVariableButtonSettings()
    }
    
    private func setStackViewSettings() {
        let padding = 10.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, constant: -padding).isActive = true
    }
    
    private func setFormulaTextFieldSettings() {
        formulaTextField.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / 7).isActive = true
        formulaTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor ).isActive = true
//        formulaTextField.addBottomBorder()
    }
    
    private func setWarningLabelSettings() {
        warningLabel.heightAnchor.constraint(equalTo: formulaTextField.heightAnchor, multiplier: 0.3).isActive = true
        warningLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
    }
    
    private func setVariablesTableViewSettings() {
        variablesTableView.separatorInset = .zero
        variablesTableView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    private func setAddVariableButtonSettings() {
//        addVariableButton.addTarget(formulaCreatingVC, action: #selector(formulaCreatingVC?.addVariableButtonTapped(sender:)), for: .touchUpInside)
        addVariableButton.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / 7 ).isActive = true
        addVariableButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        addVariableButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension FormulaCreatingView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        formulaCreatingVC.variables?.array.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VariableCreatingCell.nameOfClass, for: indexPath) as? VariableCreatingCell else { return UITableViewCell() }
        
        guard let variable = formulaCreatingVC.variables?.array[indexPath.row] as? VariableModel else { return UITableViewCell()}
        let variableCharacter = variable.character
        let variableDescription = variable.variableDescription
        cell.setVariable(character: Character(variableCharacter), description: variableDescription)
        cell.delegate = formulaCreatingVC
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Variables"
    }
    
}
