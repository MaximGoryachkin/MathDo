//
//  FormulaReader.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 12.01.2022.
//

import Foundation



enum FormulaError: String, Error {
        
    case illegalSymbolsError = "expression has illegal symbols"
    case emptyExpressionError = "Expression is empty"
    case parenthesesOrderError = "parentheses order is incorrect"
    case parenthesesCountError = #"opening brackets "(" count is not conform to closing brackets ")" count"#
    case signCollisionError = "expression has sign collision"
    case recursionError = "Error with reading formula or expression is difficult"
    case longNumberError = "Error with reading formula or number is too long"
    case divisionByZeroError = "Expression has division by zero. Division by zero is impossible"
    case resultIsNaNError = "Expression isn't number or expression has division by zero"
    case resultIsInfinite = "Expression result is infinite or expression has division by zero"
    func getError() -> Error {
        switch self {
        case .illegalSymbolsError:
            return createError(withText: rawValue, code: 0)
        case .emptyExpressionError:
            return createError(withText: rawValue, code: 1)
        case .parenthesesOrderError:
            return createError(withText: rawValue, code: 2)
        case .parenthesesCountError:
            return createError(withText: rawValue, code: 3)
        case .signCollisionError:
            return createError(withText: rawValue, code: 4)
        case .recursionError:
            return createError(withText: rawValue, code: 5)
        case .longNumberError:
            return createError(withText: rawValue, code: 6)
        case .divisionByZeroError:
            return createError(withText: rawValue, code: 7)
        case .resultIsNaNError:
            return createError(withText: rawValue, code: 8)
        case .resultIsInfinite:
            return createError(withText: rawValue, code: 9)
        }
    }
    
    private func createError(withText text: String, code: Int) -> Error {
        NSError(domain: "", code: code, userInfo: [ NSLocalizedDescriptionKey: text])
    }
}


final class FormulaReader {

   static let shared = FormulaReader()
    
    var allowedSymbols = AllowedSymbols()
    
    private var steps = Array<String>()
    
    private init() {}
    
//    MARK: - Formula reading methods
    func getResult(_ formula: String, variables: [VariableModel] = []) throws -> String {
        var formula = formula
        var readingError: Error?
        steps.removeAll()
        verifyFormulaSyntax(expression: formula, variables: variables) { success, sender, error in
            guard let error = error else { return }
            readingError = error
        }
        
        if let readingError = readingError {
            throw readingError
        }
        
        replaceVariablesWithNumbers(expression: &formula, variables: variables)
        
        do {
            let sequencedArray = try getSequencedArray(expression: formula)
            var result = try startCounting(for: sequencedArray)
            correctResult(result: &result)
            steps.append("result is \(result)")
            return result
        } catch(let error) {
            throw error
        }
    }
    
    private func startCounting(for sequencedArray: [String]) throws -> String {
        var countedArray = sequencedArray
        var result = ""
        try sequencedArray.enumerated().forEach { i, _ in
            let expression = countedArray[i]
            print("current expression:", expression)
            do {
                result = try operatedValue(for: expression)
                countedArray = countedArray.map { $0.replacingOccurrences(of: "(\(expression))", with: result)
                }
            } catch(let error) {
                throw error
            }
        }
        print("counted array:", countedArray)
//        do {
//      result = try operatedValue(for: countedArray.last!)
//        } catch(let error) {
//            throw error
//        }
        print("final expression:", result)
        return result
    }
    
    func getSteps() -> [String] {
       steps
    }
    
    func removeSteps() {
        steps.removeAll()
    }
    
    
    
    private func getSequencedArray(expression: String) throws -> [String] {
        let recursionLimit = 1500
        var recursionCounter = 0
        var expressions = Array<String>()
        do {
            try  startFindingRecursion(expression: expression)
        } catch(let error) {
            throw error
        }
        print("expressions:", expressions)
        
        func startFindingRecursion(expression: String)  throws {
            recursionCounter += 1
            guard recursionCounter < recursionLimit else { throw FormulaError.recursionError.getError() }
            let independendExpressions = getIndependedBracketsArray(expression: expression)
            try independendExpressions.forEach { indExpr in
                try startFindingRecursion(expression: indExpr)
            }
            expressions.append(expression)
        }
        return expressions
    }
    
    
    
    private func operatedValue(for expression: String) throws -> String {
        do {
            let countedExpression =  try calculateExpression(expression: expression)
            return countedExpression
        } catch(let error) {
            throw error
        }
    }
    
