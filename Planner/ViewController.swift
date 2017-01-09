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
//  Change picker to a time picker
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



class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!

    

    //MARK: Varibles
    
    var beganEditing: Bool = false
    
    var task: Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //handles hiding keyboard when user taps around the outside
        self.hideKeyboardWhenTappedAround()
        
        
        //adjust the keyboard view when typing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        textField.delegate = self
        dateTextField.delegate = self
        locationTextField.delegate = self
        
        
        if let task = task {
            
            textField.text = task.name
            dateTextField.text = task.date
            navigationItem.title = task.name
            locationTextField.text = task.location
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: TextFieldDelegate methods
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    
    //MARK: Actions
    
    
    
    //MARK: Nav
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        var name: String
        
        if(textField.text?.isEmpty)! {
            name = (task?.name)!
        } else {
            name = textField.text ?? ""
        }
        
        
        let date: String = dateTextField.text ?? ""
        let location: String = locationTextField.text ?? ""
        

        task = Task(name: name, date: date, location: location)
        
    }
    
    
    //MARK: Keyboard Adjusting
    
    @objc func keyboardWillShow(notification: NSNotification) {
    
        
        if locationTextField.isEditing {
        
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
        
        
        if locationTextField.isEditing {
        
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

