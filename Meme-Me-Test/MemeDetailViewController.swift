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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImage!.image = meme.memedImageJK
    }
}
