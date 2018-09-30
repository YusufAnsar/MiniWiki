//
//  WikiRouter.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

public enum WikiRouter {
    

    case search(String)
    case getDetail(String, Int64)

    
    // Base endpoint
    static let baseURLString = "https://en.wikipedia.org//w/api.php"
    
    // Set the method
    var method: String {
        return "GET"
    }
    
    var url : URL {
        switch self {
        case .search(let searchTerm):
            let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let urlString = WikiRouter.baseURLString + "?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=20&wbptterms=description&gpssearch=\(encodedSearchTerm ?? "")&gpslimit=10"
            return URL(string: urlString)!
        case .getDetail(let title, _):
            let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let urlString = WikiRouter.baseURLString + "?action=parse&page=\(encodedTitle ?? "")&format=json&prop=text"
            return URL(string: urlString)!
        }
    }
    
    // Construct the request from url, method and parameters
    public func asURLRequest() -> URLRequest {

        // Create request
        var request = URLRequest(url: url)
        // DONE: Set httpMethod
        request.httpMethod = method
        return request
    }
}
