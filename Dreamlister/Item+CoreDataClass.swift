//
//  Item+CoreDataClass.swift
//  Dreamlister
//
//  Created by J. M. Lowe on 2/25/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
        
    }
}
