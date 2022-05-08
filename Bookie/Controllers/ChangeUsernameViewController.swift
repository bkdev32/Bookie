//
//  ChangeUsernameViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 03/09/2021.
//

import UIKit

class ChangeUsernameViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    let session = Session()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeUsernameButton(_ sender: UIButton) {
        if let newDisplayName = usernameTextField.text {
            session.setDisplayName(with: newDisplayName)
            makeAlert(title: "Success", message: "You have successfully changed your username", popToVC: true)
            usernameTextField.text = ""
        } else {
            makeAlert(title: "Error", message: "Please enter a valid username")
        }
    }
}
