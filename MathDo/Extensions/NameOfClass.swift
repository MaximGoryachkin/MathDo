//
//  NameOfClass.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 30.01.2022.
//
import Foundation




extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
