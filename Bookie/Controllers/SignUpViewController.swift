//
//  SignUpViewController.swift
//  Bookie
//
//  Created by Burhan Kaynak on 03/09/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let session = Session()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let displayName = displayNameTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            return
        }
        
        if !password.isEmpty && !confirmPassword.isEmpty {
            if password == confirmPassword {
                session.signUp(email: email, password: password) { [self] result, error in
                    if let error = error {
                        makeAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        performSegue(withIdentifier: B.Segue.signUpToHome, sender: self)
                    }
                    session.setDisplayName(with: displayName)
                }
            } else {
                makeAlert(title: "Error", message: "The passwords are not matching.")
            }
        } else {
            makeAlert(title: "Error", message: "Please enter a valid password")
        }
    }
}
