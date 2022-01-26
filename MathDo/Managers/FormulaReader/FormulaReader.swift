//
//  FormulaReader.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 12.01.2022.
//

import Foundation



final class FormulaReader {

   static let shared = FormulaReader()
    
    var allowedSymbols = AllowedSymbols()
    
    private init() {}
    
//    MARK: - Formula reading methods
    func getResult(_ formula: String) -> String {
        let sequencedArray = getSequencedArray(expression: formula)
        let result = startCounting(for: sequencedArray)
        return result
    }
    
    private func startCounting(for sequencedArray: [String]) -> String {
    
        var countedArray = sequencedArray
        
        sequencedArray.enumerated().forEach { i, _ in
            let expression = countedArray[i]
            print("current expression:", expression)
            let result = operatedValue(for: expression)
            countedArray = countedArray.map { $0.replacingOccurrences(of: "(\(expression))", with: result)
            }
        }
        print("counted array:", countedArray)
        let result = operatedValue(for: countedArray.last!)
        print("final expression:", result)
        return result
    }
    
    private func getSequencedArray(expression: String) -> [String] {
        var expressions = Array<String>()
        startFindingRecursion(expression: expression)
        print("expressions:", expressions)
        
        func startFindingRecursion(expression: String) {
            let independendExpressions = getIndependedBracketsArray(expression: expression)
            independendExpressions.forEach { indExpr in
                startFindingRecursion(expression: indExpr)
            }
            expressions.append(expression)
        }
        return expressions
    }
    
    
    
    private func operatedValue(for expression: String) -> String {
        let countedExpression = calculateExpression(expression: expression)
        return countedExpression
    }
    
    private func getBracketsCount(expression: String) -> Int {
        var bracketsCount = 0
        expression.forEach { char in
            bracketsCount += char == "(" ? 1 : 0
        }
        return bracketsCount
    }
    
    private func getDependedBracketsArray(expression: String) -> [String] {
        var expressions = Array<String>()
        getDependedBracketsRecursion(expression: expression)
        
        func getDependedBracketsRecursion(expression: String) {
            if let withinBrackets = getFirstFromBrackets(expression: expression) {
                getDependedBracketsRecursion(expression: withinBrackets)
                expressions.append(withinBrackets)
            }
        }
        return expressions
    }
    
    private func getIndependedBracketsArray(expression: String) -> [String] {
        let bracketsCount = getIndependentBracketsCount(expression: expression)
        var currentExpression = expression
        var expressions = Array<String>()
        for _ in 0..<bracketsCount {
            let withinBrackets = getFirstFromBrackets(expression: currentExpression)
            if let withinBrackets = withinBrackets {
                expressions.append(withinBrackets)
                currentExpression = currentExpression.replacingOccurrences(of: "(\(withinBrackets))", with: "")
                print(currentExpression)
            }
        }
        return expressions
    }
    
    private func getIndependentBracketsCount(expression: String) -> Int {
        var bracketsCount = 0
        var openBrackets = 0
        var dependedOpenBrackets = 0
        var closingBrackets = 0
        var bracketIsOpen = false
        expression.forEach { char in
            
            if char == "(" {
                if !bracketIsOpen {
                    openBrackets += 1
                    bracketIsOpen = true
                } else {
                    dependedOpenBrackets += 1
                }
                
                }
            
            if char == ")" {
                closingBrackets += 1
                
                if closingBrackets > dependedOpenBrackets {
                    bracketIsOpen = false
                    openBrackets = 0
                    closingBrackets = 0
                    dependedOpenBrackets = 0
                    bracketsCount += 1
                }
            }
        }
        return bracketsCount
    }
    
    private func getFirstFromBrackets(expression: String) -> String? {
        expression.newSlice(from: "(", to: ")")
    }
    
    private func getAddition(expression: String) -> [String] {
        expression.components(separatedBy: "+")
    }
    
    private func getSubtraction(expression: String) -> [String] {
        expression.components(separatedBy: "-")
    }
    
    
    private func calculateExpression(expression: String) -> String {
        var expressionForCounting = expression
        startCalculatingRecursion(expression: &expressionForCounting)
        
        func startCalculatingRecursion(expression: inout String) {
            print("start Running")
            let isFinished = expressionIsFinished(expression: expression)
            print(isFinished)
            if isFinished {
                print("finished")
                return
            }
            toOperate(expression: &expression, operationType: .division)
            toOperate(expression: &expression, operationType: .exponentiation)
            toOperate(expression: &expression, operationType: .multiplication)
            toOperate(expression: &expression, operationType: .addition)
            toOperate(expression: &expression, operationType: .subtraction)
            startCalculatingRecursion(expression: &expression)
        }
        
        return expressionForCounting
    }
    
