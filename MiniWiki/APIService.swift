//
//  APIService.swift
//  MiniWiki
//
//  Created by Yusuf Ansar on 30/09/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import Foundation

enum Result <T>{
    case Success(T)
    case Error(String)
}

class APIService: NSObject {
    
    static let shared = APIService()
    
    private override init() {}
    
    func search(term: String, completion: @escaping ([SearchItem]?, String?) -> Void) {
        
        let request = WikiRouter.search(term).asURLRequest()
        self.getData(for: request) { (data, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any] {
                        guard let queries = json["query"] as? [String: AnyObject], let pages = queries["pages"] as? [AnyObject] else {  return  }
                        var searchItemsArray = [SearchItem]()
                        for dict in pages {
                            let searchItem = SearchItem.init(with:dict as! [String : Any])
                            searchItemsArray.append(searchItem)
                        }
                        DispatchQueue.main.async {
                            completion(searchItemsArray, nil)
                        }
                    }
                } catch {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
        
    }
    
    func fetchSearchItemDetail(for searchItem: SearchItem, completion: @escaping (String?, String?) -> Void) {
        
        let request = WikiRouter.getDetail(searchItem.title ?? "", searchItem.pageid).asURLRequest()
        self.getData(for: request) { (data, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any] {
                        guard let parsedText = json["parse"] as? [String: Any], let text = parsedText["text"] as? [String: Any] else {
                            return completion(nil, nil)
                        }
                        let htmlDescription = text["*"] as? String
                        DispatchQueue.main.async {
                            completion(htmlDescription, nil)
                        }
                    }
   
                } catch {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
        
    }
    
    private func getData(for request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }.resume()

    }
}
