//
//  Models.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 25.01.2022.
//

import Foundation

enum OperationType: Character, CaseIterable {
    case division = "/"
    case exponentiation = "^"
    case multiplication = "*"
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
//    let alphabet = "abcdefghijklmnopqrstuvwxyzαβγδεζηθικλμνξοπρστυφχψω"
    let alphabet: String = {
        var latinCapitalizedAlphabet = getStringByUnicodeRange(from: "\u{0041}", to: "\u{005A}")
        var latinLowerCasedAlphabet = getStringByUnicodeRange(from: "\u{0061}", to: "\u{007A}")
        var greekAlphabetFirstPart = getStringByUnicodeRange(from: "\u{0391}", to: "\u{03A1}")
        var greekAlphabetSecondPart = getStringByUnicodeRange(from: "\u{03A3}", to: "\u{03A9}")
//        var greekAlphabet = getAlphabet(from: "\u{0391}", to: "\u{03C9}")
        var alphabets = latinCapitalizedAlphabet + latinLowerCasedAlphabet + greekAlphabetFirstPart + greekAlphabetSecondPart
        print(alphabets)
        return alphabets
    }()
    var allowedSymbols = "+-*/^1234567890()"
    var digits = "0123456789"
    var operations = OperationType.getOperationSymbols()
    var brackets = "()"
    var possibleVariables: [Character] {
        var listOfCharacters = Array<Character>()
        alphabet.forEach { char in
            listOfCharacters.append(char)
        }
        return listOfCharacters
    }
    
    lazy var possibleVariablesStrings: [String] = {
        var listOfCharacters = Array<String>()
        alphabet.forEach { char in
            listOfCharacters.append(String(char))
        }
        return listOfCharacters
    }()
    
   mutating func addAllowedSymbol(character: Character) {
        allowedSymbols.append(character)
    }
    
    func getAllowedSymbols(for variables: [VariableModel]) -> String {
        var allowedSymbolsWithVariables = allowedSymbols
        variables.forEach { variable in
            allowedSymbolsWithVariables.append(variable.character)
        }
        return allowedSymbolsWithVariables
    }
    
    func getPossibleVariables(without variables: NSOrderedSet) -> [Character] {
        guard let variables = variables.array as? [VariableModel] else { return [] }
        var variableCharacters = Set<Character>()
        variables.forEach { variable in
            variableCharacters.insert(Character(variable.character))
        }
        let filtredVariableCharacters: [Character] = possibleVariables.filter { !variableCharacters.contains($0) }
        return filtredVariableCharacters
    }
    
    private static func getStringByUnicodeRange(from: String, to: String) -> String {
        var createdAlphabet = ""
        createdAlphabet.append(contentsOf: (Unicode.Scalar(from)!.value  ... Unicode.Scalar(to)!.value).lazy.map { Character(Unicode.Scalar($0).unsafelyUnwrapped) })
        return createdAlphabet
    }
    
}
