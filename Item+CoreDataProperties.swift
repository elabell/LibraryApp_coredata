//
//  Item+CoreDataProperties.swift
//  LibraryApp_coredata
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemCore> {
        return NSFetchRequest<ItemCore>(entityName: "ItemCore")
    }

    @NSManaged public var text: String?
    @NSManaged public var checked: Bool
    @NSManaged public var photo: NSData?

}
