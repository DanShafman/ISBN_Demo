//
//  ImageTakenViewController.swift
//  CheckDigits
//
//  Created by Dan Shafman on 1/30/17.
//  Copyright © 2017 Dan Shafman. All rights reserved.
//

import Foundation
import UIKit
import TesseractOCR

class ImageTakenViewController: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var langGroup: UIButton!
    @IBOutlet weak var publisherGroup: UIButton!
    @IBOutlet weak var titleGroup: UIButton!
    @IBOutlet weak var checkDigitLabel: UIButton!
    
    @IBOutlet weak var descTitle: UILabel!
    @IBOutlet weak var descBody: UILabel!
    
    var imageTaken: UIImage!
    var img = UIImage(named: "four.png")
    var codeFound: String!
    var ean: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var deWhite: String = ""
        
        var tesseract:G8Tesseract = G8Tesseract(language: "eng")
        tesseract.delegate = self;
        tesseract.charWhitelist = "0123456789";
        
        if imageTaken != nil {
            tesseract.image = imageTaken
            tesseract.recognize();
            codeFound = tesseract.recognizedText
            print("rec: ", tesseract.recognizedText);

            // Process all characters found for the code
            for i in Array(codeFound.characters) {
                if i != " " && i != "\n" && i != "\t" {
                    deWhite.append(i)
                }
            }
            var list = Array(deWhite.characters)
            

            if list.count >= 12 {
                for i in 0...list.count - 12 {
                    if list[i] == "9" && list [i+1] == "7" && list[i+2] == "8" {
                         for j in 0...12 {
                            ean.append(list[i+j])
                        }
                        break
                    }
                }
            }

            print("de-whitespaced:", deWhite)
            print("ean:", ean)
        }
        
        // Make alerts to confirm that the string is correct
        
        if ean != "" {
            let alertController = UIAlertController(title: "Is this correct?", message: ean, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default ) { action in
                self.codeIsCorrect()
            }
            alertController.addAction(yesAction)
            
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default ) { action in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(noAction)
        
            present(alertController, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
            let alert = UIAlertController(title: "Error", message: "No codes found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func codeIsCorrect() {
        let charArr = Array(ean.characters)
        setTextInitial(chars: charArr)
    }
    
    func setTextInitial(chars: Array<Character>) {
        langGroup.setTitle(String(chars[3]) + String(chars[4]), for: .normal)
        publisherGroup.setTitle(String(chars[5]) + String(chars[6]) + String(chars[7]) + String(chars[8]), for: .normal)
        titleGroup.setTitle(String(chars[9]) + String(chars[10]) + String(chars[11]), for: .normal)
        checkDigitLabel.setTitle(String(chars[12]), for: .normal)
        
        langGroup.setTitleColor(UIColor.black, for: .normal)
        publisherGroup.setTitleColor(UIColor.black, for: .normal)
        titleGroup.setTitleColor(UIColor.black, for: .normal)
        checkDigitLabel.setTitleColor(UIColor.red, for: .normal)
        
        descTitle.text = ""
        descBody.text = ""
        
        langGroup.addTarget(self, action: #selector(langPressed), for: .touchUpInside)
        publisherGroup.addTarget(self, action: #selector(publisherPressed), for: .touchUpInside)
        titleGroup.addTarget(self, action: #selector(titlePressed), for: .touchUpInside)
        checkDigitLabel.addTarget(self, action: #selector(checkPressed), for: .touchUpInside)
    }
    
    func langPressed() {
        langGroup.setTitleColor(UIColor.orange, for: .normal)
        publisherGroup.setTitleColor(UIColor.black, for: .normal)
        titleGroup.setTitleColor(UIColor.black, for: .normal)
        checkDigitLabel.setTitleColor(UIColor.red, for: .normal)
        
        descTitle.text = "Language group"
        descBody.text = "Also called the registration group element, this group identifies the country/language in which the book is being published. Between 1 and 5 digits in length."
    }
    
    func publisherPressed() {
        langGroup.setTitleColor(UIColor.black, for: .normal)
        publisherGroup.setTitleColor(UIColor.orange, for: .normal)
        titleGroup.setTitleColor(UIColor.black, for: .normal)
        checkDigitLabel.setTitleColor(UIColor.red, for: .normal)
        
        descTitle.text = "Publisher group"
        descBody.text = "Also called the registrant element, this identifies the publisher of the book. Usually 4 digits in length."
    }
    
    func titlePressed() {
        langGroup.setTitleColor(UIColor.black, for: .normal)
        publisherGroup.setTitleColor(UIColor.black, for: .normal)
        titleGroup.setTitleColor(UIColor.orange, for: .normal)
        checkDigitLabel.setTitleColor(UIColor.red, for: .normal)
        
        descTitle.text = "Title group"
        descBody.text = "Also called the publication element, identifies the edition/format of the book. May be up to 6 digits in length."
    }
    
    func checkPressed() {
        langGroup.setTitleColor(UIColor.black, for: .normal)
        publisherGroup.setTitleColor(UIColor.black, for: .normal)
        titleGroup.setTitleColor(UIColor.black, for: .normal)
        checkDigitLabel.setTitleColor(UIColor.orange, for: .normal)
        
        descTitle.text = "Check digit"
        
        let charArr = Array(ean.characters)
        var cdText = "Single digit that validates the rest of the code. Each digit in the ISBN code is used to derive the check digit. For th e ISBN code \(ean) the formula for the check digit is:\n\n(10 - ("
        for i in (0...11) {
            if i % 2 == 0 {
                cdText.append(String(charArr[i]) + " + ")
            } else {
                cdText.append("3*" + String(charArr[i]) + " + ")
            }
        }
        cdText.append("0) mod 10 \n\n = \(charArr[12])")
        descBody.text = cdText
    }
    
}
