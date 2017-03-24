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
    

    func configureCell(item: Item)
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.locale = Locale.current
        
        

        title.text = item.title
        
        if let priceString = currencyFormatter.string(from: (item.price as NSNumber)) {
            price.text = priceString
        }
//        price.text = "$\(item.price)"
        desc.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }
}
