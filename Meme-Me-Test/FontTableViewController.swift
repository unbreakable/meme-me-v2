//
//  FontTableViewController.swift
//  Meme-Me-2
//
//  Created by JFK on 6/27/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import Foundation
import UIKit

class FontTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let memeTextAttributes: [String : Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 10)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    // MARK: Methods
    func configureText (textField: UITextField) {
        let memeTextField = textField
        memeTextField.delegate = self
        memeTextField.defaultTextAttributes = memeTextAttributes
        memeTextField.textAlignment = .center
    }
    
    // MARK: Actions
    @IBAction func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Font"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.fontArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell")!
        let font = appDelegate.fontArray[(indexPath as NSIndexPath).row]
        let currentFontValue = appDelegate.currentFont
        cell.textLabel?.text = font
        
        if (cell.textLabel?.text == currentFontValue) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            updateFont(font: appDelegate.fontArray[(indexPath as NSIndexPath).row])
            cell.accessoryType = .checkmark
        }
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateFont(font: String) {
        appDelegate.currentFont = font
    }
    
}
