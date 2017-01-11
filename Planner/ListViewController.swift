//
//  ListViewController.swift
//  Planner
//
//  Created by Nikolas Nikravesh on 1/8/17.
//  Copyright © 2017 Nikolas Nikravesh. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    
    var items = [Task]()
    var rowHeight: CGFloat = 50
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.delegate = self
        
        //handles hiding keyboard when user taps around the outside
        self.hideKeyboardWhenTappedAround()
        
        //Set height of table size
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //load sample tasks into the list
        loadSampleTask()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: TextField methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        addItem(sender: textField)
        
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
    
    //MARK: TableView methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //format the adding of the cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        let task = items[indexPath.row]
        
        cell.taskLabel.text = task.name
        
        if task.location.isEmpty {
            cell.dateLabel.text = task.date
        } else {
            if task.date.isEmpty {
                cell.dateLabel.text = task.location
            } else {
                cell.dateLabel.text = task.date + " @ " + task.location
            }
        }
        
        
        return cell

    }
    
    //called when row is selected
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    //Adds a new item to the list
    
    @IBAction func addItem(sender: UITextField) {
    
        let task = Task(name: sender.text!, date: "Today", location: "", start: "", end: "")
        items.append(task!)
        tableView.reloadData()
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    //delete methods
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            items.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //MARK: Actions

    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        
        let sourceViewController = sender.source as! ViewController
        
        let task = sourceViewController.task
        
        let selectedIdx = tableView.indexPathForSelectedRow!
        
        items[selectedIdx.row] = task!
        
        tableView.reloadData()
        
        tableView.deselectRow(at: selectedIdx, animated: true)
        
        


    }
    
    
    
    //MARK: Other methods
    
    private func loadSampleTask() {
    
        let task = Task(name: "Math Discussion", date: "Thursday", location: "York Hall", start: "4:00 PM", end: "4:50 PM")
        
        items.append(task!)
        
        tableView.reloadData()
        
    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
 
        let taskController = segue.destination as? ViewController
        
        let selectedCell = sender as? TaskTableViewCell
        
        let idxPath = tableView.indexPath(for: selectedCell!)
        
        let selectedTask = items[(idxPath?.row)!]
        taskController?.task = selectedTask
        
        
    }
    

}
