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
    
    private init() {
        context = persistentContainer.viewContext
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
    
    func fetchFormulas() -> [Formula] {
        let fetchRequest = FormulaModel.fetchRequest()
        do {
            let formulaList = try context.fetch(fetchRequest)
            let formulas = convertFormulaModelArrayToFormulaArray(formulaList)
            return formulas
            
        } catch(let error) {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchFormula(by id: URL) -> Formula? {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else { return nil}
        guard let object =  context.object(with: objectId) as? FormulaModel else { return nil}
        
        let variables = convertVariableModelSetToVariableArray(object.variables)
        
        return Formula(name: object.name ?? "", body: object.body ?? "", favourite: object.favourite, description: object.description, id: id, variables: variables)
    }
    
    func variableIsExist(id: URL) -> Bool {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else { return false}
        guard context.object(with: objectId) is VariableModel else { return false}
        return true
    }
    
    
    func convertFormulaModelArrayToFormulaArray(_ formulaModels: [FormulaModel]) -> [Formula] {
        var formulas = Array<Formula>()
        formulaModels.forEach { formulaModel in
            let id = formulaModel.objectID.uriRepresentation()
            let name = formulaModel.name ?? ""
            let body = formulaModel.body ?? ""
            let favourite = formulaModel.favourite
            let description = formulaModel.formulaDescription
            
            let variables = convertVariableModelSetToVariableArray(formulaModel.variables)
//
//            var variables = Array<Variable>()
//            guard let variableModels = formulaModel.variables else { return }
//
//            for variableModel in variableModels {
//                guard let characterString = variableModel.character else { continue }
//                let character = Character(characterString)
//                let variableDescription = variableModel.variableDescription
//                variables.append(Variable(character: character, description: variableDescription, value: 0))
//            }
            
            formulas.append(Formula(name: name, body: body, favourite: favourite, description: description, id: id, variables: variables))
            
        }
        return formulas
    }
    
    func convertVariableModelSetToVariableArray(_ variableModels: Set<VariableModel>?) -> [Variable] {
        guard let variableModels = variableModels else { return [] }
        var variables = Array<Variable>()
        for variableModel in variableModels {
            guard let characterString = variableModel.character else { continue }
            guard let id = variableModel.id else { continue }
            let character = Character(characterString)
            let variableDescription = variableModel.variableDescription
            variables.append(Variable(character: character, description: variableDescription, value: 0, id: id))
        }
        return variables
    }
    
    func convertVariableArrayToVariableModelSet(for variableModels: inout Set<VariableModel>, variables: Array<Variable>?)  {
        guard let variables = variables else { return }
        
        for variable in variables {
            guard variable.id == nil else { setChangesInVariableModel(variable, for: &variableModels); continue }
            createVariableModelFromVariable(variable, for: &variableModels)
        }

    }
    
    func createVariableModelFromVariable(_ variable: Variable, for variableModels: inout Set<VariableModel>) {
        guard let variablesEntityDescription = NSEntityDescription.entity(forEntityName: "VariableModel", in: context) else { return }
        let variableModel = VariableModel(entity: variablesEntityDescription, insertInto: context)
        let char = String(variable.character)
        variableModel.id = variableModel.objectID.uriRepresentation()
        variableModel.character = char
        variableModel.variableDescription = variable.description
        variableModels.insert(variableModel)
    }
    
    func setChangesInVariableModel(_ variable: Variable, for variableModels: inout Set<VariableModel>) {
        variableModels.forEach { variableModel in
            if variableModel.id == variable.id {
                variableModel.variableDescription = variable.description
            }
        }
    }
    
    func save(_ formula: Formula, completion: @escaping (FormulaModel)->() = {FormulaModel in }) {
        guard let formulaEntityDescription = NSEntityDescription.entity(forEntityName: "FormulaModel", in: context) else {
            return
        }
        
        guard let formulaModel = NSManagedObject(entity: formulaEntityDescription, insertInto: context) as? FormulaModel else { return }
        
        formulaModel.name = formula.name
        formulaModel.body = formula.body
        formulaModel.favourite = formula.favourite
        formulaModel.id = formulaModel.objectID.uriRepresentation()
        var variablesSet = Set<VariableModel>()
        formula.variables.forEach { variable in
            createVariableModelFromVariable(variable, for: &variablesSet)
        }
        
        formulaModel.variables = variablesSet
        
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
            completion(formulaModel)
        }
    }
    
    func save(_ formula: Formula, in id: URL) {
        guard let objectId = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: id) else { return }
        guard let object =  context.object(with: objectId) as? FormulaModel else { return }
        object.name = formula.name
        object.body = formula.body
        object.formulaDescription = formula.description
        convertVariableArrayToVariableModelSet(for: &object.variables!, variables: formula.variables)
//        print("variables:")
//        print(object.variables)
        do {
            try context.save()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func delete(formula: Formula, completion: ()->() = {}) {
        let objectURI = formula.id
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
}


