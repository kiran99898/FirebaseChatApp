//
//  Message.swift
//  FirebaseChatApp
//
//  Created by kiran on 8/1/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit

class Message: NSObject {
    @objc var fromId: String = ""
    @objc  var timeStamp: NSNumber = 0
    @objc var text: String = ""
    @objc var toId: String?
    
}
