//
//  OCRSlicer.swift
//  OCRSlicer
//
//  Created by Roberto Ferraz on 28.06.18.
//  Copyright © 2018 Roberto Ferraz. All rights reserved.
//

import Foundation

public class OCRSlicer {
    
    public init() { }
    
    public func slice(image: UIImage, completion: @escaping ((_: [UIImage]) -> Void)) {
        Slicer().slice(image: image, completion: completion)
    }
    
    public func sliceaAndOCR(image: UIImage, charWhitelist: String, charBlackList: String = "", completion: @escaping ((_: String, _: UIImage) -> Void)) {
        
        self.slice(image: image) { (slices) in
            for slice in slices {
                OCR().startTesseract(slice: slice, whiteList: charWhitelist, blackList: charBlackList, completion: { recognizedString, recognizedSlice  in
                    guard let string = recognizedString else { return }
                    completion(string, recognizedSlice)
                })
            }
        }
    }
}
