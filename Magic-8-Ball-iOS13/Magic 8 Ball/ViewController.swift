//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Angela Yu on 14/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // setup a timer
    var timer1: Timer?
    
    // UI elements
    @IBOutlet weak var magic8ballImage: UIImageView!
    @IBOutlet weak var shakeDeviceText: UILabel!
    @IBOutlet weak var askAquestionFeild: UITextField!
    @IBOutlet weak var shakeDeviceToAsk: UILabel!
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // our array of images
    let ballArray: [UIImage?] = [
        UIImage(named: "ball1"),
        UIImage(named: "ball2"),
        UIImage(named: "ball3"),
        UIImage(named: "ball4"),
        UIImage(named: "ball5")
    ]
    
    // sets a random image on load
    func setRandomImage() {
        let randomIndex = Int.random(in: 0..<ballArray.count)
        if let randomImage = ballArray[randomIndex] {
            magic8ballImage.image = randomImage
        }
    }
    
    // the view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        setRandomImage()
        
        // Add a tap gesture recognizer to the view, allows our dismissKeyboard function to be setup so user can tap away from an input box so the keyboard will close
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // controls when device motion begins
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        // if there is motion
        if motion == .motionShake {
            view.endEditing(true) // Dismiss the keyboard
            
            // check if the text field for questions has text
            if let textFieldText = askAquestionFeild.text, !textFieldText.isEmpty {
                // not empty
                print("Text field text: \(textFieldText)")
                pulseImageAlpha(element: magic8ballImage)
            } else {
                // is empty
                showEmptyTextFieldAlert()
            }
        }
    }
    
    // alerts the user
    func showEmptyTextFieldAlert() {
        let alertController = UIAlertController(title: "Empty Text Field", message: "Please enter a question in order to get an answer.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // this timer pulses the image by its Alpha and stops when the counter reaches a certain point
    func pulseImageAlpha(element: UIImageView) {
           var counter = 0
           // trigger the animation sequence every 0.5 seconds
           timer1 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
               // begin animation sequence
               DispatchQueue.main.async {
                   if let _ = self {
                       // animate the alpha inside this closure that the timer is running
                       UIView.animate(withDuration: 0.25, animations: {
                           // fade image out
                           element.alpha = 0.25
                       }) { (finished) in
                           // if the animation finished proceed to the next
                           if finished {
                               // after fade out, fade in again
                               UIView.animate(withDuration: 0.25, animations: {
                                   // fade in partially
                                   element.alpha = 0.75
                               }) { (finished) in
                                   if finished && counter >= 5 {
                                       // After the pulse animation ends, switch to a random image
                                       self?.setRandomImage()
                                   }
                               }
                           }
                       }
                   }
               }
               // increment the counter then stop the timer
               counter += 1
               if counter >= 6 {
                   self?.timer1?.invalidate()
               }
           }
       }
    // deinitialize the time when closed
    deinit{
        timer1?.invalidate()
    }
}

