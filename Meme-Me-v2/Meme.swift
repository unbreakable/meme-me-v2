//
//  Meme.swift
//  Meme-Me-2
//
//  Created by JFK on 6/7/17.
//  Copyright © 2017 Jonathan Kaufman. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImageJK: UIImage
}

// MARK: - Meme Array

/**
 * This extension adds static variable allMemes, an array of Meme objects
 */

//extension Meme {
//    
//    // Generate an array full of all of the memes in
//    static var allMemes: [Meme] {
//        
//        var memeArray = [Meme]()
//        
//        for d in Meme.localMemeData() {
//            memeArray.append(Meme(dictionary: d))
//        }
//        
//        return memeArray
//    }
//    
//    static func localMemeData() -> [[String : String]] {
//        return [
//            [Meme.NameKey : "Mr. Big", Meme.EvilSchemeKey : "Smuggle herion.",  Meme.ImageNameKey : "Big"],
//            [Meme.NameKey : "Ernest Blofeld", Meme.EvilSchemeKey : "Many, many, schemes.",  Meme.ImageNameKey : "Blofeld"]
//        ]
//    }
//}
