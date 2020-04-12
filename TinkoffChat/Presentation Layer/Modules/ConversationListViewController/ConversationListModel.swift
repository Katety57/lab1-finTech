//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by  User on 12.04.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation
import Firebase
import CoreData

//class Message: NSManagedObject{
//    var senderName: String?
//    var senderID: String?
//    var content: String?
//    var created: Date?
//}

class ConversationModel {
    var selectedConversation: Channel?
    private lazy var db = Firestore.firestore()
    
    private lazy var reference: CollectionReference = {
        guard let channelIdentifier = self.selectedConversation?.id else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    
    lazy var fetchedResultController: NSFetchedResultsController<Message> = {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let context = StorageManager.sharedManager.context
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Messages")
        return frc as! NSFetchedResultsController<Message>
    }()
    
    func getMessages(tableView: UITableView){
        reference.addSnapshotListener{[weak self] snapshot, error in
            if let s = snapshot {
                StorageManager.sharedManager.deleteAllData(entity: "Message")
                for document in s.documents {
                    let activity = document.get("created") as? Timestamp
                    if let act = activity,
                        let message = document.get("content") as? String,
                        let name = document.get("senderName") as? String, let id = document.get("senderID") as? String {
                        if message != "", name != ""{
                            StorageManager.sharedManager.saveContext(dictionary: ["created" : act.dateValue(),
                                                                              "content" : message,
                                                                              "senderName" : name,
                                                                              "senderID" : id],
                                                                 properties: ["created", "content", "senderName", "senderID"], entityName: "Message")
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
