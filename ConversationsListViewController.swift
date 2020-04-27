//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by  User on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit
import Firebase
import CoreData

private let reuseIdentifier: String = "conversationCell"

//class Channel: NSManagedObject{
//    var name: String?
//    var lastMessage: String?
//    var id: String?
//    var lastActivity: Date?
//}

class ConversationsListViewController: UITableViewController {
    
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
    
    var selectedConversation: Channel?
    var conversationDestination: ConversationViewController?
}

// MARK - UITableViewdelegate, datasource

extension ConversationsListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DialogTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? DialogTableViewCell else { return UITableViewCell()}
        let channel = fetchedResultController.object(at: indexPath) as Channel
        
//        cell.backgroundColor = array[indexPath.section][indexPath.row].isOnline ? UIColor(red: 1, green: 0.9882, blue: 0.749, alpha: 1.0) : UIColor.white
        
        cell.nameLabel.text = channel.name
//        print("SECOND:   ",channels[indexPath.row].value(forKey: "name"))
        cell.messageLabel.text = channel.lastMessage
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let activity = channel.lastActivity {
            cell.dateLabel.text = formatter.string(from: activity)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedConversation = fetchedResultController.object(at: indexPath)
        performSegue(withIdentifier: "showConversation", sender: nil)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let channel = fetchedResultController.object(at: indexPath)
//            StorageManager.sharedManager.context.delete(channel)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
//        }
//    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "showConversation" {
            conversationDestination?.selectedConversation = selectedConversation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConversation" {
            conversationDestination = segue.destination as? ConversationViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChannel()
    }
    
    func getChannel(){
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
                    self?.tableView.reloadData()
                } catch let err {
                    print("Failed to fetch: ",err)
                }
            }
        }
    }
}

