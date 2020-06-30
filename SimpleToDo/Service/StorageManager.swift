//
//  StorageManager.swift
//  SimpleToDo
//
//  Created by Pavel Parshin on 30.06.2020.
//  Copyright © 2020 Pavel Parshin. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SimpleToDo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
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
    
    // MARK: - Work witch Core Data
    func fetchData() -> [Task] {
        var tasks: [Task] = []
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return tasks
    }
    
    func save(_ taskName: String) -> Task? {
        guard let entityDescription = NSEntityDescription
            .entity(forEntityName: "Task", in: persistentContainer.viewContext) else { return nil }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? Task else { return nil }
        
        task.name = taskName
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
        
        return task
    }
    
    func edit(task: Task) {
        persistentContainer.viewContext.refresh(task, mergeChanges: true)
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(task: Task) {
        persistentContainer.viewContext.delete(task)
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
