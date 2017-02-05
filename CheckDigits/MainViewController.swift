//
//  ViewController.swift
//  CheckDigits
//
//  Created by Dan Shafman on 1/30/17.
//  Copyright © 2017 Dan Shafman. All rights reserved.
//

import UIKit
import ALCameraViewController

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var imgTaken: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.orange;
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageTaken" {
            let destination = segue.destination as! ImageTakenViewController
            destination.imageTaken = self.imgTaken
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cameraButtonPressed() {
        let cameraViewController = CameraViewController(croppingEnabled: true) { [weak self] image, asset in
            if image != nil {
                self?.imgTaken = image
            }
            self?.dismiss(animated: true) {
                if image != nil {
                    self?.performSegue(withIdentifier: "imageTaken", sender: self)
                }
            }
        }
        present(cameraViewController, animated: true) {
            
        }
    }

}

