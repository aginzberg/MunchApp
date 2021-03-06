//
//  UserClaim+CoreDataProperties.swift
//  Munch
//
//  Created by Adam Ginzberg on 3/16/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserClaim {

    @NSManaged var claim_time: NSDate?
    @NSManaged var is_redeemed: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var promotion: Promotion?

}
