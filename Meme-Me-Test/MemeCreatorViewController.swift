//
//  MemeCreatorViewController.swift
//  Meme-Me-2.0
//
//  Created by JFK on 6/5/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Properties
    var meme: Meme!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let notificationName = Notification.Name("NotificationIdentifier")
    let pickerControllerJK = UIImagePickerController()
    
    // MARK: Outlets for Image
    @IBOutlet weak var scrollViewForImage: UIScrollView!
    @IBOutlet weak var imageViewJK: UIImageView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: Outlets for All Else
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerControllerJK.delegate = self
        
        if (meme != nil) {
            topText.text = meme.topText
            bottomText.text = meme.bottomText
            imageViewJK.image = meme.originalImage
            shareButton.isEnabled = true
        } else {
            setInitialText()
            shareButton.isEnabled = false
        }
        
        // Color set-up
        imageViewJK.backgroundColor = UIColor(hexString: "#333333")
        toolbarBottom.barTintColor = UIColor(hexString: "#4097A3")
        navBar.barTintColor = UIColor(hexString: "#4097A3")
        
        // Image zooming
        scrollViewForImage.minimumZoomScale = 1.0
        scrollViewForImage.maximumZoomScale = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Text set-up
        configureMemeText(textField: topText, size: 40)
        configureMemeText(textField: bottomText, size: 40)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Image methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewJK
    }
    
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
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageViewJK.image!, memedImageJK: generateMemedImage(withText: true), zoomedNoTextImage: generateMemedImage(withText: false), memeFont: appDelegate.currentFont)
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage(withText: Bool) -> UIImage {
        // Hide stuff
        toolbarBottom.isHidden = true
        navBar.isHidden = true
        
        // Described in Meme.swift in more detail, but this saves the zoomed/noText image
        if !withText {
            topText.isHidden = true
            bottomText.isHidden = true
        }
        
        // Render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show stuff after image capture
        toolbarBottom.isHidden = false
        navBar.isHidden = false
        topText.isHidden = false
        bottomText.isHidden = false
        
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let memeImage = generateMemedImage(withText: true)
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        
        // save meme and dismiss ActivityViewController
        controller.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save(memeImage)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureMemeText (textField: UITextField, size: CGFloat) {
        let memeTextField = textField
        memeTextField.delegate = self
        memeTextField.defaultTextAttributes = appDelegate.memeTextAttributes
        memeTextField.textAlignment = .center
        memeTextField.font = UIFont(name: appDelegate.currentFont, size: size)!
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

