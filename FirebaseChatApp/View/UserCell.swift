//
//  UserCell.swift
//  FirebaseChatApp
//
//  Created by kiran on 8/1/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
import Firebase

//  .......CUSTOM CELL
class UserCell:UITableViewCell {
    var message: Message? {
        didSet{
            if let toId = message?.toId {
                let ref = Database.database().reference().child("users").child(toId)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        self.textLabel?.text = value ["name"] as? String
                        if let profileImageUrl = value["profileImageUrl"] as? String {
                        self.profileImageView.loadImageWithCacheWithUrlString(urlString: profileImageUrl)
                        }
                    }
                    
                }, withCancel: nil)
            }
           detailTextLabel?.text =  message?.text
            if let seconds = message?.timeStamp.doubleValue {
                let timeStampDate = NSDate(timeIntervalSinceReferenceDate: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss: a"
                timeLable.text = dateFormatter.string(for: timeStampDate)

            }
//            timeLable.text = message?.timeStamp.stringValue
        }
    }
    
    
    //For Cell Subviews  Custom Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(origin: CGPoint(x: 100, y: textLabel!.frame.origin.y - 2),  size: CGSize(width: textLabel!.frame.width , height: textLabel!.frame.height))
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
    let timeLable: UILabel = {
        let label = UILabel()
      //  label.text = "hh:mm:ss"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLable)
        //add constraint anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        //constraints for timelabel
        timeLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLable.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}

}
