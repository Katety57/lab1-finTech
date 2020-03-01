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
    
    struct ConversationCell {
        let name: String
        let message: String
        let date: Date
        let isOnline: Bool
        let hasUnreadMessage: Bool
    }
    
    var array: [[ConversationCell]] = [
        [ConversationCell(name: "Ari", message: "Hello", date: Date(), isOnline: true, hasUnreadMessage: true),
         ConversationCell(name: "Charlie", message: "We don't talk anymore", date: Date.init(timeIntervalSinceNow: -86400), isOnline: true, hasUnreadMessage: false),
         ConversationCell(name: "Ed", message: "I don't care", date: Date.init(timeIntervalSinceReferenceDate: 86400), isOnline: true, hasUnreadMessage: true),
         ConversationCell(name: "Justin", message: "", date: Date.init(timeIntervalSinceReferenceDate: 100000), isOnline: true, hasUnreadMessage: false),
         ConversationCell(name: "Camila", message: "Morning", date: Date.init(timeIntervalSinceNow: -100000), isOnline: true, hasUnreadMessage: true),
         ConversationCell(name: "Cardi", message: "South of the border", date: Date.init(timeIntervalSinceNow: -400), isOnline: true, hasUnreadMessage: false),
         ConversationCell(name: "Shawn", message: "There is nothing holding me back", date: Date.init(timeIntervalSinceNow: -6400), isOnline: true, hasUnreadMessage: false),
         ConversationCell(name: "Lauv", message: "Feelings", date: Date(), isOnline: true, hasUnreadMessage: true),
         ConversationCell(name: "Sam", message: "Dancing with a stranger", date: Date(), isOnline: true, hasUnreadMessage: true),
         ConversationCell(name: "Nicki", message: "", date: Date.init(timeIntervalSinceReferenceDate: 700000), isOnline: true, hasUnreadMessage: false)],
        
        [ConversationCell(name: "Ari", message: "Hello", date: Date(), isOnline: false, hasUnreadMessage: true),
        ConversationCell(name: "Charlie", message: "We don't talk anymore", date: Date.init(timeIntervalSinceNow: -86400), isOnline: false, hasUnreadMessage: false),
        ConversationCell(name: "Ed", message: "I don't care", date: Date.init(timeIntervalSinceReferenceDate: 86400), isOnline: false, hasUnreadMessage: true),
        ConversationCell(name: "Justin", message: "", date: Date.init(timeIntervalSinceReferenceDate: 100000), isOnline: false, hasUnreadMessage: false),
        ConversationCell(name: "Camila", message: "Morning", date: Date.init(timeIntervalSinceNow: -100000), isOnline: false, hasUnreadMessage: true),
        ConversationCell(name: "Cardi", message: "South of the border", date: Date.init(timeIntervalSinceNow: -400), isOnline: false, hasUnreadMessage: false),
        ConversationCell(name: "Shawn", message: "There is nothing holding me back", date: Date.init(timeIntervalSinceNow: -6400), isOnline: false, hasUnreadMessage: false),
        ConversationCell(name: "Lauv", message: "Feelings", date: Date(), isOnline: false, hasUnreadMessage: true),
        ConversationCell(name: "Sam", message: "Dancing with a stranger", date: Date(), isOnline: false, hasUnreadMessage: true),
        ConversationCell(name: "Nicki", message: "", date: Date.init(timeIntervalSinceReferenceDate: 700000), isOnline: false, hasUnreadMessage: false)]
    ]
    var selectedConversation: ConversationCell?
    
}

// MARK - UITableViewdelegate, datasource

extension ConversationsListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func divTwo(cell: ConversationCell){
        cell.isOnline ? array[0].append(cell) : array[1].append(cell)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DialogTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? DialogTableViewCell else { return UITableViewCell()}
        
        cell.backgroundColor = array[indexPath.section][indexPath.row].isOnline ? UIColor(red: 1, green: 0.9882, blue: 0.749, alpha: 1.0) : UIColor.white
        
        cell.nameLabel.text = array[indexPath.section][indexPath.row].name
        cell.messageLabel.text = array[indexPath.section][indexPath.row].message.isEmpty ? "No message yet" : array[indexPath.section][indexPath.row].message
        
        array[indexPath.section][indexPath.row].hasUnreadMessage ? cell.messageLabel.font = UIFont.boldSystemFont(ofSize: 18.0) : cell.noMsg(flag: array[indexPath.section][indexPath.row].isOnline)
        
        
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "EST") {
            calendar.timeZone = timeZone
        }
        let hour = calendar.component(.hour, from: array[indexPath.section][indexPath.row].date)
        let minute = calendar.component(.minute, from: array[indexPath.section][indexPath.row].date)
        cell.dateLabel.text = "\(hour):\(minute)"
        
        //cell.onlineLabel.text = array[indexPath.row].isOnline ? "Online" : "Offline"
//        cell.textLabel?.text = "Cell Text"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online" : "History"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedConversation = array[indexPath.section][indexPath.row]
        //performSegue(withIdentifier: "showConversation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "showConversation" {
            let conversation = segue.destination as! ConversationViewController
            if let text = selectedConversation{
                conversation.selectedConversation = text
            }
        }*/
    }
}
