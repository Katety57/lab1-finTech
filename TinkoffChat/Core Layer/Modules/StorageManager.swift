//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by  User on 29.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - Core Data Persistent Manager

protocol StorageProtocol {
    func saveContext (dictionary: Dictionary<String, Any>, properties: Array<String>, entityName: String)
    func readContext (entityName: String) -> [NSManagedObject]
}

final class StorageManager: StorageProtocol {
    static let sharedManager = StorageManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext(dictionary: Dictionary<String, Any>, properties: Array<String>, entityName: String) {
            if let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) {
                let e = NSManagedObject(entity: entity, insertInto: context)
                for p in properties {
                    e.setValue(dictionary[p], forKey: p)
                }
                do {
                    try context.save()
                } catch (let error) {
                    print("Not saved. \(error)")
                }
            }
    }
    
    func readContext(entityName: String) -> [NSManagedObject] {
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: entityName)
        var elems: Array<NSManagedObject> = []
        
        do {
          let entity = try context.fetch(fetchRequest)
          elems = entity
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return elems
    }
    
    func deleteAllData(entity: String)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
