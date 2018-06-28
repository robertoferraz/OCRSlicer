//
//  OCR.swift
//  OCRSlicer
//
//  Created by Roberto Ferraz on 28.06.18.
//  Copyright © 2018 Roberto Ferraz. All rights reserved.
//

import Foundation
import TesseractOCR


internal class OCR: NSObject, G8TesseractDelegate {
    
    private let operationQueue = OperationQueue()
    
    internal func startTesseract(slice: UIImage, whiteList: String, blackList: String = "", completion: @escaping ((_: String?, _: UIImage) -> Void)) {
        if let operation = G8RecognitionOperation(language: "eng") {
            operation.tesseract.engineMode = .tesseractOnly
            operation.tesseract.pageSegmentationMode = .autoOnly
            operation.tesseract.delegate = self
            operation.tesseract.charWhitelist = whiteList
            operation.tesseract.charBlacklist = blackList
            operation.tesseract.image = slice.g8_blackAndWhite()
            
            operation.recognitionCompleteBlock = { tesseractSearch in
                let recognizedText = tesseractSearch?.recognizedText ?? ""
                completion(recognizedText, slice)
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
}