    private func toOperate(expression: inout String, operationType: OperationType) {
        
        let operation: Character = operationType.rawValue
        correctExpression(expression: &expression)
        let prototypeExpression = expression
        print("expression to operate:", expression)
        guard let firstOperand = expression.getFirstOperand(of: operation) else  {
            print("returned1")
            return }
        
        guard let secondOperand = expression.getSecondOperand(of: operation) else {
            print("returned2")
            return }
        

        print("firstOperand:", firstOperand)
        print("secondOperand:", secondOperand)
        guard let firstNumber = Double(firstOperand) else { return }
        guard let secondNumber = Double(secondOperand) else { return }
        var result: String
        switch operationType {
        case .exponentiation:
            result = getResultOfexponentiation(firstNumber: firstNumber, secondNumber: secondNumber)
            print(result)
        case .multiplication:
            result = getResultOfMultiplication(firstNumber: firstNumber, secondNumber: secondNumber)
            print(result)
        case .division:
            result = getResultOfDivision(firstNumber: firstNumber, secondNumber: secondNumber)
            print("result of division:", result)
        case .addition:
            result = getResultOfAddition(firstNumber: firstNumber, secondNumber: secondNumber)
            print(result)
        case .subtraction:
            result = getResultOfSubtraction(firstNumber: firstNumber, secondNumber: secondNumber)
            print("result of subtraction:", result)
        }

        
        guard let firstIndex = prototypeExpression.getFirstOperandStartIndex(of: operation) else { return }
        print("first Index of First Operand:", expression[firstIndex])
        guard let secondIndex = prototypeExpression.getSecondOperandLastIndex(of: operation) else { return }
        print("expression before replacing:", expression)
        print("prototype expression:", prototypeExpression)
        print("substring of range before:", expression[firstIndex...secondIndex])
        expression = expression.replacingCharacters(in: firstIndex...secondIndex, with: result)
        print("new expression:", expression)
//        print("substring of range after:", expression[firstIndex...secondIndex])
        correctExpression(expression: &expression)
        print("expression after correcting:", expression)
    }
    
    private func getResultOfDivision(firstNumber: Double, secondNumber: Double) -> String {
        String(firstNumber / secondNumber)
    }
    
    private func getResultOfexponentiation(firstNumber: Double, secondNumber: Double) -> String {
        String(pow(firstNumber, secondNumber))
    }
    
    private func getResultOfMultiplication(firstNumber: Double, secondNumber: Double) -> String {
        String(firstNumber * secondNumber)
    }
    
    private func getResultOfAddition(firstNumber: Double, secondNumber: Double) -> String {
        String(firstNumber + secondNumber)
    }
    
    private func getResultOfSubtraction(firstNumber: Double, secondNumber: Double) -> String {
        String(firstNumber - secondNumber)
    }
    
    
    private func getArrayOfElements(array: [String] ,except: String) -> [String] {
        let operationsSymbols = ["+", "-", "/", "*"]
       return operationsSymbols.filter { element in
            element != except
        }
    }
    
    private func getArrayOfNumbers(expression: String) -> [String] {
        let operationsSymbols: CharacterSet = ["+", "-", "/", "*"]
        let numbers = expression.components(separatedBy: operationsSymbols)
        return numbers.filter { char in
            char != ""
        }
    }
    
    private func expressionIsFinished(expression: String) -> Bool {
        let operationsSymbols: [Character] = ["+", "-", "/", "*", "^", "!"]
        var isContains: Bool = false
        
        expression.forEach { char in
            isContains = operationsSymbols.contains(char) ? true : isContains
        }
        
        return !isContains
    }
    
//    MARK: - Formula correction methods
    
    public func correctInputExpression(expression: inout String?) {
        findHiddenMultiplication(expression: &expression)
        findExtraSignsAfterOpeningBracket(expression: &expression)
        findExtraSignBeforeClosingBracket(expression: &expression)
        
        findSpaces(expression: &expression)
    }
    
    private func correctExpression(expression: inout String) {
        findSignCollisions(expression: &expression)
        findMinusBeforeNumber(expression: &expression)
    }
    
    private func findMinusBeforeNumber(expression: inout String) {
        expression.forEach { char in
            if expression.startIndex == expression.firstIndex(of: "-") {
                expression = expression.replacingCharacters(in: expression.startIndex...expression.startIndex, with: "minus")
            }
        }
    }
    
    private func findSignCollisions(expression: inout String) {
        expression = expression.replacingOccurrences(of: "+-", with: "-")
        expression = expression.replacingOccurrences(of: "--", with: "-")
        expression = expression.replacingOccurrences(of: "-+", with: "-")
        expression = expression.replacingOccurrences(of: "++", with: "+")
    }
    
    private func findSpaces(expression: inout String?) {
        expression = expression?.replacingOccurrences(of: " ", with: "")
    }
    
    private func findHiddenMultiplication(expression: inout String?) {
        let operationSymbolsString = String(OperationType.getOperationSymbols())
        guard var newExpression = expression else { return }
        var openingBracketsIndices: [String.Index] {
            newExpression.indices.filter { newExpression[$0] == "("}
        }
        for numberOfIndex in 0..<openingBracketsIndices.count {
            let indexOfExpression = openingBracketsIndices[numberOfIndex]
            guard let symbolBefore = expression?.getSymbolBefore(index: indexOfExpression) else { continue }
            if !operationSymbolsString.contains(symbolBefore) {
                newExpression.insert("*", at: indexOfExpression)
            }
        }
        expression = newExpression
    }
    
