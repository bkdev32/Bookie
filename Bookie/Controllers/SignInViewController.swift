//
//  SignInViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 03/09/2021.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let session = Session()
    var dismissVC = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signInButton(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            session.signIn(email, password) { [self] result, error in
                if let error = error {
                    makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    if dismissVC {
                        dismiss(animated: true, completion: nil)
                    } else {
                        performSegue(withIdentifier: B.Segue.signInToHome, sender: self)
                    }
                }
            }
        } else {
            makeAlert(title: "Error", message: "Please enter a valid email address and password")
        }
    }
}
