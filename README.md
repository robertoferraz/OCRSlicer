OCRSlicer iOS 
=================

- No OS X support.
- Strict requirement on language files existing in a referenced "tessdata" folder.

Instalation
=================

Using cocoa pods just add the following line to your podfile

```pod 'OCRSlicer'```

and run: 

```pod install```


Usage
=================
- Check the Example project to see how to use this library
- You will need the trained data for your language, in the example folder you will find the data for english. Check the Tesseract page to get more trained data (https://github.com/gali8/Tesseract-OCR-iOS/wiki/Installation#importing-the-tessdata-folder)

The library has two methods:

One to just detect text and return images (slices) of the text found

```public func slice(image: UIImage, completion: @escaping ((_: [UIImage]) -> Void))```

The other runs the OCR returning the pair text and slice

```public func sliceaAndOCR(image: UIImage, charWhitelist: String, charBlackList: String = "", completion: @escaping ((_: String, _: UIImage) -> Void))```


Screenshot of the example project, showing the original input image on the top, the detected text and the slices of the original image showing where it was found.

![Screenshot](https://github.com/robertoferraz/OCRSlicer/blob/master/Screenshot.png)

License
=================

OCRSlicer iOS is distributed under the MIT

Tesseract, maintained by Google (http://code.google.com/p/tesseract-ocr/), is
distributed under the Apache 2.0 license (see
http://www.apache.org/licenses/LICENSE-2.0).
