//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/18/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UITableViewController {
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        //add tapGestureReconizer in navigationBarTitle
        //        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(showChatController))
        //        self.navigationController?.navigationBar.addGestureRecognizer(tapGestureReconizer)
        let msgImage = UIImage(named: "msg")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: msgImage, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        // observeMessages()
        //register custom cell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    var messages = [Message]()
    //grouping the message
    var messageDictionary = [String: Message]()
    //...   OBSERVE MESSAGE FROM DATABASE
    //observe message from user-messsage
    func observeUserMessage(){
        guard let uid = Auth.auth().currentUser?.uid
            else {
                return
        }
        //grabs the uid from user-messages
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            //grabs value from messageRefrance with the help of messageid which is snapshotkey
            let messageId = snapshot.key
            let messageRefrence = Database.database().reference().child("messages").child(messageId)
            messageRefrence.observeSingleEvent(of: .value, with: { (snapshot) in
                if  let value = snapshot.value as? [String: Any] {
                    let message = Message()
                    message.setValuesForKeys(value)
                    //      self.messages.append(message)
                    //grouping the message
                    if let toId = message.toId  {
                        self.messageDictionary[toId] = message
                        self.messages = Array(self.messageDictionary.values)
                        //sorting the message from latest first to so on
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1.timeStamp.intValue > message2.timeStamp.intValue
                        })
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
    }
    
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if  let value = snapshot.value as? [String: Any] {
                let message = Message()
                message.setValuesForKeys(value)
                //      self.messages.append(message)
                //grouping the message
                if let toId = message.toId  {
                    self.messageDictionary[toId] = message
                    self.messages = Array(self.messageDictionary.values)
                    //sorting the message from latest first to so on 
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.timeStamp.intValue > message2.timeStamp.intValue
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        //cell = customcell used Usercell 
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    
    @objc func showChatControllerForUser(user: User){
        let chatLogController = ChatlogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    
    @objc func handleNewMessage(){
        //when clock to handlenewmessage selector ie right navigation item . it presents newmessagetable view controller with navigarin bar
        let newMessageController = NewMessageTableViewController()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    //check if the user is logged in
    func checkIfUserIsLoggedIn (){
        //this is for logout code ,id uuser is not signed in
        if Auth.auth().currentUser?.uid == nil { perform(#selector(handleLogout), with: nil, afterDelay: 0)
            print("usernot logged in ")
        }
        else {
            fetchUserAndSetupNavBarTitle()
            
        }
    }
    //fetch uers and set navbar title
    func fetchUserAndSetupNavBarTitle () {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
            //fetch values to view
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.navigationItem.title = dictionary["name"] as? String
                
                //updates table
                self.messages.removeAll()
                self.messageDictionary.removeAll()
                self.tableView.reloadData()
                self.observeUserMessage()
                
            }
            
        }, withCancel: nil)
    }
    
    //    func setupNavBarWithUser(user: User){
    //
    //    }
    
    @objc func handleLogout(){
        //if user if logout , it will stay logout
        do {
            print("no user logged in ")
            try Auth.auth().signOut()
        }
        catch let logouterror{
            print(logouterror)
            
        }
        
        //when click it goes to the loginViewController
        let loginController = LoginViewController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
        
    }
    
}


