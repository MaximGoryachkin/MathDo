//
//  FormulaModel+CoreDataProperties.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 20.03.2022.
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
    @NSManaged public var id: URL?
    @NSManaged public var name: String?
    @NSManaged public var variables: NSOrderedSet?

}

// MARK: Generated accessors for variables
extension FormulaModel {

    @objc(insertObject:inVariablesAtIndex:)
    @NSManaged public func insertIntoVariables(_ value: VariableModel, at idx: Int)

    @objc(removeObjectFromVariablesAtIndex:)
    @NSManaged public func removeFromVariables(at idx: Int)

    @objc(insertVariables:atIndexes:)
    @NSManaged public func insertIntoVariables(_ values: [VariableModel], at indexes: NSIndexSet)

    @objc(removeVariablesAtIndexes:)
    @NSManaged public func removeFromVariables(at indexes: NSIndexSet)

    @objc(replaceObjectInVariablesAtIndex:withObject:)
    @NSManaged public func replaceVariables(at idx: Int, with value: VariableModel)

    @objc(replaceVariablesAtIndexes:withVariables:)
    @NSManaged public func replaceVariables(at indexes: NSIndexSet, with values: [VariableModel])

    @objc(addVariablesObject:)
    @NSManaged public func addToVariables(_ value: VariableModel)

    @objc(removeVariablesObject:)
    @NSManaged public func removeFromVariables(_ value: VariableModel)

    @objc(addVariables:)
    @NSManaged public func addToVariables(_ values: NSOrderedSet)

    @objc(removeVariables:)
    @NSManaged public func removeFromVariables(_ values: NSOrderedSet)

}

extension FormulaModel : Identifiable {

}
