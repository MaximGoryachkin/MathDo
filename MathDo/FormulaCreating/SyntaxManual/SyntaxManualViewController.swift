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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColorSet")
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
        constraints.append(webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
        constraints.append(webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constraints.append(webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(webView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
