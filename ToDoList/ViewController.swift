//
//  ViewController.swift
//  ToDoList
//
//  Created by user239775 on 2/19/24.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!   
    
    var todoItems = [String]()
    
    @IBAction func addButtonTapped(_ sender: Any) {
        // Create an alert controller
        let alertController = UIAlertController(title: "Add Task", message: "Enter the task name", preferredStyle: .alert)
        
        // Add a text field to the alert controller
        alertController.addTextField { textField in
            textField.placeholder = "Task Name"
        }
        
        // Create a "Confirm" action
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, let taskName = textField.text else { return }
            // Add the task to the list
            self?.addTask(taskName)
        }
        alertController.addAction(confirmAction)
        
        // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadTodoItems()
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    func addTask(_ taskName: String) {
        // Add the task to the list
        todoItems.append(taskName)
        saveTodoItems()
        tableView.reloadData()
    }
    
    func loadTodoItems() {
        if let savedTodoItems = UserDefaults.standard.array(forKey: "todoItems") as? [String] {
            todoItems = savedTodoItems
            tableView.reloadData()
        }
    }
    
    func saveTodoItems() {
        UserDefaults.standard.set(todoItems, forKey: "todoItems")
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! ToDoTableViewCell
        
        // Configure the cell...
        let taskName = todoItems[indexPath.row]
        cell.titleLabel.text = taskName
        
        return cell
    }

    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the data source
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            saveTodoItems() // Update permanent storage after deletion
            tableView.reloadData() // Reload the table view to reflect changes
        }
    }
}


