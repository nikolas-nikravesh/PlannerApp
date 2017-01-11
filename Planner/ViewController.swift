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



class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Outlets
    

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var timeStack: UIStackView!
    
    //Picker outlets
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var yearPicker: UIPickerView!
    

    //MARK: Varibles
    
    var beganEditing: Bool = false
    
    var task: Task?
    
    var monthData: [String] = []
    
    var dayData: [String] = []
    
    var yearData: [String] = []
    
    var fullDate: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //handles hiding keyboard when user taps around the outside
        self.hideKeyboardWhenTappedAround()
        
        
        //populate picker data lists
        monthData = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        for i in 1...31 {
            dayData.append("\(i)")
        }
        
        for i in 2017...2030 {
            yearData.append("\(i)")
        }
        
        fullDate.append(monthData[0])
        fullDate.append(dayData[0])
        fullDate.append(yearData[0])
        
        
        monthPicker.tag = 0
        dayPicker.tag = 1
        yearPicker.tag = 2
        
        
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
            startTextField.text = task.startTime
            endTextField.text = task.endTime
        
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
    
    
    //MARK: Picker Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return monthData.count
        } else if pickerView.tag == 1 {
            return dayData.count
        } else if pickerView.tag == 2 {
            return yearData.count
        } else {
            fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return monthData[row]
        } else if pickerView.tag == 1 {
            return dayData[row]
        } else if pickerView.tag == 2 {
            return yearData[row]
        } else {
            fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            fullDate[0] = monthData[row]
        } else if pickerView.tag == 1 {
            fullDate[1] = dayData[row]
        } else if pickerView.tag == 2 {
            fullDate[2] = yearData[row]
        } else {
            fatalError()
        }
        
        dateTextField.text = fullDate[0] + " " + fullDate[1] + ", " + fullDate[2]
    }
    
    
    
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
        let start: String = startTextField.text ?? ""
        let end: String = endTextField.text ?? ""


        task = Task(name: name, date: date, location: location, start: start, end: end)
        
    }
    
    
    //MARK: Keyboard Adjusting
    
    @objc func keyboardWillShow(notification: NSNotification) {
    
        
        if startTextField.isEditing || endTextField.isEditing {
        
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
        
        
        if startTextField.isEditing || endTextField.isEditing {
        
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

