//
//  MemeCollectionViewController.swift
//  Meme-Me-2
//
//  Created by JFK on 6/26/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import Foundation
import UIKit

// MARK: MemeCollectionViewController

class MemeCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var memes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Methods
    func configureMemeText (textField: UITextField, size: CGFloat, savedMemeFont: String) {
        let memeTextField = textField
        memeTextField.delegate = self
        memeTextField.defaultTextAttributes = appDelegate.memeTextAttributes
        memeTextField.textAlignment = .center
        memeTextField.font = UIFont(name: savedMemeFont, size: size)!
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sent Memes"
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3
        let heightDimension = (view.frame.size.height - (2 * space)) / 6
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: heightDimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MemeCollectionCell
        let aMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage?.image = aMeme.zoomedNoTextImage
        cell.topTextField.text = aMeme.topText
        cell.bottomTextField.text = aMeme.bottomText
        configureMemeText(textField: cell.topTextField, size: 10, savedMemeFont: aMeme.memeFont)
        configureMemeText(textField: cell.bottomTextField, size: 10, savedMemeFont: aMeme.memeFont)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
