//
//  Item_extension.swift
//  Dreamlister
//
//  Created by J. M. Lowe on 2/26/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    // assign date on create
//    public override func awakeFromInsert() {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
}
