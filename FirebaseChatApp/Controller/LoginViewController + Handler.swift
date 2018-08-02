//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/18/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
import Firebase

//extension of class LoginViewController
extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    func handleRegisterButton() {
        guard let email = emailTextfield.text, let password = passwordTextfield.text, let name = nameTextfield.text else {
            print("Error")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                // print("Error")
                return
            }
            // MARK: - hadleLogin//
            guard let uid = Auth.auth().currentUser?.uid  else {
                return
            }
            // MARK: - image successful authenficated user
            let imageName = NSUUID().uuidString //converts the imagename
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let _ = self.profileImage.image,  let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1) { // 0.1 image compression ranges from 0.0 to 1.0
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil, metadata != nil {
                        print(error ?? "")
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        if let profileImageUrl = url?.absoluteString {
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            self.registeUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    })
                })
            }
        }
    }
    //....save data in database
    private func registeUserIntoDatabaseWithUID(uid: String, values:[String: AnyObject]){
        //for unique user id
        var ref: DatabaseReference!
        ref = Database.database().reference()
        //adds new user and its data
        let userRefrence = ref.child("users").child(uid)
        userRefrence.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            else{
                //fetch data from fetchuserandsetupnavbartitle functio which is in MessageViewController
                self.messageController?.navigationItem.title = values["name"] as? String
                self.dismiss(animated: true, completion: nil)
                print("data successivefully saved")
            }
        }
    }
    
    
    //this is for picking image and selected as profile image
    @objc func handleSelectedProfileImageView(){
        print("image tapped ")
        let imagerPicker = UIImagePickerController()
        imagerPicker.delegate = self
        imagerPicker.allowsEditing = true
        present(imagerPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info\(info)")
        var  selectedImagefromPicker: UIImage?
        if let editedImage = info ["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImagefromPicker = editedImage
            
        }
        else   if let originalImage = info ["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImagefromPicker = originalImage
        }
        
        if let selectedImage = selectedImagefromPicker{
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picking activity is cancled")
        dismiss(animated: true, completion: nil)
    }
    
}
