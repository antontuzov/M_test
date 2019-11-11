//
//  SignUpVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/3/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var signUpButton: ButtonVC!
    @IBOutlet weak var passwordTextField: TextFieldVC!
    @IBOutlet weak var emailTextField: TextFieldVC!
    @IBOutlet weak var nameTextField: TextFieldVC!
    @IBOutlet weak var lastNameTextField: TextFieldVC!
    @IBOutlet weak var backButton: ButtonVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)  
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        handleRegister()
    }
    
    func validate() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "", lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.count < 2 {
            return "First name should be more than 2 characters long."
        }else if lastName.count < 2 {
            return "Last name should be more than 2 characters long."
        }else if (lastName + name).count > 30 {
            return "Your name should not be more than 15 characters long."
        }

        if password.count < 6 {
            return "Password should be at least 6 characters long"
        }
        
        return nil
    }
    
    func handleRegister(){
        let textFieldError = validate()
        if textFieldError != nil {
            showAlert(title: "Error happened!", message: textFieldError)
        }else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fullName = "\(name) \(lastName)"
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.showAlert(title: "Error happened!", message: error.localizedDescription)
                return
            }
            guard let uid = result?.user.uid else {
                return
            }
                self.nextController(email: email, password: password, name: fullName, uid: uid)
            }
        }
        
    }
    
    // This method gets triggered when the auth was successful
    
    func nextController(email: String, password: String, name: String, uid: String){
        let controller = storyboard?.instantiateViewController(identifier: "SignUpAddImageVC") as! SignUpAddImageVC
        controller.email = email
        controller.password = password
        controller.name = name
        controller.uid = uid
        show(controller, sender: nil)
    }
    
    
}
