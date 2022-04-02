//
//  SyntaxManualViewController.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 01.04.2022.
//

import UIKit
import WebKit

class SyntaxManualViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        view.addSubview(webView)
        setWebView()
        
        let htmlPath = Bundle.main.path(forResource: "FormulaTable", ofType: "html")
        guard let htmlPath = htmlPath else { return }
        let url = URL(fileURLWithPath: htmlPath)
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    private func setWebView() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(webView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(webView.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(webView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10))
        constraints.append(webView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
