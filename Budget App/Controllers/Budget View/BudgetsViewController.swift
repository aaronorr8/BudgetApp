    //
//  BudgetsViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 7/10/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit
import Firebase

    //COLORS
    let colorTrackH = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
    let colorRedH = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    let colorGreenH = #colorLiteral(red: 0.2549019608, green: 0.4588235294, blue: 0.01960784314, alpha: 1)
    
    let colorTrackC = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
    let colorRedC = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    let colorGreenC = #colorLiteral(red: 0.2549019608, green: 0.4588235294, blue: 0.01960784314, alpha: 1)
    
    let bgColorSolid = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    let bgColorGradient1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let bgColorGradient2 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let cellBackground = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
class BudgetsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var gradientLayer: CAGradientLayer!
    var roundButton = UIButton()
    var totalBudgetsAllocation = 0.0
    var totalBudgetsAvailable = 0.0
    var amt: Int = 0
    
    //MARK: FOR HEADER WHEN SCROLLING
//    let duration = 0.3
//    let offset = scrollView.contentOffset.y
    let hiddenBgColor = UIColor.clear
    let visibleBgColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let hiddenTitleColor = UIColor.clear
    let visibleTitleColor = UIColor.black
    var hideNav = Bool()
    
    //MARK: PROGRESS BAR SCALE
    let xScale = CGFloat(1.0)
    let yScale = CGFloat(3.0)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.clear]
        
        
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom:15, right: 0)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(BudgetsViewController.handleLongGesture))
        self.collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fireStoreListener()
        
        //MARK: HIDE NAVIGATION BAR
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
       
        
        //MARK: SET BACKGROUND COLOR
        createGradientLayer()
        //self.view.backgroundColor = bgColorSolid
        
        //self.tabBarController?.navigationItem.title = "Profile Settings"
        
        //MARK: SHOW VISIBLE NAV BAR WHEN RETURNING TO VIEW IF SCROLLED
        if hideNav == false {
            self.navigationController?.navigationBar.backgroundColor = self.visibleBgColor
            UIApplication.shared.statusBarView?.backgroundColor = self.visibleBgColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: self.visibleTitleColor]
            self.navigationController?.navigationBar.tintColor = self.visibleTitleColor
            self.navigationController?.navigationBar.shadowImage = UIImage(named: "shadowImage")
            UIApplication.shared.statusBarStyle = .default
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.backgroundColor = UIColor.clear
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        createUserDefaults()
//        collectionView.reloadData()
        calculateTotalAvailable()
        calculateTotalAllocation()
        
        let amount = Double(amt/100) + Double(amt%100)/100
        self.navigationItem.title = String(convertDoubleToCurency(amount: totalBudgetsAvailable))
        
    }
    
   
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [bgColorGradient1.cgColor, bgColorGradient2.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        let duration = 0.3
        let offset = scrollView.contentOffset.y
        
        if offset > -25 {
            hideNav = false
        } else {
            hideNav = true
        }
    
        if hideNav == true {
        
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.navigationBar.backgroundColor = self.hiddenBgColor
                UIApplication.shared.statusBarStyle = .lightContent
                UIApplication.shared.statusBarView?.backgroundColor = self.hiddenBgColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: self.hiddenTitleColor]
                self.navigationController?.navigationBar.tintColor = self.hiddenTitleColor
                self.navigationController?.navigationBar.shadowImage = UIImage()
                
            })
        
        } else {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.navigationBar.backgroundColor = self.visibleBgColor
                UIApplication.shared.statusBarStyle = .default
                UIApplication.shared.statusBarView?.backgroundColor = self.visibleBgColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: self.visibleTitleColor]
                self.navigationController?.navigationBar.tintColor = self.visibleTitleColor
                self.navigationController?.navigationBar.shadowImage = UIImage(named: "shadowImage")
                
            })
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if budgetNameG.count == 0 {
            return 1
        } else {
        
        return budgetNameG.count
        }
    }
    
    //MARK: COLLECTION HEADER/FOOTER
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! BudgetCollectionReusableView
        
            
            //MARK: HEADER TOTAL REMAINING
            let amount = Double(amt/100) + Double(amt%100)/100
            headerView.totalRemainingBudget.text = String(convertDoubleToCurency(amount: totalBudgetsAvailable))
            
            
            //MARK: HEADER PROGRESS BAR
            let progress = totalSpentG/totalBudgetsAllocation
            
            headerView.wavyProgress.trackColor = colorTrackH
            
            if progress <= 1 {
                headerView.wavyProgress.progressColor = colorGreenH
            } else if progress > 1 {
                headerView.wavyProgress.progressColor = colorRedH
            }
            
            headerView.wavyProgress.setProgressWithAnimation(duration: 1.0, value: Float(progress))
            
           //MARK: HEADER PROGRESS BAR LABELS
            
            var headerSpentTotal = String(convertDoubleToCurency(amount: totalSpentG))
            var headerTotalAvailable = String(convertDoubleToCurency(amount: totalBudgetsAllocation))
            
            headerView.progressSpentLabel.text = "\(headerSpentTotal) spent"
            headerView.progressTotalLabel.text = "\(headerTotalAvailable) total budgets"
            
            return headerView
        
        //MARK: COLLECTION FOOTER
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as! FooterBudgetCollectionView
 
            
            return footerView
            
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
    func addNewBudget(sender: UIButton) {
        print("It Works!")
    }
    
    
    //MARK: HIDE ADD BUDGET BUTTON IF EMPTY
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if budgetNameG.count == 0 {
            return CGSize.zero
        } else {
        
        return CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.08)
        }

    }
    
    //MARK: COLLECTION CELLS
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BudgetCollectionViewCell
        let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCell", for: indexPath) as! BudgetCollectionViewCell
        
        if budgetNameG.count == 0 {
            return emptyCell
        } else {
        
        
        //MARK: CELL DESIGN
        cell.backgroundColor = cellBackground
        
        //MARK: CELL VIEW LABELS
        cell.budgetNameLabel.text = budgetNameG[indexPath.row]
        cell.budgetRemainingLabel.text = "\(String(convertDoubleToCurency(amount: budgetRemainingG[indexPath.row])))"
//        cell.budgetRemainingLabel.text = "\(String(convertDoubleToCurency(amount: budgetAmountG[indexPath.row] - (budgetHistoryAmountG[budgetNameG[indexPath.row]]!.reduce(0, +)))))"
        
        
        //MARK: PROGRESS BAR LABELS
        let selectedBudget = budgetNameG[indexPath.row]
        let amountSpentInd = budgetHistoryAmountG[selectedBudget]?.reduce(0, +)
        cell.progressTotalLabel.text = "\(String(convertDoubleToCurency(amount: amountSpentInd!))) of \(String(convertDoubleToCurency(amount: budgetAmountG[indexPath.row]))) spent"
        
        cell.progressCircle.trackColor = colorTrackC
        
        let cellProgress = Float(amountSpentInd!/budgetAmountG[indexPath.row])
        
        if cellProgress <= 1 {
            cell.progressCircle.progressColor = colorGreenC
        } else if cellProgress > 1 {
            cell.progressCircle.progressColor = colorRedC
        }
        
        cell.progressCircle.setProgressWithAnimation(duration: 0.5, value: cellProgress)
        
        return cell
        
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if budgetNameG.count == 0 {
            print("Empty")
        } else {
        
        myIndexG = indexPath.row
        
        switchView()
        print(myIndexG)
        }
    }
    

    func calculateTotalAvailable() {
        
//        let amount = Double(amt/100) + Double(amt%100)/100
//        totalBudgetsAvailable = budgetRemainingG.reduce(0, +)
        
        let array = Array(budgetHistoryAmountG.values)
        let flatArray = array.flatMap {$0}
        let history = flatArray.reduce(0, +)
        let budgets = budgetAmountG.reduce(0, +)
        totalBudgetsAvailable = budgets - history
    
    }
    
    func calculateTotalAllocation() {
        
        totalBudgetsAllocation = budgetAmountG.reduce(0, +)
        print("totalBudgetAllocation: \(totalBudgetsAllocation)")
    }
    
    
    //MARK: REARRANGE BUDGETS
     func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item = budgetNameG[sourceIndexPath.row]
        budgetNameG.remove(at: sourceIndexPath.row)
        budgetNameG.insert(item, at: destinationIndexPath.row)
        
        let item2 = budgetAmountG[sourceIndexPath.row]
        budgetAmountG.remove(at: sourceIndexPath.row)
        budgetAmountG.insert(item2, at: destinationIndexPath.row)
        
        let item3 = budgetRemainingG[sourceIndexPath.row]
        budgetRemainingG.remove(at: sourceIndexPath.row)
        budgetRemainingG.insert(item3, at: destinationIndexPath.row)
        
