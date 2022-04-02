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
    
    func getContext() -> NSManagedObjectContext {
        context
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
        return object
    }
    
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
    
    func cancelAllChanges() {
        context.rollback()
    }
    
    func save(_ formula: FormulaModel, in id: URL) {
        do {
            try context.save()
        } catch(let error) {
            print(error.localizedDescription)
        }
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
    
//    func delete(variable: VariableModel, completion: ()->() = {}) {
//        guard let objectURI = variable.id else { return }
//        guard let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: objectURI) else { return }
//
//        do {
//            let object = try context.existingObject(with: objectID)
//            context.delete(object)
//            try context.save()
//            completion()
//        } catch(let error) {
//            print(error.localizedDescription)
//        }
//    }
//
    func delete(variable: VariableModel, completion: ()->() = {}) {
             do {
                 context.delete(variable)

                 try context.save()
                 completion()
             } catch(let error) {
                 print(error.localizedDescription)
             }
         }
    
}


