//
//  TableViewCell.swift
//  HowToCustomAnimateCellHeight
//
//  Created by luca silvestro on 25/07/15.
//  Copyright (c) 2015 luca silvestro. All rights reserved.
//  luca.silvestro@gmail.com

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var headerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
