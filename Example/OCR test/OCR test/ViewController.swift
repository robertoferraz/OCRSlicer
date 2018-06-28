//
//  ViewController.swift
//  OCR test
//
//  Created by Roberto Ferraz on 25.06.18.
//  Copyright © 2018 Roberto Ferraz. All rights reserved.
//

import UIKit
import OCRSlicer

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slice1ImageView: UIImageView!
    @IBOutlet weak var slice2ImageView: UIImageView!
    @IBOutlet weak var slice1Label: UILabel!
    @IBOutlet weak var slice2Label: UILabel!
    
    lazy var image = UIImage(named: "IMG_8528")!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageView.image = image
        
        let ocrSlicer = OCRSlicer()
        
        /*
        // Only the slices
        ocrSlicer.slice(image: image) { (images) in
            // use the images
        }
        */
        ocrSlicer.sliceaAndOCR(image: image, charWhitelist: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxwyz1234567890") { [unowned self] (text, image) in
            if self.slice1ImageView.image == nil {
                self.slice1ImageView.image = image
                self.slice1Label.text = text
            } else {
                self.slice2ImageView.image = image
                self.slice2Label.text = text
            }
        }
        
    }
}
