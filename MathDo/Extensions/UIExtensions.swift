//
//  UIExtensions.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 29.01.2022.
//

import UIKit


@objc protocol AlertTextFieldDelegate {
    @objc func textDidChange(sender: UITextField)
}

extension UIViewController {
    
    func showAlert(title: String, message: String, buttonTitle: String = "Ok", style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showAlertWithTextField(title: String, message: String, buttonTitle: String, style: UIAlertController.Style, placeholder: String, delegate: AlertTextFieldDelegate? = nil, completion: ((_ text: String, _ button: UIAlertAction, _ buttonTapped: Bool)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        var alertTextField: UITextField!
        alert.addTextField { textField in
            textField.placeholder = placeholder
            alertTextField = textField
            guard let delegate = delegate else { return }
            alertTextField.addTarget(delegate, action: #selector(delegate.textDidChange(sender:)), for: .editingChanged)
        }
        let saveAction = UIAlertAction(title: buttonTitle, style: .default) { saveAction in
            guard let text = alertTextField.text else { return }
            completion?(text, saveAction, true)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        completion?(alertTextField.text ?? "", saveAction, false)
        present(alert, animated: true)
    }
    
    func showActivityIndicator(target: UIViewController, style: UIActivityIndicatorView.Style = .medium, completion: (UIActivityIndicatorView)->()) {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.center = target.view.center
        if let viewController = navigationController {
            viewController.view.addSubview(activityIndicator)
        } else {
            target.view.addSubview(activityIndicator)
        }
        completion(activityIndicator)
    }
    
    
    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIColor {
    var inverted: UIColor {
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: (1 - r), green: (1 - g), blue: (1 - b), alpha: a) // Assuming you want the same alpha value.
    }
}
