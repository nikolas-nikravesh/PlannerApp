//
//  ViewController.swift
//  Planner
//
//  Created by Nikolas Nikravesh on 1/7/17.
//  Copyright © 2017 Nikolas Nikravesh. All rights reserved.
//
//  Notes:
//  Fix Keyboard moving when typing the text
//  Fix date display
//  Deal with possible scrolling and portrait orientation
//
//


import UIKit


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

    }
    
    func dismissKeyboard() {

        view.endEditing(true)
        
    }
}



class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    

    //MARK: Varibles
    
    var beganEditing: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //handles hiding keyboard when user taps around the outside
        self.hideKeyboardWhenTappedAround()
        
        
        //adjust the keyboard view when typing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        textField.delegate = self
        locationLabel.delegate = self
        descriptionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: TextFieldDelegate methods
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if(textField == self.textField) {
            taskNameLabel.text = textField.text
            textField.text = ""
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    
    //MARK: textView methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(!beganEditing){
            descriptionView.text = ""
            descriptionView.textColor = UIColor.black
            beganEditing = true
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: Actions
    
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
    
        dateLabel.text = sender.date.description
        dateLabel.textColor = UIColor.black
        
    }
    
    
    
    //MARK: Keyboard Adjusting
    
    @objc func keyboardWillShow(notification: NSNotification) {
    
        if locationLabel.isEditing {
        
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
                else {
                    
                }
            }
    
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if locationLabel.isEditing {
        
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height
                }
                else {
                    
                }
            }
            
        }
    }
    
}

