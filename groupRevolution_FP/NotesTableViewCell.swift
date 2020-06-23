//
//  NotesTableViewCell.swift
//  groupRevolution_FP
//
//  Created by Syed Nooruddin Fahad on 23/06/20.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import CoreData
import UIKit

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
