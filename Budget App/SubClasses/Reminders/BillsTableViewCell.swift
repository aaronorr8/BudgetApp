//
//  BillsTableViewCell.swift
//  Budget App
//
//  Created by Aaron Orr on 6/27/18.
//  Copyright © 2018 Icecream. All rights reserved.
//

import UIKit

class BillsTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var billNameLabel: UILabel!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var billDueDateLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
