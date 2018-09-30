//
//  Article+CoreDataProperties.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var pageid: Int64
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var date: NSDate?

}
