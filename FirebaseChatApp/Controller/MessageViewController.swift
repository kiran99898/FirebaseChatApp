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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add tapGestureReconizer in navigationBarTitle
        //        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(showChatController))
        //        self.navigationController?.navigationBar.addGestureRecognizer(tapGestureReconizer)
        let msgImage = UIImage(named: "msg")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: msgImage, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        observeMessages()
    }
    
    var messages = [Message]()
    //...   OBSERVE MESSAGE FROM DATABASE
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            let message = Message()
            let value = snapshot.value as? NSDictionary
            message.text = value?["text"] as? String ?? ""
            message.toId = value?["toId"] as? String ?? ""
            self.messages.append(message)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(message.text!)
        }, withCancel: nil)
    }
    
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let message = messages[indexPath.row]
        cell.detailTextLabel?.text =  message.text
        cell.textLabel?.text = message.toId
        return cell
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
            }
            
        }, withCancel: nil)
    }
    
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


