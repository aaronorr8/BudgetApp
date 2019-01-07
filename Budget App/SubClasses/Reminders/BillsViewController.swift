//
//  BillsViewController.swift
//  Budget App
//
//  Created by Aaron Orr on 6/27/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit


class BillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var billsTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        billsTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        billsTableView.delegate = self
        billsTableView.dataSource = self
       
    }
    
   
    
    
    @IBAction func addBillButton(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billNameG.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BillsTableViewCell
        
        cell.billNameLabel.text = billNameG[indexPath.row]
        cell.billAmountLabel.text = String(convertDoubleToCurency(amount: billAmountG[indexPath.row]))
        cell.billDueDateLabel.text = "Due on June \(billDateG[indexPath.row])"
        
        return cell
    }
    

    

    
   
    
    @objc func switchView() {
        //let newView = AddBillViewController()
        //self.navigationController?.pushViewController(newView, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddReminderNav")
        self.present(viewController, animated: true)
        
        print("tap")
    }
    

}
