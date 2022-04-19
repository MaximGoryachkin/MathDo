//
//  AttributedTextView.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 17.04.2022.
//

import UIKit


final class AttributedTextView: UITextView, UITextViewDelegate {
    
    override var font: UIFont? {
           didSet {
               if let fnt = self.font {
                   textLayer.fontSize = fnt.pointSize
               } else {
                   textLayer.fontSize = 12.0
               }
           }
       }
    public var bottomLine =  CALayer()
    public var placeholderText: String = "" {
        didSet {
            textLayer.string = placeholderText
            setNeedsLayout()
        }
    }
    public var placeholderTextColor: UIColor = .lightGray {
            didSet {
                textLayer.foregroundColor = placeholderTextColor.cgColor
                setNeedsLayout()
            }
        }
    
    private let textLayer = CATextLayer()
    private var rect = CGRect()
    private var customBorderStyle: CustomBorderStyle = .none
    
    private var textPadding = UIEdgeInsets(
         top: 10,
         left: 15,
         bottom: 10,
         right: 15
     )
    
    convenience init(borderStyle: CustomBorderStyle) {
        self.init()
        customBorderStyle = borderStyle
        switch customBorderStyle {
        case .bottom(let borderColor):
            rect = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
            addBottomBorder(frame: rect)
            bottomLine.backgroundColor = borderColor.cgColor
        case .top(borderColor: let borderColor):
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
            addBottomBorder(frame: rect)
            bottomLine.backgroundColor = borderColor.cgColor
        case .none:
            break
        }
        setPlaceholderSettings()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch customBorderStyle {
        case .bottom(_):
            bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        case .top(_):
            rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
        case .none:
            break
        }
        
        textLayer.frame = bounds.insetBy(
                    dx: textContainerInset.left + textContainer.lineFragmentPadding + 10,
                    dy: textContainerInset.top
                )
    }
    
    func textViewDidChange(_ textView: UITextView) {
          // show / hide the textLayer
          textLayer.opacity = textView.text.isEmpty ? 1.0 : 0.0
      }

    
    private func setPlaceholderSettings() {
        // textLayer properties
               textLayer.contentsScale = UIScreen.main.scale
               textLayer.alignmentMode = .left
               textLayer.isWrapped = true
               textLayer.foregroundColor = placeholderTextColor.cgColor

               if let fnt = self.font {
                   textLayer.fontSize = fnt.pointSize
               } else {
                   textLayer.fontSize = 17
               }

               // insert the textLayer
               layer.insertSublayer(textLayer, at: 0)

               // set delegate to self
               delegate = self
    }
    
    private func addBottomBorder(frame: CGRect) {
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.red.cgColor
        layer.addSublayer(bottomLine)
    }
}
