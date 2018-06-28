//
//  DataPlugOCR.swift
//  OCR test
//
//  Created by Roberto Ferraz on 26.06.18.
//  Copyright © 2018 Roberto Ferraz. All rights reserved.
//

import UIKit
import Vision
import TesseractOCR

internal class Slicer {
    
    private var image = UIImage()
    private var sliceCompletion: ((_ slices: [UIImage]) -> Void) = { _ in }
    
    private lazy var textDetectionRequest: VNDetectTextRectanglesRequest = {
        return VNDetectTextRectanglesRequest(completionHandler: self.handleDetectedText)
    }()
    
    internal func slice(image: UIImage, completion: @escaping ((_: [UIImage]) -> Void)) {
        self.image = image
        self.sliceCompletion = completion
        self.performVisionRequest(image: image.g8_blackAndWhite().fixOrientation().cgImage!, orientation: .up)
    }
    
    // MARK: - Vision
    
    private func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
                try imageRequestHandler.perform([self.textDetectionRequest])
            } catch let error as NSError {
                self.sliceCompletion([UIImage]())
                print("Failed to perform vision request: \(error)")
            }
        }
    }
    
    private func handleDetectedText(request: VNRequest?, error: Error?) {
        if let err = error as NSError? {
            print("Failed during detection: \(err.localizedDescription)")
            return
        }
        guard let results = request?.results as? [VNTextObservation], !results.isEmpty else { return }
        
        self.sliceImage(text: results, onImageWithBounds: CGRect(x: 0, y: 0, width: self.image.cgImage!.width, height: self.image.cgImage!.height))
    }
    
    private func sliceImage(text: [VNTextObservation], onImageWithBounds bounds: CGRect) {
        CATransaction.begin()
        
        var slices = [UIImage]()
        
        for wordObservation in text {
            let wordBox = boundingBox(forRegionOfInterest: wordObservation.boundingBox, withinImageBounds: bounds)
            
            if !wordBox.isNull {
                guard let slice = self.image.cgImage?.cropping(to: wordBox) else { continue }
                slices.append(UIImage(cgImage: slice))
            }
        }
        
        self.sliceCompletion(slices)
        
        CATransaction.commit()
    }
    
    private func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        // Begin with input rect.
        var rect = forRegionOfInterest
        
        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.y = ((1 - rect.origin.y) * imageHeight) - (forRegionOfInterest.height * imageHeight)
        
        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
}
