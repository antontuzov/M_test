//
//  SignUpAddImageVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/5/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class SignUpAddImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var selectedImage: UIImage?
    var email: String?
    var password: String?
    var name: String?
    var uid: String?
    
    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var addButton: ButtonVC!
    @IBOutlet weak var continueButton: ButtonVC!
    @IBOutlet weak var animationView: AnimationView!
    
    func animation(_ status: Bool){
        animationView.isHidden = !status
        addButton.isEnabled = !status
        continueButton.isEnabled = !status
        if status {
            animationView.animation = Animation.named("loading")
            animationView.loopMode = .loop
            animationView.play()
        }else{
            animationView.stop()
        }
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        if let userImage = selectedImage {
            profileImage.image = userImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        animation(true)
        if selectedImage == nil {
            selectedImage = UIImage(named: "UserDefaultIcon")
        }
        let uniqueName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Images").child("\(uniqueName).jpg")
        if let uploadData = self.selectedImage?.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let url = url else {
                        print("Error downloading image(url is nil)")
                        return
                    }
                    let values: [String : Any] = ["name": self.name!, "email": self.email!, "profileImage": url.absoluteString]
                    self.registerUserHandler(uid: self.uid!, values: values)
                }
            }
            self.animation(true)
        }
    }
    
    func registerUserHandler(uid: String, values: [String: Any]){
        
        let usersReference = Database.database().reference().child("users").child(uid)
        
        usersReference.updateChildValues(values) { (error, reference) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            print("Saved user successfully into Firebase Db")
            self.performSegue(withIdentifier: Constants.Storyboard.controllersTabBar, sender: nil)
        }
    }
    
}
