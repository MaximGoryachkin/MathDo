//
//  VariablesCreatingViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 27.01.2022.
//

import UIKit


final class VariablesCreatingViewController: UIViewController {
    
    
    private lazy var variablesCreatingView: VariablesCreatingView = {
        VariablesCreatingView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = variablesCreatingView
    }
    
    
}
