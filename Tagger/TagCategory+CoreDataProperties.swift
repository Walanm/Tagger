//
//  TagCategory+CoreDataProperties.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/6/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TagCategory {

    @NSManaged var title: String?
    @NSManaged var tags: Tag?

}
