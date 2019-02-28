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
    
    private let dBName = "DreddIndex"
    private let sqlType = "sqlite"
 
    
    
    lazy var container: NSPersistentContainer = {
       
        let persistentContainer = NSPersistentContainer(name: "DreddIndex")
       
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("container : \(persistentContainer)")

        return persistentContainer
    }()
    
    
     func installSeedModel (){
      //  guard let sqlPath = Bundle.main.path(forResource: dBName, ofType: sqlType)else { fatalError("These is no presupplied seed database")}
      
        guard let seedSqlURL = Bundle.main.url(forResource: dBName, withExtension: sqlType) else { fatalError("These is no presupplied seed database")}
        print("seedSQLURL\(seedSqlURL)")
        let psc = container.persistentStoreCoordinator
        
        let destURLS = psc.url(for: psc.persistentStores.first!)
        print("destURL\(destURLS)")
   //     let sqlDestintationURL = psc.url(for: psc.per )
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
