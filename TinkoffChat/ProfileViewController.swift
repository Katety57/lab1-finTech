//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by  User on 06.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textDescript: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioEditField: UITextView!
    @IBOutlet weak var saveGCD: UIButton!
    @IBOutlet weak var saveOperation: UIButton!
    
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
        saveGCD.isHidden = true
        saveOperation.isHidden = true
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getFileURL(file: String) -> URL?{
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            return fileURL
        }
        return nil
    }
    
    func profileView() {
        saveGCD.isHidden = true
        saveOperation.isHidden = true
        editButton.isHidden = false
        usernameTextField.isHidden = true
        bioEditField.isHidden = true
        username.isHidden = false
        textDescript.isHidden = false
        usernameIsChanged = false
        bioIsChanged = false
    }
    
    func editorView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
        textDescript.isHidden = true
        username.isHidden = true
        editButton.isHidden = true
        
        usernameTextField.isHidden = false
        usernameTextField.text = ""
        bioEditField.isHidden = false
        bioEditField.text = ""
        saveGCD.isHidden = false
        saveOperation.isHidden = false
        bioEditField.layer.borderWidth = 0.5
        bioEditField.layer.borderColor = UIColor.lightGray.cgColor
        bioEditField.layer.cornerRadius = 5
        
        frameBtn(btnName: saveGCD)
        frameBtn(btnName: saveOperation)
        saveGCD.isEnabled = false
        saveOperation.isEnabled = false
    }
    
    @IBAction func pushedGCD(_ sender: Any) {
        guard let usernameField = usernameTextField.text else { return }
        guard let bio = bioEditField.text else {return }
        let file_user = "file_username.txt"
        let file_bio = "file_bio.txt"
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            do{
                let gcdManager = GCDDataManager()
                if self.usernameIsChanged {
                    if let fileURL = self.getFileURL(file: file_user){
                        gcdManager.write(jsonData: usernameField, fileURL: fileURL)
                        }
                }
                if self.bioIsChanged {
                    if let fileURL_bio = self.getFileURL(file: file_bio){
                        gcdManager.write(jsonData: bio, fileURL: fileURL_bio)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
                    self.saveGCD.isEnabled = false
                    self.saveOperation.isEnabled = false
                    if !usernameField.isEmpty && !bio.isEmpty {
                        if let user = self.getFileURL(file: file_user){ self.username.text = gcdManager.read(fileURL: user)
                        }
                        if let txt = self.getFileURL(file: file_bio){ self.textDescript.text = gcdManager.read(fileURL: txt)
                        }
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
        if usernameIsChanged || bioIsChanged {
            saveGCD.isEnabled = true
            saveOperation.isEnabled = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if bioEditField.text != textDescript.text {
            bioIsChanged = true
        }
        if usernameIsChanged || bioIsChanged {
            saveGCD.isEnabled = true
            saveOperation.isEnabled = true
        }
    }
    
    @IBAction func pushedOperation(_ sender: Any) {
        
    }
    
    class GCDDataManager {
        func read(fileURL: URL) -> String {
            do {
                    let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                return text2
                }catch {print("Cann't read file")}
            return "Error"
        }
        func write(jsonData:String, fileURL: URL){
            do {
                    try jsonData.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch {print("Cann't write file")}
        }
    }
    
    class OperationDataManager {
        func read(){}
        func write(){}
    }
}
