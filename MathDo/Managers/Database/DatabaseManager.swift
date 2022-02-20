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
        let context = persistentContainer.viewContext
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
        let context = persistentContainer.viewContext
        do {
            let formulaList = try context.fetch(fetchRequest)
            let formulas = convertFormulaModelArrayToFormulaArray(formulaList)
            return formulas
            
        } catch(let error) {
            print(error.localizedDescription)
            return []
        }
        
    }
    
    func convertFormulaModelArrayToFormulaArray(_ formulaModels: [FormulaModel]) -> [Formula] {
        var formulas = Array<Formula>()
        formulaModels.forEach { formulaModel in
            let id = formulaModel.objectID.uriRepresentation()
            let name = formulaModel.name ?? ""
            let body = formulaModel.body ?? ""
            let favourite = formulaModel.favourite
            let description = formulaModel.formulaDescription
            
            var variables = Array<Variable>()
            guard let variableModels = formulaModel.variables else { return }
            
            for variableModel in variableModels {
                guard let characterString = variableModel.character else { continue }
                let character = Character(characterString)
                let variableDescription = variableModel.variableDescription
                variables.append(Variable(character: character, description: variableDescription, value: nil))
            }
            
            formulas.append(Formula(name: name, body: body, favourite: favourite, description: description, id: id, variables: variables))
            
        }
        return formulas
    }
    
    func save(_ formula: Formula, completion: @escaping (FormulaModel)->() = {FormulaModel in }) {
        guard let formulaEntityDescription = NSEntityDescription.entity(forEntityName: "FormulaModel", in: context) else {
            return
        }
        guard let variablesEntityDescription = NSEntityDescription.entity(forEntityName: "VariableModel", in: context) else {
            return
        }
        guard let formulaModel = NSManagedObject(entity: formulaEntityDescription, insertInto: context) as? FormulaModel else { return }
        
        formulaModel.name = formula.name
        formulaModel.body = formula.body
        formulaModel.favourite = formula.favourite
        formulaModel.id = formulaModel.objectID.uriRepresentation()
        var variablesSet = Set<VariableModel>()
        formula.variables.forEach { variable in
            let variableModel = VariableModel(entity: variablesEntityDescription, insertInto: context)
            variableModel.character = String(variable.character)
            variableModel.variableDescription = variable.description
            variablesSet.insert(variableModel)
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
        
//        context.delete()
    }
    
    
}


