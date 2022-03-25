//
//  DatabaseManager.swift
//  MathDo
//
//  Created by Вячеслав Макаров on 04.02.2022.
//

import CoreData


final class DatabaseManager {
    
    public static let shared = DatabaseManager()
    
    let persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "FormulaDataModel")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     }()
    
    private let context: NSManagedObjectContext!
    private let abstractContext: NSManagedObjectContext!
    
    private init() {
        context = persistentContainer.viewContext
        abstractContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func getContext() -> NSManagedObjectContext {
        context
    }
    
    func getAbstractContext() -> NSManagedObjectContext {
        abstractContext
    }
    
    func fetchData() -> [FormulaModel] {
        let fetchRequest = FormulaModel.fetchRequest()
        do {
            let formulaList = try context.fetch(fetchRequest)
            return formulaList
        } catch(let error) {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchFormulas() -> [FormulaModel] {
        let fetchRequest = FormulaModel.fetchRequest()
        do {
            let formulaList = try context.fetch(fetchRequest)
            return formulaList
            
        } catch(let error) {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchFormula(by id: URL) -> FormulaModel? {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else { return nil}
        guard let object =  context.object(with: objectId) as? FormulaModel else { return nil}
        
//        let variables = convertVariableModelSetToVariableArray(object.variables)
        
//        return Formula(name: object.name ?? "", body: object.body ?? "", favourite: object.favourite, description: object.description, id: id, variables: variables)
        return object
    }
    
    func variableIsExist(id: URL) -> Bool {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else { return false}
        guard context.object(with: objectId) is VariableModel else { return false}
        return true
    }
    
    
//    func convertFormulaModelArrayToFormulaArray(_ formulaModels: [FormulaModel]) -> [Formula] {
//        var formulas = Array<Formula>()
//        formulaModels.forEach { formulaModel in
//            let id = formulaModel.objectID.uriRepresentation()
//            let name = formulaModel.name ?? ""
//            let body = formulaModel.body ?? ""
//            let favourite = formulaModel.favourite
//            let description = formulaModel.formulaDescription
//
//            let variables = convertVariableModelSetToVariableArray(formulaModel.variables)
//            formulas.append(Formula(name: name, body: body, favourite: favourite, description: description, id: id, variables: variables))
//
//        }
//        return formulas
//    }
    
//    func convertVariableModelSetToVariableArray(_ variableModels: Set<VariableModel>?) -> [Variable] {
//        guard let variableModels = variableModels else { return [] }
//        var variables = Array<Variable>()
//        for variableModel in variableModels {
//            guard let characterString = variableModel.character else { continue }
//            let id = variableModel.objectID.uriRepresentation()
//            let character = Character(characterString)
//            let variableDescription = variableModel.variableDescription
//            variables.append(Variable(character: character, description: variableDescription, value: 0, id: id))
//        }
//        return variables
//    }
    
//    func convertVariableArrayToVariableModelSet(for variableModels: inout Set<VariableModel>, variables: Array<Variable>?)  {
//        guard let variables = variables else { return }
//
//        for variable in variables {
//            guard variable.id == nil else { setChangesInVariableModel(variable, for: &variableModels); continue }
//            createVariableModelFromVariable(variable, for: &variableModels)
//        }
//
//    }
    
//    func createVariableModelFromVariable(_ variable: Variable, for variableModels: inout Set<VariableModel>) {
//        guard let variablesEntityDescription = NSEntityDescription.entity(forEntityName: "VariableModel", in: context) else { return }
//        let variableModel = VariableModel(entity: variablesEntityDescription, insertInto: context)
//        let char = String(variable.character)
//        variableModel.id = variableModel.objectID.uriRepresentation()
//        variableModel.character = char
//        variableModel.variableDescription = variable.description
//        variableModels.insert(variableModel)
//    }
    
//    func setChangesInVariableModel(_ variable: Variable, for variableModels: inout Set<VariableModel>) {
//        variableModels.forEach { variableModel in
//            if variableModel.id == variable.id {
//                variableModel.variableDescription = variable.description
//            }
//        }
//    }
    
//    func deleteExtraVariables(in formula: Formula) {
//        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: formula.id) else { return }
//        guard let object =  context.object(with: objectId) as? FormulaModel else { return }
//
//        var existedVariableIDs = Array<URL>()
//        var idsToDelete = Array<URL>()
//
//        var allIDsInVariableModels = object.variables?.map { $0.id }
//        var factIdsVariableModels = object.variables?.map { $0.objectID.uriRepresentation() }
//        var allIDsInVariables = formula.variables.map { $0.id! }
//        idsToDelete = allIDsInVariables.filter { allIDsInVariables.contains($0) }
//
//
//        idsToDelete.forEach { id in
//            deleteVariable(by: id)
//        }
        
//        factIdsVariableModels?.forEach({ id in
//            deleteVariable(by: id)
//        })
        
//        allIDsInVariableModels?.forEach { id in
//            if !allIDsInVariables.contains(id) {
//                deleteVariable(by: id!)
//                print(id)
//            }
//        }
//        print("all ids in model:", allIDsInVariableModels)
//        print("fact ids:", factIdsVariableModels)
//
//       print("all ids in variable:", allIDsInVariables)
//        print("ids to delete:", idsToDelete)
        
//        object.variables?.forEach { variableModel in
//            formula.variables.forEach { variable in
//                if variableModel.id == variable.id {
//                    guard let id = variableModel.id else { return }
//                    existedVariableIDs.append(id)
//                }
//            }
//        }
        
//    }
    
    func save(_ formula: FormulaModel, completion: @escaping (FormulaModel)->() = {FormulaModel in }) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
            completion(formula)
        }
    }
    
    func save(_ formula: FormulaModel, in id: URL) {
       let objectId = formula.objectID
//        guard let object =  context.object(with: objectId) as? FormulaModel else { return }
//        object.name = formula.name
//        object.body = formula.body
//        object.formulaDescription = formula.description
//        convertVariableArrayToVariableModelSet(for: &object.variables!, variables: formula.variables)
//        deleteExtraVariables(in: formula)
        
        do {
            try context.save()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func delete(variable: VariableModel) {
        context.delete(variable)
    }
    
    func delete(formula: FormulaModel, completion: ()->() = {}) {
        
        formula.variables?.forEach {  variable in
            guard let variable = variable as? VariableModel else { return }
            context.delete(variable)
        }
        
        context.delete(formula)
        
        do {
            try context.save()
            completion()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func delete(variable: VariableModel, completion: ()->() = {}) {
        guard let objectURI = variable.id else { return }
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: objectURI) else { return }
        
        do {
            let object = try context.existingObject(with: objectID)
            context.delete(object)
            try context.save()
            completion()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func delete(variableModel: VariableModel, completion: ()->() = {}) {
        do {
//            let object = try context.existingObject(with: variableModel.objectID)
            context.delete(variableModel)
            
            try context.save()
            completion()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func deleteVariable(by id: URL) {
        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else { return }
        let object = context.object(with: objectID) as! VariableModel
        
        print("Variable to deleting:", object.character)
        
        do {
            
            context.delete(object)
            try context.save()
            
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func cancelAllChanges() {
        context.rollback()
    }
}


