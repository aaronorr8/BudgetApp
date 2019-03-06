//
//  SignInUpViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 3/1/19.
//  Copyright © 2019 Icecream. All rights reserved.
//

import UIKit
import Firebase

class SignInUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var signUpInsteadOutlet: UIButton!
    @IBOutlet weak var logInSignInLabel: UILabel!
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    override func viewDidLayoutSubviews() {
        
        emailField.setLeftPaddingPoints(10)
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordField.setLeftPaddingPoints(10)
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //MARK: SignIn Button Tapped
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        startSpinner()
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error != nil {
                self.stopSpinner()
                self.loginAlert()
                print(error)

            } else {
                self.stopSpinner()
                self.dismiss(animated: true, completion: nil)
                print("Login successful!!")
            }
        }

        self.view.endEditing(true)
    }
    
    //MARK: Sign Up/In Button
   
    
    
    @objc func keyboardWillChange(notification: Notification) {
        print("Keyboard will show: \(notification.name.rawValue)")
        
        guard let keybaordRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        //Get space between bottom button and bottom of screen
        let spaceAfterLastButton = view.frame.height - signUpInsteadOutlet.frame.size.height/2 - signUpInsteadOutlet.frame.origin.y
        print("space between bottom and button: \(spaceAfterLastButton)")
        print("keyboard height: \(keybaordRect.height)")
        
        let distance = spaceAfterLastButton -  keybaordRect.height
        print("distance: \(distance)")
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name
            == Notification.Name.UIKeyboardWillChangeFrame {
//            view.frame.origin.y = -keybaordRect.height
            if distance < 0 {
                view.frame.origin.y = distance
            } else {
                view.frame.origin.y = 0
            }
           
        } else {
            view.frame.origin.y = 0
        }
        
        
    }
    
    func hideKeyboard() {
        passwordField.resignFirstResponder()
    }
    
    
    func loginAlert() {
        let alert = UIAlertController(title: "Oops! Wrong email or password, try again.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    func startSpinner() {
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopSpinner() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    


}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
