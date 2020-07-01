//
//  AlertController.swift
//  SimpleToDo
//
//  Created by Pavel Parshin on 01.07.2020.
//  Copyright © 2020 Pavel Parshin. All rights reserved.
//

import UIKit

extension TaskListViewController {
    
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    func showEditAlert(with title: String, and message: String, for indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Edit", style: .default) { _ in
            guard let newTask = alert.textFields?.first?.text, !newTask.isEmpty else { return }
            self.editTask(task, with: indexPath, to: newTask)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.text = task.name
        }
        
        present(alert, animated: true)
    }
}
