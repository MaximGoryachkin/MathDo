//
//  Models.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 25.01.2022.
//

import Foundation

enum OperationType: Character, CaseIterable {
    case exponentiation = "^"
    case multiplication = "*"
    case division = "/"
    case addition = "+"
    case subtraction = "-"

static func getOperationSymbols() -> [Character] {
            var operationsCharacters = Array<Character>()
            allCases.forEach { operation in
                operationsCharacters.append(operation.rawValue)
            }
            return operationsCharacters
        }
}

struct AllowedSymbols {
    var allowedSymbols = "+-*/^1234567890()"
    var digits = "0123456789"
    var operations = OperationType.getOperationSymbols()
    var brackets = "()"
    var possibleVariables: [Character] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var listOfCharacters = Array<Character>()
        alphabet.forEach { char in
            listOfCharacters.append(char)
        }
        return listOfCharacters
    }
    lazy var possibleVariablesStrings: [String] = {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var listOfCharacters = Array<String>()
        alphabet.forEach { char in
            listOfCharacters.append(String(char))
        }
        return listOfCharacters
    }()
    
   mutating func addAllowedSymbol(character: Character) {
        allowedSymbols.append(character)
    }
    
    func getPossibleVariables(without variables: [Variable]) -> [Character] {
        var variableCharacters = Set<Character>()
        variables.forEach { variable in
            variableCharacters.insert(variable.character)
        }
        let filtredVariableCharacters: [Character] = possibleVariables.filter { !variableCharacters.contains($0) }
        return filtredVariableCharacters
    }
}
