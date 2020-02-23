//
//  ViewController.swift
//  TinkoffChat
//
//  Created by  User on 16.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var textDescript: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print(editButton.frame)
        //view еще не был создан, информации о editButton нет на данный момент
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImg.layer.cornerRadius =  cameraButton.frame.width/2.0
        
        cameraButton.layer.cornerRadius = cameraButton.frame.width/2.0
        
        textDescript.textColor = UIColor.gray

        editButton.layer.borderWidth = 2
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 10

        print(editButton.frame)//Значения x,y,height,width  высчитаны autolayout'ом как значения для устройства, используемого в storyboard
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(editButton.frame)//Значения x,y,height,width высчитаны autolayout'ом как значения для устройства, используемого в simulator
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
    
    @IBAction func chooseImg(_ sender: UIButton) {
        if sender.tag == 1 {
            print("Выберите изображение профиля\n")
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.camera()}))
            ac.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {(alert:UIAlertAction!) -> Void in self.photoLibrary()}))
            present(ac, animated: true, completion: nil)
            ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.contentMode = .scaleAspectFill
            profileImg.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