    private func getBracketsCount(expression: String) -> Int {
        var bracketsCount = 0
        expression.forEach { char in
            bracketsCount += char == "(" ? 1 : 0
        }
        return bracketsCount
    }
    
    private func getDependedBracketsArray(expression: String) throws -> [String] {
        let recursionLimit = 1500
        var recursionCounter = 0
        var expressions = Array<String>()
        do {
        try getDependedBracketsRecursion(expression: expression)
        } catch(let error) {
            throw error
        }
        func getDependedBracketsRecursion(expression: String) throws {
            recursionCounter += 1
            guard recursionCounter < recursionLimit else { throw  FormulaError.recursionError.getError()}
            if let withinBrackets = getFirstFromBrackets(expression: expression) {
                try getDependedBracketsRecursion(expression: withinBrackets)
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
        expression.slice(from: "(", to: ")")
    }
    
    private func getAddition(expression: String) -> [String] {
        expression.components(separatedBy: "+")
    }
    
    private func getSubtraction(expression: String) -> [String] {
        expression.components(separatedBy: "-")
    }
    
    
    private func calculateExpression(expression: String) throws -> String {
        let recursionLimit = 1500
        var recursionCounter = 0
        var expressionForCounting = expression
        do {
            try startCalculatingRecursion(expression: &expressionForCounting)
        } catch(let error) {
            throw error
        }
        
        
        func startCalculatingRecursion(expression: inout String) throws {
            print("start Running")
            print("___________________COUNT:", recursionCounter)
            recursionCounter += 1
            guard recursionCounter < recursionLimit else { throw FormulaError.longNumberError.getError() }
            let isFinished = expressionIsFinished(expression: expression)
            print(isFinished)
            if isFinished {
                print("finished")
                return
            }
            
           try OperationType.allCases.forEach { operation in
                            try toOperate(expression: &expression, operationType: operation)
            }
            
            try startCalculatingRecursion(expression: &expression)
        }
        
        return expressionForCounting
    }
    
    private func toOperate(expression: inout String, operationType: OperationType) throws {
        
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
            result = try getResultOfDivision(firstNumber: firstNumber, secondNumber: secondNumber)
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
        let resultNumber = Double(result) ?? 0.0
        let formattedFirstOperand = FormatManager.shared.formatNumber(number: firstNumber, style: .none)
        let formattedSecondOperand = FormatManager.shared.formatNumber(number: secondNumber, style: .none)
        let formattedResult = FormatManager.shared.formatNumber(number: resultNumber, style: .decimal)
        steps.append("\(operationType): \(formattedFirstOperand) \(operation) \(formattedSecondOperand) = \(formattedResult)")
        correctExpression(expression: &expression)
        print("expression after correcting:", expression)
    }
    
    private func getResultOfDivision(firstNumber: Double, secondNumber: Double) throws -> String {
        guard !secondNumber.isZero else { throw FormulaError.divisionByZeroError.getError() }
        let result = firstNumber / secondNumber
    
        guard !result.isNaN else { throw FormulaError.resultIsNaNError.getError() }
        guard !result.isInfinite else { throw FormulaError.resultIsInfinite.getError() }
        return String(result)
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
    
    private func replaceVariablesWithNumbers(expression: inout String, variables: [VariableModel]) {
        
        for variable in variables {
            let number = variable.variableValue
            expression = expression.replacingOccurrences(of: String(variable.character), with: String(number))
        }
    }
//    MARK: Result correction methods
    private func correctResult(result: inout String) {
        replaceMinusWordWithSign(result: &result)
        formatResult(result: &result)
    }
    
    private func replaceMinusWordWithSign(result: inout String) {
        result = result.replacingOccurrences(of: "minus", with: "-")
    }
    
    private func formatResult(result: inout String) {
        guard let resultDouble = Double(result) else { return }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber(value: resultDouble)
        guard let numberString = numberFormatter.string(from: number) else { return }
        result = numberString
    }
    
    
//    MARK: - Formula correction methods
    
    public func correctInputExpression(expression: inout String?, with variables: NSOrderedSet?) {
        guard let variables = variables?.array as? [VariableModel] else {
            return
        }

//        findHiddenMultiplicationForClosingBrackets(expression: &expression)
        findHiddenMultiplicationForBrackets(expression: &expression)
        findHiddenMultiplicationForVariables(expression: &expression, variables: variables)
        
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
    
    private func findHiddenMultiplicationForBrackets(expression: inout String?, variables: [VariableModel] = []) {
        let operationSymbolsString = String(OperationType.getOperationSymbols())
        guard var newExpression = expression else { return }
        var openingBracketsIndices: [String.Index] {
            newExpression.indices.filter { newExpression[$0] == "(" }
        }
        var closingBracketsIndices: [String.Index] {
            newExpression.indices.filter { newExpression[$0] == ")" }
        }
        
        for numberOfIndex in 0..<closingBracketsIndices.count {
            let indexOfExpression = closingBracketsIndices[numberOfIndex]
            guard let symbolAfter = newExpression.getSymbolAfter(index: indexOfExpression) else { continue }

            if !operationSymbolsString.contains(symbolAfter) {
                newExpression.insert("*", at: newExpression.index(after: indexOfExpression))
            }
        }
        
        for numberOfIndex in 0..<openingBracketsIndices.count {
            let indexOfExpression = openingBracketsIndices[numberOfIndex]
            guard let symbolBefore = newExpression.getSymbolBefore(index: indexOfExpression) else { continue }
            
            if !operationSymbolsString.contains(symbolBefore) {
                newExpression.insert("*", at: indexOfExpression)
            }
        }
        expression = newExpression
    }
    
    
    private func findHiddenMultiplicationForVariables(expression: inout String?, variables: [VariableModel]) {
        guard var newExpression = expression else { return }
        var variablesString = ""
        let digitsString = allowedSymbols.digits
        variables.forEach { variable in
            variablesString.append(variable.character)
        }
        var variableIndices: [String.Index] {
            newExpression.indices.filter { variablesString.contains(newExpression[$0])   }
        }
        
        for numberOfIndex in 0..<variableIndices.count {
            let indexOfExpression = variableIndices[numberOfIndex]
            if let symbolAfter = newExpression.getSymbolAfter(index: indexOfExpression) {
                if variablesString.contains(symbolAfter) || digitsString.contains(symbolAfter) {
                    newExpression.insert("*", at: newExpression.index(after: indexOfExpression) )
                }
            }
            if let symbolBefore = newExpression.getSymbolBefore(index: indexOfExpression) {
                if variablesString.contains(symbolBefore) || digitsString.contains(symbolBefore) {
                    newExpression.insert("*", at: indexOfExpression)
                }
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
    
    public func verifyFormulaSyntax(expression: String, variables: [VariableModel] = [], completion: (_ success: Bool, _ sender: Any?, _ error: Error? )->()) {
        let failed = false
        
        guard expressionHasOnlyAllowedSymbols(expression: expression, variables: variables) else {
            let undefinedVariables = getUndefinedVariables(expression: expression, variables: variables)
            completion(failed, undefinedVariables.isEmpty ? nil : undefinedVariables, FormulaError.illegalSymbolsError.getError())
            return
            }
        guard expressionIsNotExmpty(expression: expression) else { return
            completion(failed, nil, FormulaError.emptyExpressionError.getError())
            }
        guard parenthesesOrderIsCorrect(expression: expression) else { return
            completion(failed, nil, FormulaError.parenthesesOrderError.getError())
        }
        guard parenthesesCountIsCorrect(expression: expression) else { return
            completion(failed, nil, FormulaError.parenthesesCountError.getError())
        }
        guard expressionHasNotSignCollision(expression: expression) else { return
            completion(failed, nil, FormulaError.signCollisionError.getError())
        }
        completion(!failed, nil, nil)
    }
    
    private func expressionHasOnlyAllowedSymbols(expression: String, variables: [VariableModel] = []) -> Bool {
        let allowedSymbolsWithVariables = allowedSymbols.getAllowedSymbols(for: variables)
        var isContains = true
        expression.forEach { char in
            isContains = allowedSymbolsWithVariables.contains(char) ? isContains : false
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
    
    private func getUndefinedVariables(expression: String, variables: [VariableModel]) -> [VariableTemporaryModel] {
        let usedVariables = variables.map{ $0.character }
        var undefinedVariables = Array<Character>()
        var variablesOfExpression = Array<VariableTemporaryModel>()
        expression.forEach { char in
            if allowedSymbols.possibleVariables.contains(char) && !usedVariables.contains(String(char)) && !undefinedVariables.contains(char) {
                undefinedVariables.append(char)
                let variableModel = VariableTemporaryModel(character: char)
                variablesOfExpression.append(variableModel)
            }
        }
        return variablesOfExpression
    }
}

