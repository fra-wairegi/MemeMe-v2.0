//
//  MemeEditorViewController.swift
//  MemeMe 2.0
//
//  Created by Francis Wairegi on 12/30/18.
//  Copyright © 2018 Francis Wairegi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:  UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth: -4.0
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMemeTextField(textField: topTextField, text: "TOP")
        configureMemeTextField(textField: bottomTextField, text: "BOTTOM")
        
        // Disable the share button
        shareButton.isEnabled = false
    }

    func configureMemeTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    // MARK: Start Keyboard adjustments
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Disable camera button if device does not have camera
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
            
            subscribeToKeyboardNotifications()
        }
    
        override func viewWillDisappear(_ animated: Bool) {
            
            super.viewWillDisappear(animated)
            unsubscribeFromKeyboardNotifications()
        }
    
        func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
        func unsubscribeFromKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
        @objc func keyboardWillShow(_ notification:Notification) {
            
            // Shift the image up to accomodate the keyboard only when the bottom text field is selected
            if bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    
        @objc func keyboardWillHide(_ notification:Notification) {
            
            // Hide keyboard only when the bottom text field is selected
            if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
            }
        }
    
        func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
        }
    // End Keyboard adjustments
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

            // Use ".editedImage" instead of ".originalImage" as allowsEditing flag
            //  is true. This ensures the proper image is picked from the info dictionary
            if let image = info[.editedImage] as? UIImage {
                imagePickerView.image = image
            
            // Enable the share button after and image is choosen
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func chooseImageSource(sourceType: UIImagePickerController.SourceType) {
        
        //Choose An Image From Source
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        pickerController.allowsEditing = true  // Allow the image to be edited
        
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        chooseImageSource(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageSource(sourceType: .camera)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        // When a user taps inside a textfield, the default text should clear
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // When a user presses return, the keyboard should be dismissed
        textField.resignFirstResponder()
        return true;
    }
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage();
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolbar.isHidden = true
        navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbar.isHidden = false
        navigationBar.isHidden = false
        return memedImage
    }
    @IBAction func shareButton(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            
            // Save only if the sharing action is successful
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        // When Cancel button is pressed, the Sent Memes appears
        dismiss(animated: true, completion: nil)
    }
}

