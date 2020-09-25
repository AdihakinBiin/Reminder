//
//  AddViewController.swift
//  Remainder
//
//  Created by ABDIHAKIN ELMI on 24/09/20.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    
    // completion takes the data to the next controller
    
    public var completion: ((String, String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTabSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTabCancel))
       
        titleField.becomeFirstResponder()
    }
    
    @objc func didTabSave(){
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text {
        
            let targetDate = datePicker.date
            completion?(titleText, bodyText, targetDate)
        }
    }
    
    @objc func didTabCancel(){
        if let title = titleField.text, title.isEmpty {
            //display the root view controller
            navigationController?.popToRootViewController(animated: true)
        } else {
            // actionSheet
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
     
         let deleteAction = UIAlertAction(title: "Discard Changes", style: .destructive) { success in
             self.navigationController?.popToRootViewController(animated: true)
         }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            optionMenu.addAction(deleteAction)
            optionMenu.addAction(cancelAction)

            self.present(optionMenu, animated: true, completion: nil)
        }
    }
 

}
