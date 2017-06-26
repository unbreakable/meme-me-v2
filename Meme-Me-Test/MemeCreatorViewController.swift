//
//  MemeCreatorViewController.swift
//  Meme-Me-2.0
//
//  Created by JFK on 6/5/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var imageViewJK: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    // MARK: Vars and Constants
    let notificationName = Notification.Name("NotificationIdentifier")
    let pickerControllerJK = UIImagePickerController()
    let memeTextAttributes: [String : Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
            // Add choices for: 
            // Impact, Oswald, AATypewriter, AdobeGothicStd-Bold, CooperBlackStd, HoboStd, Whoa!
        NSStrokeWidthAttributeName: -3.0
    ]
    
    // MARK: Standard methods
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerControllerJK.delegate = self
        
        // Text set-up
        configureMemeText(textField: topText)
        configureMemeText(textField: bottomText)
        setInitialText()
        
        // UI set-up
        shareButton.isEnabled = false
        imageViewJK.backgroundColor = UIColor(hexString: "#333333")
        toolbarBottom.barTintColor = UIColor(hexString: "#4097A3")
        navBar.barTintColor = UIColor(hexString: "#4097A3")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Image methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Error")
            dismiss(animated: true, completion: nil)
            return
        }
        
        shareButton.isEnabled = true
        
        imageViewJK.contentMode = .scaleAspectFit
        imageViewJK.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if (imageViewJK.image != nil) {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
        
        // Did this because autocorrect kept grabbing final character and autocorrecting it to some other random character...
        textField.autocorrectionType = .no
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard slides
    func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight( notification ) * -1
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CG rect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0 
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Meme object
    func save(_ memedImage: UIImage) {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageViewJK.image!, memedImageJK: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide stuff
        toolbarBottom.isHidden = true
        navBar.isHidden = true
        
        // Render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show stuff
        toolbarBottom.isHidden = false
        navBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Image picker actions
    @IBAction func pickImage(_ sender: Any) {
        pickerControllerJK.sourceType = .photoLibrary
        present(pickerControllerJK, animated: true, completion: nil)
    }
    
    @IBAction func pickCameraImage(_ sender: Any) {
        pickerControllerJK.sourceType = .camera
        present(pickerControllerJK, animated: true, completion: nil)
    }
    
    // MARK: Other app actions and abstractions
    @IBAction func resetToInitialState(_ sender: Any) {
        setInitialText()
        imageViewJK.image = nil
    }
    
    @IBAction func shareAction(_ sender: Any) {
        // generate a memed image
        let memeImage = generateMemedImage()
        
        // define an instance of the ActivityViewController AND pass a memedImage as an activity item
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        // present the ActivityViewController
        present(controller, animated: true, completion: nil)
        
        // save meme and dismiss ActivityViewController
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save(memeImage)
            }
        }
    }
    
    func configureMemeText (textField: UITextField) {
        let memeTextField = textField
        memeTextField.delegate = self
        memeTextField.defaultTextAttributes = memeTextAttributes
        memeTextField.textAlignment = .center
    }
    
    func setInitialText() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
}

// MARK: UIColor by Hex extension
// Added this extension (discovered on StackOverflow) to more easily use hex values to set UI colors
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

