//
//  RemindersViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 11/16/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit
import UserNotifications

class RemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var remindersTableView: UITableView!
    
    var reminderIndex = 0

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = bgColorGradient1
    }

   
    
    override func viewDidAppear(_ animated: Bool) {
        remindersTableView.reloadData()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("clear badge")
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarColor()
        
//        printReminders()
        
        
        
    }
    
    func setNavigationBarColor() {
        navBar.barTintColor = bgColorGradient1
        navBar.isTranslucent = false
        navBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        barView.backgroundColor = bgColorGradient1
        view.addSubview(barView)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderNameG.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RemindersTableViewCell
        
        //DISPLAY NAME
        if reminderRepeatG[indexPath.row] == true {
            cell.reminderNameLabel.text = reminderNameG[indexPath.row]
//            cell.reminderNameLabel.addTextWithImage(text: "\(reminderNameG[indexPath.row]) ", image: #imageLiteral(resourceName: "Repeat On"), imageBehindText: true, keepPreviousText: false)
        } else {
//            cell.reminderNameLabel.text = reminderNameG[indexPath.row]
            cell.reminderNameLabel.addTextWithImage(text: "\(reminderNameG[indexPath.row]) ", image: #imageLiteral(resourceName: "RepeatOff"), imageBehindText: true, keepPreviousText: false)
        }
        
        
        //SET CHECKMARK
        if reminderDoneG[indexPath.row] == false {
            cell.checkmarkImage.image = #imageLiteral(resourceName: "CheckmarkOpen2")
            cell.checkmarkImage.image = cell.checkmarkImage.image?.withRenderingMode(.alwaysTemplate)
            cell.checkmarkImage.tintColor = bgColorGradient1
        } else {
            cell.checkmarkImage.image = #imageLiteral(resourceName: "CheckmarkSolid")
            cell.checkmarkImage.image = cell.checkmarkImage.image?.withRenderingMode(.alwaysTemplate)
            cell.checkmarkImage.tintColor = bgColorGradient1
        }
        
        //DISPLAY AMOUNT
        cell.amountLabel.text = String(convertDoubleToCurency(amount: reminderAmountG[indexPath.row]))
        
        //DISPLAY LINKED BUDGET
        if reminderLinkedBudgetG[indexPath.row] == "" {
//            cell.linkedBudget.isHidden = true
            cell.linkedBudget.text = ""
        } else {
//            cell.linkedBudget.text = "Linked to \"\(reminderLinkedBudgetG[indexPath.row])\""
            cell.linkedBudget.addTextWithImage(text: "\(reminderLinkedBudgetG[indexPath.row])", image: #imageLiteral(resourceName: "HashtagSymbol"), imageBehindText: false, keepPreviousText: false)
        }
        
//        //DISPLAY REMINDER DATE
        if reminderNotificationG[indexPath.row] == true {
            
            //ADD "ST", "ND", "RD", "ST" TO DATE
            var formattedDay = String()
            if reminderDateG[indexPath.row] == 1 || reminderDateG[indexPath.row] == 21 {
                formattedDay = "st"
            } else if reminderDateG[indexPath.row] == 2 || reminderDateG[indexPath.row] == 22 {
                formattedDay = "nd"
            } else if reminderDateG[indexPath.row] == 3 || reminderDateG[indexPath.row] == 23 {
                formattedDay = "rd"
            } else {
                formattedDay = "th"
            }
            
            cell.dueDateLabel.text = "Reminder day: \(reminderDateG[indexPath.row])\(formattedDay)"
            
//            cell.dueDateLabel.addTextWithImage(text: " \(reminderDateG[indexPath.row])\(formattedDay) day of the month", image: #imageLiteral(resourceName: "bell"), imageBehindText: false, keepPreviousText: false)
        } else {
            cell.dueDateLabel.addTextWithImage(text: "", image: #imageLiteral(resourceName: "NotificationOff"), imageBehindText: false, keepPreviousText: false)
        }
        
        
        return cell
    }
    
    
    
    //SET CHECKMARK STATUS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndexG = indexPath.row
        print(myIndexG)
        noteReference = reminderNoteIDG[myIndexG] //used for managing notifications
       
        
        //MARK REMINDER AS DONE
        if reminderDoneG[indexPath.row] == false {
            reminderDoneG[indexPath.row] = true
            
            //DEDUCT FROM LINKED BUDGET
            if reminderLinkedBudgetG[indexPath.row] != "" {
                //OPEN DIALOG
                let alert = UIAlertController(title: "Nice job! Do you want to record this in \"\(reminderLinkedBudgetG[indexPath.row])\"?", message: "You'll have a chance to enter the specific amount spent", preferredStyle: UIAlertControllerStyle.alert)
                
//                alert.addAction(UIAlertAction(title: "Yes, please", style: UIAlertActionStyle.default, handler: { _ in
//                    print("Deduct specific amount")
//                }))
                
                alert.addAction(UIAlertAction(title: "Yes, record in budget", style: UIAlertActionStyle.default, handler: { _ in
                    myIndexG = budgetNameG.index(of: reminderLinkedBudgetG[indexPath.row])!
                    presetAmountG = reminderAmountG[indexPath.row]
                    self.switchViewToAddSpend()
                }))
                
                alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.default, handler: { _ in
                    print("Cancel")
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            cancelNotifications()
            
        } else {
            //MARK REMINDER AS NOT DONE
            reminderDoneG[indexPath.row] = false
            
            //REFUND LINKED BUDGET
            if reminderLinkedBudgetG[indexPath.row] != "" {
                //OPEN DIALOG
                let alert = UIAlertController(title: "Do you want to adjust your \"\(reminderLinkedBudgetG[indexPath.row])\" budget?", message: "You'll have a chance to enter the specific amount.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "No thanks", style: UIAlertActionStyle.default, handler: { _ in
                    print("Cancel")
                }))
                
                alert.addAction(UIAlertAction(title: "Adjust budget", style: UIAlertActionStyle.default, handler: { _ in
                    myIndexG = budgetNameG.index(of: reminderLinkedBudgetG[indexPath.row])!
                    presetAmountG = reminderAmountG[indexPath.row]
                    presetRefundG = true
                    self.switchViewToAddSpend()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            scheduleNotifications()
        }
        
        remindersTableView.reloadData()
        setReminderDefaults()
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //EDIT REMINDER
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.reminderIndex = indexPath.row
            myIndexG = indexPath.row
            editModeG = true
            self.switchViewAddReminder()
            
        }
        
        //DELETE REMINDER
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped for index \(indexPath.row)")
            self.reminderIndex = indexPath.row
            self.deleteReminder()
            self.setReminderDefaults()
            self.printReminders()
            tableView.reloadData()
            
        }
    
        edit.backgroundColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return [edit, delete]
        
    }
    
    func deleteReminder() {
        print(reminderIndex)
        
        noteReference = reminderNoteIDG[reminderIndex]
        cancelNotifications()
        
        reminderNameG.remove(at: reminderIndex)
        reminderDoneG.remove(at: reminderIndex)
        reminderAmountG.remove(at: reminderIndex)
        reminderLinkedBudgetG.remove(at: reminderIndex)
        reminderDateG.remove(at: reminderIndex)
        reminderRepeatG.remove(at: reminderIndex)
        reminderNotificationG.remove(at: reminderIndex)
        reminderNoteIDG.remove(at: reminderIndex)
        
        
        
    }
    
    @objc func switchViewToAddSpend() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddSpendNav")
        self.present(viewController, animated: true)
    }
    
    @objc func switchViewAddReminder() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddReminderNav")
        self.present(viewController, animated: true)
    }
    
    //SCHEDULE NOTIFICATIONS
    func scheduleNotifications() {
        
        //creating the notification content
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = "Bill Reminder: \(reminderNameG[myIndexG])"
        content.subtitle = ""
        content.body = ""
        content.badge = 1
        
        //trigger on a specific date and time
        var dateComponents = DateComponents()
        //        dateComponents.hour = 9
        //        dateComponents.minute = noteDay
        //        dateComponents.weekday = 2
        dateComponents.second = reminderDateG[myIndexG]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let reference = String(noteReference)
        let noteID = "notificationID\(reference)"
        print(noteID)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: noteID, content: content, trigger: trigger)
        
        print("notification request: \(request)")
        
        //adding the notification to notification center
        
        if reminderDateG != [] {
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
    }
    
    //CANCEL NOTIFICATIONS
    func cancelNotifications() {
        let reference = noteReference
        let noteID = "notificationID\(reference)"
        print(noteID)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noteID])
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    func printReminders() {
        print("reminderNameG: \(reminderNameG)")
        print("reminderDoneG: \(reminderDoneG)")
        print("reminderAmountG: \(reminderAmountG)")
        print("reminderLinkedBudgetG: \(reminderLinkedBudgetG)")
        print("reminderDateG: \(reminderDateG)")
        print("reminderRepeatG: \(reminderRepeatG)")
        print("reminderNotificationG: \(reminderNotificationG)")
        print("ReminderNoteID: \(reminderNoteIDG)")
        
    }
    
    //USER DEFAULTS
    func setReminderDefaults() {
        defaults.set(reminderNameG, forKey: "ReminderName")
        defaults.set(reminderDoneG, forKey: "ReminderDone")
        defaults.set(reminderAmountG, forKey: "ReminderAmount")
        defaults.set(reminderLinkedBudgetG, forKey: "ReminderLinkedBudget")
        defaults.set(reminderDateG, forKey: "ReminderDate")
        defaults.set(reminderRepeatG, forKey: "ReminderRepeat")
        defaults.set(reminderNotificationG, forKey: "ReminderNotification")
        defaults.set(reminderNoteIDG, forKey: "ReminderNoteID")
        
    }
    

}

//ADD IMAGE TO LABEL
extension UILabel {
    
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        let lAttachment = NSTextAttachment()
        lAttachment.image = image
        
        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 1.32)
        let lRatio = image.size.width / image.size.height
        
        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)
        
        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }
            
            self.attributedText = lStrLabelText
        }
    }
    
//    func removeImage() {
//        let text = self.text
//        self.attributedText = nil
//        self.text = text
//    }
}
