//
//  AddReminderViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 11/16/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit
import UserNotifications

var noteReference = 0 //Used for notification identifier
var noteDay = 0 //used to schedule notification on specific day

class AddReminderViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var reminderNameInput: UITextField!
    @IBOutlet weak var reminderAmountInput: UITextField!
    @IBOutlet weak var dueDateInput: UITextField!
    @IBOutlet weak var selectBudgetField: UITextField!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var repeatSwitchOutlet: UISwitch!
    @IBOutlet weak var notificationSwitchOutlet: UISwitch!
    @IBOutlet weak var reminderLabel1: UILabel!
    @IBOutlet weak var reminderLabel2: UILabel!
    
    
    
    var amt: Int = 0
    var budgets = budgetNameG
    var currentTextField = UITextField()
    var dueDateOptions = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th", "21st", "22nd", "23rd", "24th", "25th", "26th", "27th", "28th"]
//    var dueDateOptions = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28"]
    var repeatSetting = true
    var notificationSetting = true
    
    

    override func viewDidLoad() {
        print("add reminder view loaded")
        printReminders()
        
        
        
        super.viewDidLoad()
        
        print("myIndexG: \(myIndexG)")
        print("notificationIDG: \(notificationIDG)")

        
        //SET NAV APPEARANCE
        setNavigationBarColor()
        
        
        //SET NAV TITLE
        navItem.title = "Add Bill Reminder"
        
        reminderAmountInput.delegate = self
        reminderAmountInput.placeholder = updateAmount()
        
        //SET FIRST RESPONDER
        self.reminderNameInput.becomeFirstResponder()
        
        //SET REPEAT AND NOTIFICATION SETTINGS
        if editModeG == true {
            repeatSetting = reminderRepeatG[myIndexG]
            notificationSetting = reminderNotificationG[myIndexG]
        } else {
            repeatSetting = true
            notificationSetting = false
        }
        
        
        //PICKER VIEW LINKED BUDGET
        let pickerViewLinkedBudget = UIPickerView()
        pickerViewLinkedBudget.delegate = self as UIPickerViewDelegate
        selectBudgetField.inputView = pickerViewLinkedBudget
        
        //CHANGE HEADER IF THERE ARE NO BUDGETS CREATED YET
        budgets.insert("Link to a budget:", at: 0)
        if budgets.count == 1 {
            budgets[0] = "No budgets have been added"
        }
        
        
        //PICKER DUE DATE
        let pickerViewDueDate = UIPickerView()
        pickerViewDueDate.delegate = self as UIPickerViewDelegate
        dueDateInput.inputView = pickerViewDueDate
        
       
        //LOAD PRESETS
        if editModeG != true {
            //SET NAV TITLE
            navItem.title = "Add Reminder"
        } else {
            //SET NAV TITLE (EDIT MODE)
            navItem.title = "Edit Reminder"
            
            //SET DEFAULT VALUES
            selectBudgetField.text = reminderLinkedBudgetG[myIndexG]
            reminderNameInput.text = reminderNameG[myIndexG]
            reminderAmountInput.text = convertDoubleToCurency(amount: reminderAmountG[myIndexG])
            amt = Int(reminderAmountG[myIndexG]) * 100
            
            //ADD "ST", "ND", "RD", "ST" TO DATE
            if reminderDateG[myIndexG] == 0 {
                dueDateInput.text = "1st"
            } else if reminderDateG[myIndexG] == 1 || reminderDateG[myIndexG] == 21 {
                dueDateInput.text = String("\(reminderDateG[myIndexG])st")
            } else if reminderDateG[myIndexG] == 2 || reminderDateG[myIndexG] == 22 {
                dueDateInput.text = String("\(reminderDateG[myIndexG])nd")
            } else if reminderDateG[myIndexG] == 3 || reminderDateG[myIndexG] == 23 {
                dueDateInput.text = String("\(reminderDateG[myIndexG])rd")
            } else {
                dueDateInput.text = String("\(reminderDateG[myIndexG])th")
            }
            
//            dueDateInput.text = String(reminderDateG[myIndexG])
            repeatSwitchOutlet.isOn = reminderRepeatG[myIndexG]
            notificationSwitchOutlet.isOn = reminderNotificationG[myIndexG]
            
            //HIDE OR UNHIDE REMINDER INPUTS
            if reminderNotificationG[myIndexG] == false {
                reminderLabel1.isHidden = true
                reminderLabel2.isHidden = true
                dueDateInput.isHidden = true
            } else {
                reminderLabel1.isHidden = false
                reminderLabel2.isHidden = false
                dueDateInput.isHidden = false
            }

            
            //SET BUTTON TITLE
            saveButton.setTitle("Update", for: .normal)
        }
        
       
    }
    
    
    
    func setNavigationBarColor() {
        navBar.barTintColor = bgColorGradient1
        navBar.isTranslucent = false
        cancelButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        barView.backgroundColor = bgColorGradient1
        view.addSubview(barView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        editModeG = false
        print("editModeG = \(editModeG)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func repeatSwitchButton(_ sender: Any) {
        if (repeatSwitchOutlet.isOn) == true {
            print("Repeat On")
            repeatSetting = true
        } else {
            print("Repeat Off")
            repeatSetting = false
        }
        print(repeatSetting)
    }
    
    @IBAction func notificationSwitchButton(_ sender: Any) {
        if (notificationSwitchOutlet.isOn) == true {
            print("Notification On")
            
            //REQUEST NOTIFICATION PERMISSION
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
                print("not allowed")
            })
            
            notificationSetting = true
            reminderLabel1.isHidden = false
            reminderLabel2.isHidden = false
            dueDateInput.isHidden = false
        } else {
            print("Notification Off")
            notificationSetting = false
            reminderLabel1.isHidden = true
            reminderLabel2.isHidden = true
            dueDateInput.isHidden = true
        }
        print(notificationSetting)
    }
    
    
    
    //MARK: ADD NOTIFICATION
    @IBAction func addReminder(_ sender: Any) {
        
//        #error("Add handler for edit mode")
        
        if editModeG != true {
            print("Adding new reminder")
//EDIT MODE: ON
            //ADD NAME
            if reminderNameInput != nil {
                reminderNameG.append(reminderNameInput.text!)
                
            }

            //ADD AMOUNT
            if reminderAmountInput != nil {
                let amount = Double(amt/100) + Double(amt%100)/100
                reminderAmountG.append(amount)
            }

            //ADD LINKED BUDGET
            if selectBudgetField != nil {
                reminderLinkedBudgetG.append(selectBudgetField.text!)
            } else {
                reminderLinkedBudgetG.append("")
            }

            //ADD DATE
            if dueDateInput != nil {
                if notificationSwitchOutlet.isOn == true {
                    
                    //REMOVE LAST 2 CHARACTERS FROM STRING
                    let tempDay = dueDateInput.text!
                    let modifiedDay = tempDay.dropLast(2)
                    reminderDateG.append(Int(modifiedDay)!)
//                    reminderDateG.append(Int(dueDateInput.text!)!)
                    noteDay = Int(modifiedDay)!
//                    noteDay = Int(dueDateInput.text!)!
                    
                    print("noteDay: \(noteDay)")
                    noteReference = notificationIDG
                    scheduleNotifications()
                } else {
                    reminderDateG.append(0)
                }
            }
            
            //ADD REPEAT SETTING
            reminderRepeatG.append(repeatSetting)
            
            //ADD NOTIFICATION ID
            reminderNoteIDG.append(notificationIDG)
            
            //ADD NOTIFICATION SETTING
            reminderNotificationG.append(notificationSetting)

            //ADD REMINDER STATUS
            reminderDoneG.append(false)
            
//            addSupportingReminderData()
            
            notificationIDG = notificationIDG + 1
            
        } else {
//EDIT MODE: OFF
            
            print("Updating Reminder")
            //UPDATE NAME
            if reminderNameInput != nil {
                reminderNameG[myIndexG] = reminderNameInput.text!
//                self.dismiss(animated: true, completion: nil)
            }
            
            //UPDATE AMOUNT
            if reminderAmountInput != nil {
                let amount = Double(amt/100) + Double(amt%100)/100
                reminderAmountG[myIndexG] = amount
            }
            
            //UPDATE LINKED BUDGET
            if selectBudgetField != nil {
                reminderLinkedBudgetG[myIndexG] = selectBudgetField.text!
            }
          
            //UPDATE DATE
            if dueDateInput != nil {
                if notificationSwitchOutlet.isOn == true {
                    
                    //REMOVE LAST 2 CHARACTERS FROM STRING
                    let tempDay = dueDateInput.text!
                    let modifiedDay = tempDay.dropLast(2)
                    reminderDateG[myIndexG] = (Int(modifiedDay)!)
//                    reminderDateG[myIndexG] = (Int(dueDateInput.text!)!)
                    
                    noteDay = reminderDateG[myIndexG]
                    print("noteDay: \(noteDay)")
                    noteReference = reminderNoteIDG[myIndexG]
                    scheduleNotifications()
                } else {
                    reminderDateG[myIndexG] = 0
                    noteReference = reminderNoteIDG[myIndexG]
                    cancelNotifications()
                }
            }
            
            //UPDATE REPEAT SETTING
            reminderRepeatG[myIndexG] = repeatSetting
            
            // UPDATE NOTIFICATION SETTING
            reminderNotificationG[myIndexG] = notificationSetting
            
            
        }
        
        setReminderDefaults()
        print("Just saved")
        printReminders()
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func addSupportingReminderData() {
//        reminderDoneG.append(false)
//
//    }
    
    
    
    //FORMAT AMOUNT
    func textField(_ textField:UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let digit = Int(string) {
            
            amt = amt * 10 + digit
            
            if amt > 1_000_000_000_00 {
                let alert = UIAlertController(title: "You don't make that much", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
                reminderAmountInput.text = ""
                
                amt = 0
                
            } else {
                reminderAmountInput.text = updateAmount()
            }
            
            reminderAmountInput.text = updateAmount()
        }
        
        if string == "" {
            amt = amt/10
            reminderAmountInput.text = amt == 0 ? "" : updateAmount()
        }
        
        return false
    }
    //FORMAT AMOUNT
    func updateAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let amount = Double(amt/100) + Double(amt%100)/100
        return formatter.string(from: NSNumber(value: amount))
    }
    
    //PICKER VIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if currentTextField == selectBudgetField {
            return 1
//        } else if currentTextField == selectRecurrenceField {
//                return 1
        } else if currentTextField == dueDateInput {
            return 1
        } else {
            return 0
        }
        
    }
    //PICKER VIEW
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == selectBudgetField {
            return budgets.count
//        } else if currentTextField == selectRecurrenceField {
//            return recurrenceOptions.count
        } else if currentTextField == dueDateInput {
            return dueDateOptions.count
        } else {
            return 0
        }
    }
    //PICKER VIEW
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == selectBudgetField {
            return budgets[row]
//        } else if currentTextField == selectRecurrenceField {
//            return recurrenceOptions[row]
        } else if currentTextField == dueDateInput {
            return dueDateOptions[row]
        } else {
            return ""
        }
    }
    //PICKER VIEW
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == selectBudgetField {
            if row == 0 {
                selectBudgetField.text = ""
            } else {
                selectBudgetField.text = budgets[row]
            }
        } else if currentTextField == dueDateInput {
            dueDateInput.text = dueDateOptions[row]
        }
    }

    
    //GET CURRENT TEXT FIELD
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    //SCHEDULE NOTIFICATIONS
    func scheduleNotifications() {
        
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Bill Reminder: \(reminderNameInput.text!)"
        content.subtitle = ""
        content.body = ""
        content.badge = 1
        
        //trigger on a specific date and time
        var dateComponents = DateComponents()
        dateComponents.hour = 8
//        dateComponents.minute = 00
//        dateComponents.weekday = 2
//        dateComponents.second = noteDay
        dateComponents.day = noteDay
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let reference = String(noteReference)
        let noteID = "notificationID\(reference)"
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: noteID, content: content, trigger: trigger)
        
        print("notification request: \(request)")
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    //CANCEL NOTIFICATIONS
    func cancelNotifications() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let reference = noteReference
        let noteID = "notificationID\(reference)"
        print(noteID)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noteID])
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    //USER DEFAULTS
    func setReminderDefaults() {
        defaults.set(reminderNameG, forKey: "ReminderName")
        defaults.set(reminderAmountG, forKey: "ReminderAmount")
        defaults.set(reminderLinkedBudgetG, forKey: "ReminderLinkedBudget")
        defaults.set(reminderDateG, forKey: "ReminderDate")
        defaults.set(reminderDoneG, forKey: "ReminderDone")
        defaults.set(reminderRepeatG, forKey: "ReminderRepeat")
        defaults.set(reminderNotificationG, forKey: "ReminderNotification")
        defaults.set(reminderNoteIDG, forKey: "ReminderNoteID")
        defaults.set(notificationIDG, forKey: "NotificationID")
    }
    
    func printReminders() {
        print("reminderNameG: \(reminderNameG)")
        print("reminderAmountG: \(reminderAmountG)")
        print("reminderLinkedBudgetG: \(reminderLinkedBudgetG)")
        print("reminderDateG: \(reminderDateG)")
        print("reminderDoneG: \(reminderDoneG)")
        print("reminderRepeatG: \(reminderRepeatG)")
        print("reminderNotificationG: \(reminderNotificationG)")
        print("ReminderNoteIDG: \(reminderNoteIDG)")
        print("NotificationIDG: \(notificationIDG)")
    }
    

    
}

