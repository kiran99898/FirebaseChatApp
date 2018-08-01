//
//  NewMessageTableViewController.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/18/18.
//  Copyright © 2018 kiran. All rights reserved.
//
import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {

    //this is cell identifier
    let cellId = "cellId"
    //user array takes refrences from User.swift where its properties are decleared
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    // fetching data from database
    func fetchUser(){
        Database.database().reference().child("users").queryOrderedByKey().observe(DataEventType.childAdded) { (snapshot) in
            if !snapshot.exists(){
                print("cant get value from snapshot")
                return
            }
            //parsing snapshot values
            let user = User()
            user.id = snapshot.key
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            user.profileImageUrl = (snapshot.value as? NSDictionary)?["profileImageUrl"] as? String ??  ""
            self.users.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            //IMAGES AFTER CACHING LOADS
          cell.profileImageView.loadImageWithCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    var messageController: MessageViewController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        print("dissmiss complete")
        let user = self.users[indexPath.row]
        self.messageController?.showChatControllerForUser(user: user)
    }
    
}

