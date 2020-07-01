//
//  TaskListViewController.swift
//  SimpleToDo
//
//  Created by Pavel Parshin on 30.06.2020.
//  Copyright © 2020 Pavel Parshin. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {

    var tasks: [Task] = []
    private let cellID = "cell"
    private let storage = StorageManager.shared
    private let constant = Constant.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasks = storage.fetchData()
        tableView.reloadData()
    }

    // MARK: - Private methods
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Config view Navigation Bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = constant.mainColor
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        //Add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTask))
        
        //Edit button
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    @objc private func editCellTask(_ sender: UIButton) {
        let indexPatch = IndexPath(row: sender.tag, section: 0)
        showEditAlert(with: "Edit Task", and: "Would do you like to change this task?", for: indexPatch)
    }
    
    func save(_ taskName: String) {
        guard let task = storage.save(taskName) else { return }
        tasks.append(task)
        
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func editTask(_ task: Task, with indexPath: IndexPath, to newName: String) {
        task.name = newName
        storage.edit(task: task)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func deleteTask(forRowAt indexPath: IndexPath) {
        storage.delete(task: tasks[indexPath.row])
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        editButton(in: cell, and: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(forRowAt: indexPath)
            tableView.isEditing.toggle()
        }
    }
    
    // additing Edit Button
    private func editButton(in cell: UITableViewCell, and indexPath: IndexPath) {
        let button = UIButton(frame: CGRect(x: cell.frame.width, y: 0, width: 50, height: 50))
        button.setImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(editCellTask), for: .touchUpInside)
        button.tag = indexPath.row
        button.tintColor = constant.editColor
        
        cell.addSubview(button)
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [editTaskAction(with: indexPath)])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [deleteTaskAction(with: indexPath)])
    }
    
    // MARK: Swipe Actions
    @objc private func editTaskAction(with indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Edit") { ( _, _, complition) in
            self.showEditAlert(with: "Edit Task", and: "Would do you like to change this task?", for: indexPath)
            complition(true)
        }
        action.backgroundColor = constant.editColor
        action.image = UIImage(systemName: "pencil.circle.fill")
        return action
    }
    
    private func deleteTaskAction(with indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { ( _, _, complition) in
            self.deleteTask(forRowAt: indexPath)
            complition(true)
        }
        action.backgroundColor = constant.deleteColor
        action.image = UIImage(systemName: "delete.left.fill")
        return action
    }

}

