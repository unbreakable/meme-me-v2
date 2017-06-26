//
//  MemeTableViewController.swift
//  Meme-Me-2
//
//  Created by JFK on 6/26/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    var memes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let aMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = aMeme.memedImageJK
        
        let topText = aMeme.topText
        let bottomText = aMeme.bottomText
        cell.textLabel?.text = "\(topText) " + "\(bottomText)"
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Test details"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
