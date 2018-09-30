//
//  SearchItem.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit

class SearchItem: NSObject {
    
    var title: String?
    var pageid: Int64 = 0
    var articleDescription: String?
    var thumbnailImageURLString: String?
    var text: String?
    
    override init() {
        super.init()
    }
    convenience init(with dictionary: [String: Any]) {
        self.init()
        title = dictionary["title"] as? String
        pageid = dictionary["pageid"] as? Int64 ?? 0
        
        if let thumbnailDictionary = dictionary["thumbnail"] as? [String: Any] {
            thumbnailImageURLString = thumbnailDictionary["source"] as? String
        }
        if let termsDictionary = dictionary["terms"] as? [String: Any], let descriptionsArray = termsDictionary["description"] as? [String] {
            articleDescription = descriptionsArray.first
        }
        
    }

}
