//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/18/18.
//  Copyright © 2018 kiran. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    var messageController: MessageViewController?
    
    //make containerview for inputs
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        //for cornor radius
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    //for button
    let loginRegisterButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 17, g: 10, b: 20)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //add actionss and properties to the button
        button.addTarget(self, action: #selector(handleLoginRegisterButton), for: .touchUpInside)
        return button
    }()
    
    //it will decide whether it is login or register
    @objc func handleLoginRegisterButton(){
        if loginRegisterSegmentedController.selectedSegmentIndex == 0 {
            handleLoginButton()
        }
        else{
            handleRegisterButton()
        }
        
    }
    //for login button in segmentedview and login with existing user pass
    func handleLoginButton(){
        print("loginbutton tapped")
        guard let email = emailTextfield.text,  let password = passwordTextfield.text else {
            print("error")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            self.messageController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //for textfield
    let nameTextfield:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //for seperator below name
    let nameSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 122, g: 122, b: 122)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    let emailTextfield:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    //for seperator
    let emailSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 122, g: 122, b: 122)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let passwordTextfield:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var  profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "man")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectedProfileImageView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    
    let loginRegisterSegmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        //either 0 or 1 . selectedsegmenteIndex
        sc.selectedSegmentIndex = 1
        
        //help in change the toggle between login and register
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    //function for toggle login register
    @objc func handleLoginRegisterChange() {
        //change the title of button according to the segmented toggle
        let title = loginRegisterSegmentedController.titleForSegment(at: loginRegisterSegmentedController.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        //when the selectedindex is 0 which is 1 gives height of 100 othrwiser 150
        inputcontainerViewHeightAnchor?.constant = loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 100 : 150
        //nametextfield height
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/3 );nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3 );emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextfieldHeightAnchor?.isActive = false
        passwordTextfieldHeightAnchor = passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3 );passwordTextfieldHeightAnchor?.isActive = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //this is for bg color for loginviewcontroller , it can be done as below commented code but for more clear code we used extension
        // view.backgroundColor = UIColor(displayP3Red: 11/250, green: 20/250, blue: 33/250, alpha: 1)
        //after extension uicolor
        view.backgroundColor = UIColor(r: 51, g: 61, b: 71)
        view.addSubview(profileImage)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedController)
        setUpProfileImage()
        setupContainerView()
        setupLoginRegisterButton()
        setuploginRegisterSegmentedController()
    }
    //needs x , y , width , height constrains
    func setuploginRegisterSegmentedController() {
        loginRegisterSegmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedController.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedController.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedController.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
    }
    
    //needs x , y , width , height constrains
    func setUpProfileImage(){
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedController.topAnchor, constant: -12).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    //this is for adjusting the height of inputcontainerview when toggle
    var inputcontainerViewHeightAnchor: NSLayoutConstraint?
    //for adjusting the textfield which will be only two at login
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    //same as above for height constrains for emaila and password
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextfieldHeightAnchor: NSLayoutConstraint?
    //add constrains for inputcontainerView
    func setupContainerView(){
        //needs x , y , width , height constrains
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // -24 means padding 12 on both sides
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputcontainerViewHeightAnchor =  inputsContainerView.heightAnchor.constraint(equalToConstant: 150);inputcontainerViewHeightAnchor?.isActive = true
        //textfield should be inside the inputcontainerview so
        inputsContainerView.addSubview(nameTextfield)
        inputsContainerView.addSubview(nameSeperator)
        inputsContainerView.addSubview(emailTextfield)
        inputsContainerView.addSubview(emailSeperator)
        inputsContainerView.addSubview(passwordTextfield)
        //add constraints for textfield
        //needs x , y , width , height constrains
        nameTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextfield.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        //making nametextfield height refrence
        nameTextFieldHeightAnchor = nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3);nameTextFieldHeightAnchor?.isActive = true
        
        //add seperator inside inputconatainerview
        nameSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeperator.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //needs x , y , width , height constrains
        emailTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextfield.topAnchor.constraint(equalTo: nameSeperator.bottomAnchor).isActive = true
        emailTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor =
            emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3); emailTextFieldHeightAnchor?.isActive = true
        
        //add seperator inside inputconatainerview
        emailSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeperator.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //needs x , y , width , height constrains
        passwordTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextfield.topAnchor.constraint(equalTo: emailSeperator.bottomAnchor).isActive = true
        passwordTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextfieldHeightAnchor =
            passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3);passwordTextfieldHeightAnchor?.isActive = true
        
    }
    
    //constrains for button
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //y constrains on the basic of above viewcontaiiner which is innputscontainer view
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 15).isActive = true
        //takes equal width as inputscontainer view
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    //this is for statusbarstyle at the top of the vc .. otherwise the time wifi icon are dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//extension should be outside the class .
//this is for color
extension UIColor {
    
    convenience  init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: b/255,  blue: g/255, alpha: 1)
    }
    
}




