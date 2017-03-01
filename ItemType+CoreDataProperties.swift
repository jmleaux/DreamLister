//
//  ItemType+CoreDataProperties.swift
//  Dreamlister
//
//  Created by J. M. Lowe on 3/1/17.
//  Copyright © 2017 JMLeaux LLC. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
