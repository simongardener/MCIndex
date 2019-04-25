//
//  DataModel.swift
//  MCIndex
//
//  Created by Simon Gardener on 30/11/2018.
//  Copyright © 2018 Simon Gardener. All rights reserved.
//

import Foundation
import CoreData

class DataModel {
    
    private let dBName = "DreddIndex2"
    private let sqlType = "sqlite"
    
    
    
    lazy var container: NSPersistentContainer = {
        
        let persistentContainer = NSPersistentContainer(name: "DreddIndex2")
        
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContainer
    }()
    
    func save(){
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error while saving context\(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func resetAllOwnedAndRead (){
        
    }
    
    func installSeedModel (){
        guard let seedSqlURL = Bundle.main.url(forResource: dBName, withExtension: sqlType) else { fatalError("These is no presupplied seed database")}
        let psc = container.persistentStoreCoordinator
        
        let destURLS = psc.url(for: psc.persistentStores.first!)
        do {
            try  psc.replacePersistentStore(at: destURLS, destinationOptions: nil, withPersistentStoreFrom: seedSqlURL, sourceOptions: nil, ofType: NSSQLiteStoreType)
        }catch {
            print("Failed to replace ")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
