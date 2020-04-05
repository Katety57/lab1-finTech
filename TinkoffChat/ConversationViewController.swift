//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by  User on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit
import Firebase
import CoreData

//class Message: NSManagedObject{
//    var senderName: String?
//    var senderID: String?
//    var content: String?
//    var created: Date?
//}

class ConversationViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    
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
}

extension ConversationViewController {
    override func loadView() {
        super.loadView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedConversation?.name
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setupTableView() {
      view.addSubview(tableView)
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultController.sections?.count ?? 0
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let count = fetchedResultController.sections?[section].numberOfObjects {
//            return count
//        }
//        return 0
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)

//        let message = fetchedResultController.object(at: indexPath) as Message
        cell.textLabel?.text = "Test"

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getMessages()
    }
    
    func getMessages(){
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
//                        self?.tableView.reloadData()
                    } catch let err {
                        print("Failed to fetch: ",err)
                }
            }
        }
    }
    // MARK: - Table view data source

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
