//
//  AppCoreDataContext.swift
//  Desafio Phrases
//
//  Created by Luciano Almeida on 2/13/16.
//  Copyright © 2016 Luciano Almeida. All rights reserved.
//

import UIKit
import CoreData
class AppCoreDataContext: NSObject {
    var persistenceCoordinator: NSPersistentStoreCoordinator!
    var managedObjectModel: NSManagedObjectModel!
    var managedContext: NSManagedObjectContext!
    
    private static var context : AppCoreDataContext? = nil
    
    private override init() {
        super.init()
        self.createContext()
    }
    
    class func sharedContext() -> AppCoreDataContext{
        if self.context == nil {
            self.context = AppCoreDataContext()
        }
        return self.context!
    }
    
    
    
    private func createContext(){
        
        if let model = NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("PhrasesModel", withExtension: "momd")!){
            self.managedObjectModel = model
            self.persistenceCoordinator = NSPersistentStoreCoordinator(managedObjectModel:model)
            let storeUrl = self.documentDirectoryURL().URLByAppendingPathExtension("phrases.sqlite")
            self.managedContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            do{
                try self.persistenceCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil)
                managedContext.persistentStoreCoordinator = self.persistenceCoordinator
            }catch {
            }
        }
    }
    
    private func documentDirectoryURL()-> NSURL {
        let url = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        
        return NSURL(string:"file://\(url)")!
    }

}
