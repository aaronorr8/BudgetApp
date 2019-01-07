//
//  AddBillViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 6/20/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit



extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}



class AddBillViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var billNameTextField: UITextField!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var billDateTextField: UITextField!
    
    
    var amt: Int = 0
    
    
    override func viewDidLayoutSubviews() {
        //billNameTextField.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        billAmountTextField.delegate = self
        billAmountTextField.placeholder = updateAmount()
        //inFocus()
    }
    
    func inFocus() {
        if billNameTextField.isEditing == true {
            billAmountTextField.resignFirstResponder()
        }
    }
    
    func textField(_ textField:UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let digit = Int(string) {
            
            amt = amt * 10 + digit
            
            if amt > 1_000_000_000_00 {
                let alert = UIAlertController(title: "You don't make that much", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
                billAmountTextField.text = ""
                
                amt = 0
                
            } else {
                billAmountTextField.text = updateAmount()
            }
            
            billAmountTextField.text = updateAmount()
        }
        
        if string == "" {
            amt = amt/10
            billAmountTextField.text = amt == 0 ? "" : updateAmount()
        }
        
        return false
    }
    
    func updateAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amount = Double(amt/100) + Double(amt%100)/100
        return formatter.string(from: NSNumber(value: amount))
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        
        billNameG.append(billNameTextField.text!)
        
        let amount = Double(amt/100) + Double(amt%100)/100
        billAmountG.append(amount)
        
        billDateG.append(billDateTextField.text!)
        
        fillOtherArrays()
        
        self.dismiss(animated: true, completion: nil)
        
        //_ = navigationController?.popViewController(animated: true)
           
    }
    
    @IBAction func addAnotherButton(_ sender: Any) {
        billNameG.append(billNameTextField.text!)
        
        let amount = Double(amt/100) + Double(amt%100)/100
        billAmountG.append(amount)
        
        billDateG.append(billDateTextField.text!)
        
        fillOtherArrays()
        
        billNameTextField.text = ""
        billAmountTextField.text = "0.00"
        billDateTextField.text = ""
        billNameTextField.becomeFirstResponder()
        
    }
    
    
    @IBAction func printArraysButton(_ sender: Any) {
        print("billName: \(billNameG)")
        print("billAmount: \(billAmountG)")
        print("billDate: \(billDateG)")
        print("billPaid: \(billPaidG)")
        print("billHistoryAmount: \(billHistoryAmountG)")
        print("billHistoryDate: \(billHistoryDateG)")
        
        //let n = 2.112342349234823423
        //print(n.rounded(toPlaces: 2))
    }
    
    
    
    func fillOtherArrays() {
        //billDate.append("1")
        billPaidG.append(0)
        billHistoryAmountG[billNameTextField.text!] = []
        billHistoryDateG[billNameTextField.text!] = []
    }
    
   
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


