//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by  User on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

private let reuseIdentifier: String = "conversationCell"

class ConversationsListViewController: UITableViewController {
    
    var selectedConversation: Channel?
    var conversationDestination: ConversationViewController?
    var conversationsModel = ConversationsModel()
}

// MARK - UITableViewdelegate, datasource

extension ConversationsListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return conversationsModel.fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = conversationsModel.fetchedResultController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DialogTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? DialogTableViewCell else { return UITableViewCell()}
        let channel = conversationsModel.fetchedResultController.object(at: indexPath) as Channel
                
        cell.nameLabel.text = channel.name
        cell.messageLabel.text = channel.lastMessage
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let activity = channel.lastActivity {
            cell.dateLabel.text = formatter.string(from: activity)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedConversation = conversationsModel.fetchedResultController.object(at: indexPath)
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
            conversationDestination?.conversationModel.selectedConversation = selectedConversation
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConversation" {
            conversationDestination = segue.destination as? ConversationViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationsModel.getChannel(tableView: tableView)
    }
}

