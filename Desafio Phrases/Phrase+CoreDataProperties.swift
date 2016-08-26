//
//  Phrase+CoreDataProperties.swift
//  Desafio Phrases
//
//  Created by Luciano Almeida on 2/13/16.
//  Copyright © 2016 Luciano Almeida. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Phrase {

    @NSManaged var text: String?

}
