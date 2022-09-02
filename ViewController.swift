//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by Hilmihan Çalışan on 30.08.2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var ResultLabel: UILabel!
    
    var chosenImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func ChangeButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
        if let ciImage = CIImage(image: ImageView.image!) {
            chosenImage = ciImage
        }
        
        
        recognizerImage(image: chosenImage)
        
    }
   
    func recognizerImage(image: CIImage) {
        
        //Request
        //Hnadler
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    
                    if results.count > 0 {
                        
                        let topResult = results.first
                        
                        DispatchQueue.main.sync {
                            
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            
                            let rounded = Int (confidenceLevel * 100) / 100
                            
                            self.ResultLabel.text = "\(rounded)% it's \(topResult!.identifier)"
                            
                        }
                    }
                }
            
            
            
            
           
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        try handler.perform([request])
                    }catch {
                        print("error")
                    }
                }
       
        
        }
       
        
    }
    
}

