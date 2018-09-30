//
//  Article+CoreDataClass.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Article)
public class Article: NSManagedObject {
    
    class func createArticleEntity(from searchItem: SearchItem) -> Article {
        let article = NSEntityDescription.insertNewObject(forEntityName: "Article", into: CoreDataStack.sharedInstance.persistentContainer.viewContext) as! Article
        article.title = searchItem.title
        article.pageid = searchItem.pageid
        article.articleDescription = searchItem.articleDescription
        article.text = searchItem.text
        article.date = NSDate()
        return article
    }

}
