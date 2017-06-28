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
    var zoomedNoTextImage: UIImage // Zoomed image with no text so app can present in collection and table images with text dynamically arranged (dynamic reconstruction is what the appstore app seems to do and this allows zoomed thumbs with that UI look)
    var memeFont: String
}
