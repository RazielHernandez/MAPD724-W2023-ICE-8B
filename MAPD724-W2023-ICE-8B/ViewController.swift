//
//  ViewController.swift
//  MAPD724-W2023-ICE-8B
//
//  Created by Raziel Hernandez on 2023-03-25.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    var imageNames:[String] = ["cat2","cat3","cat4",
        "dog2","dog3","dog4","eagle1","eagle3","eagle4",
        "tiger3","whale2","whale3"]
    var imageTypes:[String] = ["jpeg","jpeg","jpeg","jpeg","jpeg","jpeg","jpg","jpeg","jpeg","jpeg","jpeg","jpeg"]
    
    var modelFileNet = MobileNetV2()
    var modelFileSq = SqueezeNet()
    
    var index: Int = 0
    var actualImageName: String = ""
    var actualImageType: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        index = 0
        actualImageName = imageNames[index]
        actualImageType = imageTypes[index]
        imageView.image = UIImage(named: actualImageName+"."+actualImageType)
        
        let imagePath = Bundle.main.path(forResource: actualImageName, ofType: actualImageType)
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let model = try! VNCoreMLModel(for: modelFileSq.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }
    
    func findResults(request: VNRequest, error: Error?) {
       guard let results = request.results as?
       [VNClassificationObservation] else {
       fatalError("Unable to get results")
       }
       var bestGuess = ""
       var bestConfidence: VNConfidence = 0
       for classification in results {
          if (classification.confidence > bestConfidence) {
             bestConfidence = classification.confidence
             bestGuess = classification.identifier
          }
       }
       labelDescription.text = "Image is: \(bestGuess) with confidence \(bestConfidence) out of 1"
    }

    @IBAction func nextImage_pressed(_ sender: UIButton) {
        
        index += 1
        if (index >= imageNames.count){
            index = 0
        }
        
        actualImageName = imageNames[index]
        actualImageType = imageTypes[index]
        imageView.image = UIImage(named: actualImageName+"."+actualImageType)
        let imagePath = Bundle.main.path(forResource: actualImageName, ofType: actualImageType)
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let model = try! VNCoreMLModel(for: modelFileNet.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }
    
}

