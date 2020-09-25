//
//  EditViewController.swift
//  Remainder
//
//  Created by ABDIHAKIN ELMI on 25/09/20.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet var textView: UITextView!
    
    public var labelText: String = ""
    public var textViewText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = labelText
        textView.text = textViewText
    }


}
