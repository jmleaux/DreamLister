//
//  ItemCell.swift
//  Dreamlister
//
//  Created by J. M. Lowe on 2/25/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        desc.text = item.details
        
    }
}
