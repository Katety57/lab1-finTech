//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by  User on 06.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject{
    var name: String?
    var bio: String?
    var img: URL?
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textDescript: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioEditField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var usernameIsChanged: Bool = false
    var bioIsChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius =  cameraButton.frame.width/2.0
        
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2.0
        
        textDescript.textColor = UIColor.gray

        frameBtn(btnName: editButton)
        
        profileView()
        
        usernameTextField.isHidden = true
        bioEditField.isHidden = true
        bioEditField.delegate = self
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
    }
    
    func frameBtn(btnName: UIButton) {
        btnName.layer.borderWidth = 2
        btnName.layer.borderColor = UIColor.black.cgColor
        btnName.layer.cornerRadius = 10
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = false
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.contentMode = .scaleAspectFill
            profileImg.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseImg(_ sender: Any) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.camera()}))
        ac.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.photoLibrary()}))
        present(ac, animated: true, completion: nil)
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    }
    
    @IBAction func editProfile(_ sender: Any) {
        editorView()
    }
    
    // MARK: - Navigation
    
    func getFileURL(file: String) -> URL?{
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            return fileURL
        }
        return nil
    }
    
    func profileView() {
        editButton.isHidden = false
        usernameTextField.isHidden = true
        bioEditField.isHidden = true
        username.isHidden = false
        textDescript.isHidden = false
        usernameIsChanged = false
        bioIsChanged = false
        saveButton.isHidden = true
        cameraButton.isHidden = true
        let usr = StorageManager.sharedManager.readContext()
        username.text = usr?.value(forKey: "name") as? String
        textDescript.text = usr?.value(forKey: "bio") as? String
        profileImg.image = UIImage(data: usr?.value(forKey: "img") as! Data)
    }
    
    func editorView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        textDescript.isHidden = true
        username.isHidden = true
        editButton.isHidden = true
        cameraButton.isHidden = false
        usernameTextField.isHidden = false
        usernameTextField.text = ""
        bioEditField.isHidden = false
        bioEditField.text = ""
        saveButton.isHidden = false
        saveButton.isEnabled = false
        bioEditField.layer.borderWidth = 0.5
        bioEditField.layer.borderColor = UIColor.lightGray.cgColor
        bioEditField.layer.cornerRadius = 5
        
        frameBtn(btnName: saveButton)
    }
    
    @IBAction func saveData(_ sender: Any) {
        guard let usernameField = usernameTextField.text else { return }
        guard let bio = bioEditField.text else {return }
        guard let img = profileImg.image?.pngData() else { return }
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            do{
                if !usernameField.isEmpty && !bio.isEmpty {
                    StorageManager.sharedManager.saveContext(username: usernameField, bio: bio, img: img)
                }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if usernameField.isEmpty || bio.isEmpty {
                        let alertController = UIAlertController(title: "Error", message: "Failed to save data", preferredStyle: .alert)
                       
                        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.editorView()}))
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "Success", message: "Data saved", preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        }))

                        self.present(alertController, animated: true, completion: nil)
                    }
                    self.profileView()
                    if !usernameField.isEmpty && !bio.isEmpty {
                        self.profileView()
                    }
                    self.activityIndicator.stopAnimating()
                    self.usernameIsChanged = false
                    self.bioIsChanged = false
                    }
                }
            }
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        if self.usernameTextField.text != self.username.text {
            usernameIsChanged = true
        }
        if usernameIsChanged && bioIsChanged {
            saveButton.isEnabled = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if bioEditField.text != textDescript.text {
            bioIsChanged = true
        }
        if usernameIsChanged && bioIsChanged {
            saveButton.isEnabled = true
        }
    }
}
