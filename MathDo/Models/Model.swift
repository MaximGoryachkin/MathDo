//
//  Model.swift
//  MathDo
//
//  Created by Максим Горячкин on 10.01.2022.
//

import Foundation


struct Formula {
    let name: String
    let body: String
    let favourite: Bool
    let description: String?
    var id: URL = URL(fileURLWithPath: "")
    var variables: [Variable]
}

struct Variable: Hashable {
    let character: Character
    var description: String?
    var value: Double? = 0
}

enum CreatingType {
    case creating
    case editing(id: Int)
}

extension Formula {
    static func getData() -> [Formula] {
        [
//            Formula(id: 0, name: "Ohm's law", body: "U=RI", favourite: false, description: nil, variables: [Variable(character: "A", description: "First variable", value: 123.32423), Variable(character: "B", description: "Second variable", value: 21.2385)]),
//            Formula(id: 1, name: "Quadratic equation", body: "y=x^2", favourite: false, description: nil, variables: [Variable(character: "D", description: "Variable D", value: 32.3422), Variable(character: "C", description: "Variable C", value: 43.2352)])
        ]
    }
}

extension Variable: Comparable {
    static func < (lhs: Variable, rhs: Variable) -> Bool {
        lhs.character < rhs.character
    }
}
