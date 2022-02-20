//
//  FormulaModel+CoreDataProperties.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 19.02.2022.
//
//

import Foundation
import CoreData


extension FormulaModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormulaModel> {
        return NSFetchRequest<FormulaModel>(entityName: "FormulaModel")
    }

    @NSManaged public var body: String?
    @NSManaged public var favourite: Bool
    @NSManaged public var formulaDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var id: URL?
    @NSManaged public var variables: Set<VariableModel>?

}

// MARK: Generated accessors for variables
extension FormulaModel {

    @objc(addVariablesObject:)
    @NSManaged public func addToVariables(_ value: VariableModel)

    @objc(removeVariablesObject:)
    @NSManaged public func removeFromVariables(_ value: VariableModel)

    @objc(addVariables:)
    @NSManaged public func addToVariables(_ values: NSSet)

    @objc(removeVariables:)
    @NSManaged public func removeFromVariables(_ values: NSSet)

}

extension FormulaModel : Identifiable {

}
