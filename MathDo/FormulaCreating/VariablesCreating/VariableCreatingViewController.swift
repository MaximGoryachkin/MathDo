//
//  VariablesCreatingViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 27.01.2022.
//

import UIKit


@objc protocol VariableCreatingCancelProtocol {
    @objc func cancelButtonTapped(sender: UIButton)
}

protocol VariableCreatingProtocol {
    var variable: VariableModel? {get set}
    var variableDisplay: VariableDisplayProtocol! { get set }
    func addVariable(variable: VariableModel)
}

final class VariableCreatingViewController: UIViewController {
    
    var variable: VariableModel?
    
    var variableDisplay: VariableDisplayProtocol!
    
    private lazy var variablesCreatingView: VariablesCreatingView = {
        VariablesCreatingView(variableCreatingVC: self)
    }()
    
    convenience init(variableDisplay: VariableDisplayProtocol) {
        self.init()
        self.variableDisplay = variableDisplay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTouch()
    }
    
    override func loadView() {
        view = variablesCreatingView
    }
}

extension VariableCreatingViewController: VariableCreatingCancelProtocol {
    func cancelButtonTapped(sender: UIButton) {
        dismiss(animated: true)
    }
}

extension VariableCreatingViewController: VariableCreatingProtocol {
    func addVariable(variable: VariableModel) {
        dismiss(animated: true) { [weak self] in
            self?.variableDisplay.addNewVariable(variable: variable)
            self?.variableDisplay.scrollToBottom()
        }
    }
}
