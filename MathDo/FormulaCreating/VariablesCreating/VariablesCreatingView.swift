//
//  VariablesCreatingView.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 27.01.2022.
//

import UIKit

final class VariablesCreatingView: UIView {
    
    private weak var variableCreatingVC: (VariableCreatingCancelProtocol & VariableCreatingProtocol)!
    
    private var variablesCharacters: [Character]!
    
    private lazy var pickerView: HorizontalPickerView = {
        let pickerView = HorizontalPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Create variable"
        label.textColor = UIColor(named: "BackgroundColorSet")
        label.backgroundColor = UIColor(named: "GreenColorSet")
        return label
    }()
    
    private lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Choose character of variable"
        return label
    }()
    
    private lazy var variableDescriptionTextField: UITextField  = {
        let advancedTextField = AdvancedTextField()
        advancedTextField.translatesAutoresizingMaskIntoConstraints = false
        advancedTextField.placeholder = "Write name of variable"
        advancedTextField.delegate = self
        return advancedTextField
    }()
    
    
    private lazy var variableCreatingButton: UIButton = {
        let variableCreatingButton = UIButton(type: .system)
        variableCreatingButton.translatesAutoresizingMaskIntoConstraints = false
        variableCreatingButton.setTitle("Done", for: .normal)
        variableCreatingButton.layer.cornerRadius = 10
        variableCreatingButton.backgroundColor = UIColor(named: "GreenColorSet")
        variableCreatingButton.tintColor = UIColor(named: "BackgroundColorSet")
        variableCreatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        variableCreatingButton.addTarget(self, action: #selector(createVariableButtonTapped(sender:)), for: .touchUpInside)
        return variableCreatingButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        cancelButton.tintColor = .white
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        cancelButton.addTarget(variableCreatingVC, action: #selector(variableCreatingVC.cancelButtonTapped(sender:)), for: .touchUpInside)
        return cancelButton
    }()
    
    convenience init(variableCreatingVC: (VariableCreatingCancelProtocol) & VariableCreatingProtocol) {
        self.init()
        self.variableCreatingVC = variableCreatingVC
        setPrimarySettings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    @objc private func createVariableButtonTapped(sender: UIButton) {
        guard pickerView.numberOfRows(inComponent: 0) != .zero else { return }
        let row = pickerView.selectedRow(inComponent: 0)
        let variableCharacter = variablesCharacters[row]
        let variableDescription = variableDescriptionTextField.text
        let context = DatabaseManager.shared.getContext()
        let variable = VariableModel(context: context)
        variable.character = String(variableCharacter)
        variable.variableDescription = variableDescription
//        let variable = VariableModel(character: variableCharacter, description: variableDescription, value: nil)
        variableCreatingVC.addVariable(variable: variable)
    }
    
    private func setPrimarySettings() {
        guard let usedVariables = variableCreatingVC.variableDisplay.variables else { return }
        variablesCharacters = FormulaReader.shared.allowedSymbols.getPossibleVariables(without: usedVariables)
        
        backgroundColor = UIColor(named: "BackgroundColorSet")
        addSubview(pickerView)
        addSubview(titleLabel)
        stackView.addArrangedSubview(characterLabel)
        stackView.addArrangedSubview(variableDescriptionTextField)
        stackView.addArrangedSubview(variableCreatingButton)
        stackView.addArrangedSubview(cancelButton)
        addSubview(stackView)
    }
    
    private func setupLayout() {
        
        setCharactertLabelSettings()
        setPickerViewSettings()
        setDescriptionLabelSettings()
        setVariableDescriptionTextFieldSettings()
        setVariableCreatingButtonSettings()
        setCancelButtonSettings()
        setStackViewSettings()
    }
    
    private func setStackViewSettings() {
        let padding = 10.0
        let paddingDependsPickerView = pickerView.frame.height + 30
        stackView.setCustomSpacing(40, after: variableDescriptionTextField)
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        stackView.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: -paddingDependsPickerView).isActive = true
    }
    
    private func setCharactertLabelSettings() {
        titleLabel.frame = CGRect(x: 0, y: 0, width: safeAreaLayoutGuide.layoutFrame.width, height: 20)
        titleLabel.center.x = safeAreaLayoutGuide.layoutFrame.midX
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func setDescriptionLabelSettings() {
        characterLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor ).isActive = true
        characterLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setPickerViewSettings() {
        let paddingDependsCharactertLabel = titleLabel.frame.maxY + 10
        pickerView.frame = CGRect(x: 0, y: paddingDependsCharactertLabel, width: stackView.frame.width, height: 100)
        pickerView.center.x = safeAreaLayoutGuide.layoutFrame.midX
    }
    
    private func setVariableDescriptionTextFieldSettings() {
        variableDescriptionTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        variableDescriptionTextField.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.25).isActive = true
    }
    
    private func setVariableCreatingButtonSettings() {
        variableCreatingButton.heightAnchor.constraint(equalTo: variableDescriptionTextField.heightAnchor).isActive = true
        variableCreatingButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
    }
    
    private func setCancelButtonSettings() {
        cancelButton.heightAnchor.constraint(equalTo: variableCreatingButton.heightAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: variableCreatingButton.widthAnchor).isActive = true
    }
}

extension VariablesCreatingView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        variablesCharacters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = VariableView()
        view.setCharacter(variablesCharacters[row])
        view.transform = CGAffineTransform(rotationAngle: 90 * (CGFloat.pi/180))
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedView = pickerView.view(forRow: row, forComponent: component) as? VariableView
        guard let color = UIColor(named: "PickerViewColorSet") else { return }
        selectedView?.setColor(color)
    }
    
}

extension VariablesCreatingView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        variableDescriptionTextField.resignFirstResponder()
        return true
    }
}
