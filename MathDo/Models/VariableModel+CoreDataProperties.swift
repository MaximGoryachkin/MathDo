//
//  VariableModel+CoreDataProperties.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 09.02.2022.
//
//

import Foundation
import CoreData


extension VariableModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VariableModel> {
        return NSFetchRequest<VariableModel>(entityName: "VariableModel")
    }

    @NSManaged public var character: String?
    @NSManaged public var variableDescription: String?

}

extension VariableModel : Identifiable {

}
