//
//  DialogTableViewCell.swift
//  TinkoffChat
//
//  Created by  User on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

class DialogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

}
