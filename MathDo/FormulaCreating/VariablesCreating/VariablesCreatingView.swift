//
//  VariablesCreatingView.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 27.01.2022.
//

import UIKit

final class VariablesCreatingView: UIView {
    
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
        label.text = "Variable creating"
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return label
    }()
    
    private lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Choose character of variable"
        return label
    }()
    
    private lazy var variableDescriptionTextField: UITextField  = {
        let formulaTextField = AdvancedTextField()
        formulaTextField.translatesAutoresizingMaskIntoConstraints = false
//        formulaTextField.borderStyle = .line
        formulaTextField.placeholder = "Write name of variable"
        return formulaTextField
    }()
    
    
    private lazy var variableCreatingButton: UIButton = {
        let variableCreatingButton = UIButton()
        variableCreatingButton.translatesAutoresizingMaskIntoConstraints = false
        variableCreatingButton.setTitle("Create variable", for: .normal)
        variableCreatingButton.layer.cornerRadius = 10
        variableCreatingButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        variableCreatingButton.tintColor = .white
        return variableCreatingButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 10
        cancelButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        cancelButton.tintColor = .white
        return cancelButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPrimarySettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    
    private func setPrimarySettings() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        addSubview(pickerView)
        addSubview(titleLabel)
        stackView.addArrangedSubview(characterLabel)
        stackView.addArrangedSubview(variableDescriptionTextField)
        stackView.addArrangedSubview(variableCreatingButton)
        stackView.addArrangedSubview(cancelButton)
        addSubview(stackView)
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
//        pickerView.subviews.first?.subviews.last?.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).withAlphaComponent(0.25)
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
        FormulaReader.shared.allowedSymbols.possibleVariablesStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        FormulaReader.shared.allowedSymbols.possibleVariablesStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        80
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = VariableView()
        view.setText(FormulaReader.shared.allowedSymbols.possibleVariablesStrings[row])
        view.transform = CGAffineTransform(rotationAngle: 90 * (CGFloat.pi/180))
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedView = pickerView.view(forRow: row, forComponent: component) as? VariableView
        let color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        selectedView?.setColor(color)
    }
    
}
