//
//  MessagesVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/6/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class MessagesVC: UIViewController, UITextFieldDelegate {
    
    // User outlets
    
    var friendPhoto: String!
    var friendName: String!
    var friendId: String!
    var friendEmail: String!
    
    // Message Outlets
    var messages: [Message] = []
        
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var photoLibrary: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    // Navigation Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatNavigation: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        messageTextfield.delegate = self
        tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
        getMessagesHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        // TODO: Add info about the user.
        print("Hi")
        
    }
    @IBAction func sendButtonPressed(_ sender: Any) {
        if self.messageTextfield.text?.count == 0 { return }
        if let message = messageTextfield.text, let sender = Auth.auth().currentUser?.uid {
            sendMessagesHandler(message, sender)
        }
    }
    
    func sendMessagesHandler(_ message: String,_ sender: String){
        // TODO: Add the person who will recieve this.
        guard let friendId = friendId else { return }
        let values = ["message":message, "sender": sender, "date": Date().timeIntervalSince1970, "friend": friendId] as [String : Any]
        let reference = Constants.FirebaseDB.db.reference().child("messages")
        let ref = reference.childByAutoId()
        ref.updateChildValues(values)
        messageTextfield.text = ""
    }
    
    func getMessagesHandler(){
        
        let reference = Constants.FirebaseDB.db.reference().child("messages")
        reference.observe(.childAdded) { (snapshot) in
            guard let values = snapshot.value as? [String: AnyObject] else { return }
            var message = Message()
            message.message = values["message"] as? String
            message.sender = values["sender"] as? String
            message.time = values["date"] as? NSNumber
            message.friend = values["friend"] as? String
            DispatchQueue.main.async {
                self.messages.append(message)
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    @IBAction func photoLibraryPressed(_ sender: Any) {
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.messageTextfield.text?.count == 0 { return false }
        if let message = messageTextfield.text, let sender = Auth.auth().currentUser?.uid {
            sendMessagesHandler(message, sender)
        }
        return true
    }
    
    
}
extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.message
        if messages.count > 0 {
            let date = NSDate(timeIntervalSince1970: message.time.doubleValue)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.timeLabel.text = dateFormatter.string(from: date as Date)
            cell.userImage.loadImageCacheWithUrlString(imageUrl: CurrentUserInformation.profileImage)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