//        setUserDefaults()
        saveToFireStore()
        
    }
   
    
    func addNewBudgetHandler(alert: UIAlertAction) {
        //let newView = AddBillViewController()
        //self.navigationController?.pushViewController(newView, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditBudget")
        self.present(viewController, animated: true)
    }
    
   
    //MARK: GESTURE RECOGNIZER
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer)
    {
        switch(gesture.state)
        {
            
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else
            {
                break
            }
            
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case .changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        case .ended:
            self.collectionView.endInteractiveMovement()
            
        default:
            self.collectionView.cancelInteractiveMovement()
        }
    }
   
    @objc func switchView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddSpendNav")
        self.present(viewController, animated: true)
        
        print("tap")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if roundButton.superview != nil {
            DispatchQueue.main.async {
                self.roundButton.removeFromSuperview()
                
            }
        }
    }
    
   
    
    
    
    
    //MARK: Create UserDefaults
    func createUserDefaults() {
        if UserDefaults.standard.object(forKey: "BudgetName") != nil {
            budgetNameG = defaults.object(forKey: "BudgetName") as! [String]
            print("User Defaults budgetNameG: \(defaults.object(forKey: "BudgetName") as! [String])")
        }
        if UserDefaults.standard.object(forKey: "BudgetAmount") != nil {
            budgetAmountG = defaults.object(forKey: "BudgetAmount") as! [Double]
            print("User Defaults budgetAmountG: \(defaults.object(forKey: "BudgetAmount") as! [Double])")
        }
        if UserDefaults.standard.object(forKey: "BudgetHistoryAmount") != nil {
            budgetHistoryAmountG = defaults.object(forKey: "BudgetHistoryAmount") as! [String: [Double]]
            print("User Defaults budgetHistoryAmountG: \(defaults.object(forKey: "BudgetHistoryAmount") as! [String: [Double]])")
        }
        if UserDefaults.standard.object(forKey: "BudgetHistoryDate") != nil {
            budgetHistoryDateG = defaults.object(forKey: "BudgetHistoryDate") as! [String: [String]]
            print("User Defaults budgetHistoryDateG: \(defaults.object(forKey: "BudgetHistoryDate") as! [String: [String]])")
        }
        if UserDefaults.standard.object(forKey: "BudgetHistoryTime") != nil {
            budgetHistoryTimeG = defaults.object(forKey: "BudgetHistoryTime") as! [String: [String]]
            print("User Defaults budgetHistoryTimeG: \(defaults.object(forKey: "BudgetHistoryTime") as! [String: [String]])")
        }
        if UserDefaults.standard.object(forKey: "BudgetRemaining") != nil {
            budgetRemainingG = defaults.object(forKey: "BudgetRemaining") as! [Double]
            print("User Defaults budgetRemainingG: \(defaults.object(forKey: "BudgetRemaining") as! [Double])")
        }
        if UserDefaults.standard.object(forKey: "TotalSpent") != nil {
            totalSpentG = defaults.object(forKey: "TotalSpent") as! Double
            print("User Defaults totalSpentG: \(defaults.object(forKey: "TotalSpent") as! Double)")
        }
        if UserDefaults.standard.object(forKey: "BudgetNote") != nil {
            budgetNoteG = defaults.object(forKey: "BudgetNote") as! [String: [String]]
            print("User Defaults budgetNoteG: \(defaults.object(forKey: "BudgetNote") as! [String: [String]])")
        }
        if UserDefaults.standard.object(forKey: "Rollover") != nil {
            rolloverG = defaults.object(forKey: "Rollover") as! Bool
            print("User Defaults rolloverG: \(defaults.object(forKey: "Rollover") as! Bool)")
        }
        if UserDefaults.standard.object(forKey: "RolloverTotal") != nil {
            rolloverTotalG = defaults.object(forKey: "RolloverTotal") as! Double
            print("User Defaults rolloverTotalG: \(defaults.object(forKey: "RolloverTotal") as! Double)")
        }
//        if UserDefaults.standard.object(forKey: "ReminderName") != nil {
//            reminderNameG = defaults.object(forKey: "ReminderName") as! [String]
//            print("User Defaults ReminderName: \(defaults.object(forKey: "ReminderName") as! [String])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderDone") != nil {
//            reminderDoneG = defaults.object(forKey: "ReminderDone") as! [Bool]
//            print("User Defaults ReminderDone: \(defaults.object(forKey: "ReminderDone") as! [Bool])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderAmount") != nil {
//            reminderAmountG = defaults.object(forKey: "ReminderAmount") as! [Double]
//            print("User Defaults ReminderAmount: \(defaults.object(forKey: "ReminderAmount") as! [Double])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderLinkedBudget") != nil {
//            reminderLinkedBudgetG = defaults.object(forKey: "ReminderLinkedBudget") as! [String]
//            print("User Defaults ReminderLinkedBudget: \(defaults.object(forKey: "ReminderLinkedBudget") as! [String])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderDate") != nil {
//            reminderDateG = defaults.object(forKey: "ReminderDate") as! [Int]
//            print("User Defaults ReminderDate: \(defaults.object(forKey: "ReminderDate") as! [Int])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderRepeat") != nil {
//            reminderRepeatG = defaults.object(forKey: "ReminderRepeat") as! [Bool]
//            print("User Defaults ReminderRepeat: \(defaults.object(forKey: "ReminderRepeat") as! [Bool])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderNotification") != nil {
//            reminderNotificationG = defaults.object(forKey: "ReminderNotification") as! [Bool]
//            print("User Defaults ReminderNotification: \(defaults.object(forKey: "ReminderNotification") as! [Bool])")
//        }
//        if UserDefaults.standard.object(forKey: "ReminderNoteID") != nil {
//            reminderNoteIDG = defaults.object(forKey: "ReminderNoteID") as! [Int]
//            print("User Defaults ReminderNoteID: \(defaults.object(forKey: "ReminderNoteID") as! [Int])")
//        }
        if UserDefaults.standard.object(forKey: "NotificationID") != nil {
            notificationIDG = defaults.object(forKey: "NotificationID") as! Int
            print("User Defaults NotificationID: \(defaults.object(forKey: "NotificationID") as! Int)")
        }
        if UserDefaults.standard.object(forKey: "MonthlyResetNotificationSetting") != nil {
            monthlyResetNotificationSetting = defaults.object(forKey: "MonthlyResetNotificationSetting") as! Bool
            print("User Defaults MonthlyResetNotificationSetting: \(defaults.object(forKey: "MonthlyResetNotificationSetting") as! Bool)")
        }
        
        
    }
    
    //MARK: Save to FireStore
    func saveToFireStore() {
        
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("budgets").document(userID).setData([
                "budgetName": budgetNameG,
                "budgetAmount": budgetAmountG,
                "budgetHistoryAmount": budgetHistoryAmountG,
                "budgetNote": budgetNoteG,
                "budgetHistoryDate": budgetHistoryDateG,
                "budgetHistoryTime": budgetHistoryTimeG,
                "budgetRemaining": budgetRemainingG,
                "totalSpent": totalSpentG
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.calculateTotalAvailable()
                }
            }
        }
    }
    
    //MARK: FireStore Listener
    func fireStoreListener() {
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("budgets").document(userID)
                .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    budgetNameG = document.get("budgetName") as! [String]
                    budgetAmountG = document.get("budgetAmount") as! [Double]
                    budgetHistoryAmountG = document.get("budgetHistoryAmount") as! [String : [Double]]
                    budgetNoteG = document.get("budgetNote") as! [String : [String]]
                    budgetHistoryDateG = document.get("budgetHistoryDate") as! [String : [String]]
                    budgetHistoryTimeG = document.get("budgetHistoryTime") as! [String : [String]]
                    budgetRemainingG = document.get("budgetRemaining") as! [Double]
                    totalSpentG = document.get("totalSpent") as! Double
                    
                    print("Current data: \(data)")
                    
                    self.collectionView.reloadData()
                    self.calculateTotalAvailable()
                    self.calculateTotalAllocation()
                    
            }
        }
    }
    
    
    
    func setUserDefaults() {
        defaults.set(budgetNameG, forKey: "BudgetName")
        defaults.set(budgetAmountG, forKey: "BudgetAmount")
        defaults.set(budgetHistoryAmountG, forKey: "BudgetHistoryAmount")
        defaults.set(budgetRemainingG, forKey: "BudgetRemaining")
        defaults.set(budgetHistoryDateG, forKey: "BudgetHistoryDate")
        defaults.set(budgetHistoryTimeG, forKey: "BudgetHistoryTime")
        defaults.set(budgetNoteG, forKey: "BudgetNote")
        defaults.set(rolloverG, forKey: "Rollover")
        defaults.set(rolloverTotalG, forKey: "RolloverTotal")
        defaults.set(monthlyResetNotificationSetting, forKey: "MonthlyResetNotificationSetting")
        
       
    }
    
    
    

}
