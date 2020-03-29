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
    func saveContext (username: String, bio: String, img: Data)
    func readContext () -> NSManagedObject?
}

final class StorageManager: StorageProtocol {
    static let sharedManager = StorageManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext(username: String, bio: String, img: Data) {
        deleteAllData(entity: "User")
            if let user = NSEntityDescription.entity(forEntityName: "User", in: context) {
                let usr = NSManagedObject(entity: user, insertInto: context)
                usr.setValue(username, forKey: "name")
                usr.setValue(bio, forKey: "bio")
                usr.setValue(img, forKey: "img")
                do {
                    try context.save()
                } catch (let error) {
                    print("Not saved. \(error)")
                }
            }
    }
    
    func readContext() -> NSManagedObject? {
        var usr: NSManagedObject?
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
          let user = try context.fetch(fetchRequest)
            for u in user {
                usr = u
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        return usr
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
