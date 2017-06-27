//
//  MemeDetailViewController.swift
//  BondVillains
//
//  Created by JFK on 6/26/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    // MARK: Properties
    var meme: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var memeImage: UIImageView!
    
    // MARK: Actions
    @IBAction func editMeme() {
        performSegue(withIdentifier: "editMemeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editView = segue.destination as? MemeCreatorViewController {
            editView.meme = self.meme
        }
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Meme Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImage!.image = meme.memedImageJK
        self.tabBarController?.tabBar.isHidden = true
    }
}
