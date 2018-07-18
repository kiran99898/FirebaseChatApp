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
        let msgImage = UIImage(named: "msg")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: msgImage, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
    }
    
    
    @objc func handleNewMessage(){
        //when clock to handlenewmessage selector ie right navigation item . it presents newmessagetable view controller with navigarin bar
        let newMessageController = NewMessageTableViewController()
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
            //grabs uid values. ie individual
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                
                //fetch values to view
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            }, withCancel: nil)
            
        }
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
        present(loginController, animated: true, completion: nil)
        
    }
    
    
    
    
}