    private func findExtraSignsAfterOpeningBracket(expression: inout String?) {
        guard let newExpression = expression else { return }
        var operationSymbolsWithoutMinusString: String {
            let operationSymbols = String(OperationType.getOperationSymbols())
            let operationSymbolsWithoutMinus = operationSymbols.filter { $0 != "-"}
            return operationSymbolsWithoutMinus
        }
        var operationsIndices: [String.Index] {
            newExpression.indices.filter { operationSymbolsWithoutMinusString.contains(newExpression[$0]) }
        }
        
        for numberOfIndex in 0..<operationsIndices.count {
          let indexOfOperation = operationsIndices[numberOfIndex]
            guard let symbolBefore = newExpression.getSymbolBefore(index: indexOfOperation) else {
                if indexOfOperation == newExpression.startIndex {
                    expression = expression?.replacingCharacters(in: indexOfOperation...indexOfOperation, with: " ")
                }
                continue }
            if symbolBefore  == "(" {
                expression = expression?.replacingCharacters(in: indexOfOperation...indexOfOperation, with: " ")
            }
        }
    }
    
    private func findExtraSignBeforeClosingBracket(expression: inout String?) {
        guard let newExpression = expression else { return }
        let operationSymbols = String(OperationType.getOperationSymbols())
        print(newExpression)
        var operationsIndices: [String.Index] {
            newExpression.indices.filter {
                operationSymbols.contains(newExpression[$0])
            }
        }
        
        for numberOfIndex in 0..<operationsIndices.count {
            let indexOfOperation = operationsIndices[numberOfIndex]
            guard let symbolAfter = newExpression.getSymbolAfter(index: indexOfOperation) else {
                if newExpression.lastIndex == indexOfOperation {
                    expression = expression?.replacingCharacters(in: indexOfOperation...indexOfOperation, with: " ")
                }
                continue }
            if symbolAfter == ")" {
                expression = expression?.replacingCharacters(in: indexOfOperation...indexOfOperation, with: " ")
            }
        }
    }

//    MARK: - Formula verify methods
    
    public func verifyFormulaSyntax(expression: String, completion: (_ success: Bool, _ error: Error? )->()) {
        let failed = false
        guard expressionHasOnlyAllowedSymbols(expression: expression) else { return
            completion(failed, createError(withText: "expression has illegal symbols", code: 0))
            }
        guard expressionIsNotExmpty(expression: expression) else { return
            completion(failed, createError(withText: "expression is empty", code: 1))
            }
        guard parenthesesOrderIsCorrect(expression: expression) else { return
            completion(failed, createError(withText: "parentheses order is incorrect", code: 2))
        }
        guard parenthesesCountIsCorrect(expression: expression) else { return
            completion(failed, createError(withText: #"opening brackets "(" count is not conform to closing brackets ")" count"#, code: 3))
        }
        guard expressionHasNotSignCollision(expression: expression) else { return
            completion(failed, createError(withText: "expression has sign collision", code: 4))
        }
        completion(!failed, nil)
    }
    
    private func createError(withText text: String, code: Int) -> Error {
        NSError(domain: "", code: code, userInfo: [ NSLocalizedDescriptionKey: text])
    }
    
    private func expressionHasOnlyAllowedSymbols(expression: String) -> Bool {
        var isContains = true
        expression.forEach { char in
            isContains = allowedSymbols.allowedSymbols.contains(char) ? isContains : false
        }
        return isContains
    }
    
    private func expressionIsNotExmpty(expression: String) -> Bool {
        !expression.isEmpty
    }
    
    private func parenthesesOrderIsCorrect(expression: String) -> Bool {
        var openingBrackets = 0
        var closingBrackets = 0
        var isCorrect = true
        expression.forEach { char in
            if char == "(" {
                openingBrackets += 1
            } else if char == ")" {
                closingBrackets += 1
            }
            
            if closingBrackets > openingBrackets {
                isCorrect = false
                return
            }
        }
        return isCorrect
    }
    
    private func parenthesesCountIsCorrect(expression: String) -> Bool {
        var openingBrackets = 0
        var closingBrackets = 0
        
        expression.forEach { char in
            openingBrackets += char == "(" ? 1 : 0
            closingBrackets += char == ")" ? 1 : 0
        }
        
        return openingBrackets == closingBrackets
    }
    
    private func expressionHasNotSignCollision(expression: String) -> Bool {
        var hasNotCollision = true
        var previousCharIsOperationSign = false
        let operationSymbols = OperationType.getOperationSymbols()
        expression.forEach { char in
            if operationSymbols.contains(char) {
                if previousCharIsOperationSign {
                    hasNotCollision = false
                    return
                }
                previousCharIsOperationSign = true
            } else {
                previousCharIsOperationSign = false
            }
        }
        return hasNotCollision
    }
}

