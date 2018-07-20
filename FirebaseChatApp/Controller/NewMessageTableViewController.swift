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
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            user.profileImageUrl = (snapshot.value as? NSDictionary)?["profileImageUrl"] as? String ??  ""
            self.users.append(user)
            DispatchQueue.global().async(execute: {
                print("error")
                DispatchQueue.main.sync{
                    self.tableView.reloadData()
                }
            })
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
        let  profileImageUrl = user.profileImageUrl
        let url = URL(string: profileImageUrl!)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                cell.profileImageView.image = UIImage(data: data!)
            }
            }.resume()
        return cell
    }
    
}
//  .......CUSTOM CELL
class UserCell:UITableViewCell {
    //For Cell Subviews  Custom Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(origin: CGPoint(x: 100, y: textLabel!.frame.origin.y - 2),  size: CGSize(width: textLabel!.frame.width, height: textLabel!.frame.height))
        detailTextLabel?.frame = CGRect(origin: CGPoint(x: 100, y: detailTextLabel!.frame.origin.y + 2),  size: CGSize(width: detailTextLabel!.frame.width, height: textLabel!.frame.height))
    }
    //imageview custom layout
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "msg")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        //add constraint anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

