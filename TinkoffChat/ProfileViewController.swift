//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by  User on 06.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textDescript: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImg.layer.cornerRadius =  cameraButton.frame.width/2.0
        
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2.0
        
        textDescript.textColor = UIColor.gray

        editButton.layer.borderWidth = 2
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
        if (sender as AnyObject).tag == 1 {
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.camera()}))
            ac.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.photoLibrary()}))
            present(ac, animated: true, completion: nil)
            ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
