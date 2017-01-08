//
//  ListViewController.swift
//  Planner
//
//  Created by Nikolas Nikravesh on 1/8/17.
//  Copyright © 2017 Nikolas Nikravesh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: Outlets
    @IBOutlet weak var taskField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldMethods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskField.resignFirstResponder()
        taskField.text = ""
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
