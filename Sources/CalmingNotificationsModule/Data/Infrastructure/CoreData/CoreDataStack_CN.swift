//
//  CoreDataStack_CN.swift
//  CalmingNotifications
//
//  Created by Maxim on 08.02.2022.
//  Copyright © 2022 Max. All rights reserved.
//

import CoreData


final class CoreDataStack_CN {
    
    // MARK: - Static

    static var shared = CoreDataStack_CN()
    
    
    // MARK: - Init
    
    private init() {}
  
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
          let container = NSPersistentCloudKitContainer(name: "CalmingNotifications")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()

    
      // MARK: - Core Data Saving support

      func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }
    
}
