//
//  ViewController.swift
//  Remainder
//
//  Created by ABDIHAKIN ELMI on 24/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var label: UILabel!
    

    
    var models = [MyRemainders]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didTabAdd(){
        //show add VC

        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
            fatalError("failed to instantiate ViewController ")
        }
        vc.title = "New Remainder"
       
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyRemainders(title: title, date: date, identifier: body)
                self.models.append(new)
                self.label.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
                
                // schedule notification
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
                let dateTrigger = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateTrigger), repeats: false)
                
                let request = UNNotificationRequest(identifier: self.models.description, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
                
                
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        
        guard let vc  = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
            return
        }
        vc.title = model.title
        navigationItem.largeTitleDisplayMode = .always
        vc.labelText = "\(model.date)"
        vc.textViewText = model.identifier
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            tableView.beginUpdates()
            self.models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
            
        }

        let share = UITableViewRowAction(style: .normal, title: "Share") { (action, indexPath) in
            // share item at indexPath
            
            let activityVC = UIActivityViewController(activityItems: [self.models[indexPath.row].title, self.models[indexPath.row].identifier], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.isModalInPresentation = true
            
            self.present(activityVC, animated: true, completion: nil)
        }

        share.backgroundColor = UIColor.blue

        return [delete, share]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            tableView.endUpdates()
        }
    }
    
}
extension ViewController: UITableViewDataSource {
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        
        let date  = models[indexPath.row].date
      
        let formater = DateFormatter()
        formater.timeZone = .current
        formater.locale = .current
        formater.timeStyle = .short
        formater.dateStyle = .short
      
        cell.detailTextLabel?.text = formater.string(from: date)
        return cell
    }
    
    
}

struct MyRemainders {
    let title: String
    let date: Date
    let identifier: String
}
