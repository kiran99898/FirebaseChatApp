//
//  ChatlogController.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/26/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
import Firebase

class ChatlogController: UICollectionViewController {
    var user: User? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    // textfield refrence . it should be accessable
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        setupInputComponent()
        collectionView?.backgroundColor = UIColor.white
    }
    //input textfield container
    func setupInputComponent(){
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // add constraints
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //send button
        let sendButton = UIButton (type: .system) // type . system makes more interractive
        sendButton.setTitle("send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //add constraints for send button
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        
        //textfield
        containerView.addSubview(inputTextField)
        
        //textfield constraints
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //seperator
        let seperator = UIView()
        seperator.backgroundColor = UIColor.gray
        seperator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperator)
        
        //constraints
        seperator.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

    }
    
    @objc func handleSendButton()  {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp =  NSDate().timeIntervalSince1970
        let values = ["text": inputTextField.text!, "toId": toId, "FromId": fromId, "TimeStamp": timeStamp] as [String : Any]
        //childRef.updateChildValues(values)
// creates new child user-message
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            // refrence from sender or fromId
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            //refrence for recipient ie toid
            let recipientMessageRef = Database.database().reference().child("user-messages").child(toId)
            recipientMessageRef.updateChildValues([messageId: 1])
        }
        

    }
    

}
