//
//  FormatManager.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 05.04.2022.
//

import Foundation


final class FormatManager {
    public static let shared = FormatManager()
    
    public func formatNumber(number: Double, style: NumberFormatter.Style) -> String {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = style
            let number = NSNumber(value: number)
            return numberFormatter.string(from: number) ?? ""
        }
    
    
    
}
