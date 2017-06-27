//
//  MemeTableViewController.swift
//  Meme-Me-2
//
//  Created by JFK on 6/26/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var memes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    
    let memeTextAttributes: [String : Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 10)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    // MARK: Methods
    
    func configureMemeText (textField: UITextField) {
        let memeTextField = textField
        memeTextField.delegate = self
        memeTextField.defaultTextAttributes = memeTextAttributes
        memeTextField.textAlignment = .center
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sent Memes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeTableCell
        let aMeme = self.memes[(indexPath as NSIndexPath).row]
        //cell.imageView?.image = imageWithImage(image: aMeme.memedImageJK, scaledToSize: CGSize(width: 100, height: 80))
        cell.memeImage.image = aMeme.memedImageJK
        cell.memeText.text = "\(aMeme.topText)..." + "\(aMeme.bottomText)"
        cell.topTextField.text = aMeme.topText
        cell.bottomTextField.text = aMeme.bottomText
        configureMemeText(textField: cell.topTextField)
        configureMemeText(textField: cell.bottomTextField)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: Other methods
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.automatic)
    }
    
}
