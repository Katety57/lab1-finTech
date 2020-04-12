
//
//  ConversationsModel.swift
//  TinkoffChat
//
//  Created by  User on 12.04.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation
import Firebase
import CoreData

//class Channel: NSManagedObject{
//    var name: String?
//    var lastMessage: String?
//    var id: String?
//    var lastActivity: Date?
//}

class ConversationsModel {
    private lazy var db = Firestore.firestore()
    private lazy var ref = db.collection("channels")
    
    lazy var fetchedResultController: NSFetchedResultsController<Channel> = {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Channel")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let context = StorageManager.sharedManager.context
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Channels")
        return frc as! NSFetchedResultsController<Channel>
    }()
    
    func getChannel(tableView: UITableView){
        ref.addSnapshotListener{ [weak self] snapshot, error in
            if let s = snapshot {
                StorageManager.sharedManager.deleteAllData(entity: "Channel")
                for document in s.documents {
                    let activity = document.get("lastActivity") as? Timestamp
                    if let act = activity,
                        let message = document.get("lastMessage") as? String,
                       let name = document.get("name") as? String, let id = document.get("identifier") as? String {
                            if message != "", name != ""{
                            StorageManager.sharedManager.saveContext(dictionary: ["lastActivity" : act.dateValue(),
                                                                              "lastMessage" : message,
                                                                              "name" : name,
                                                                              "id" : id],
                                                                 properties: ["lastActivity", "lastMessage", "name", "id"], entityName: "Channel")
                        }
                    }
                }
                do {
                    try self?.fetchedResultController.performFetch()
                    tableView.reloadData()
                } catch let err {
                    print("Failed to fetch: ",err)
                }
            }
        }
    }
}
