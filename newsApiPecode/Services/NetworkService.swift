//
//  NetworkService.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation

struct QueryParameter {
    var key: String
    var value: String
    var stringRepresentation: String {
        return key + "=" + value
    }
}

class NetworkService {
    
    public static let shared = NetworkService()
    
    private var articles = [Article]()
    
    public func getArticles(params: [QueryParameter], isFilters: Bool, isNeedToBeSorted: Bool, completion: (([Article]?, Error?) -> Void )?) {
        
        var baseUrl = "https://newsapi.org/v2/top-headlines?"
        
        if params.isEmpty {
            baseUrl = "https://newsapi.org/v2/top-headlines?q=world&apiKey=263a34d6549a4d1da2dafd47ff9d4859"
        } else {
            
            var temp  = ""
            
            for value in params {
                temp += "\(value.stringRepresentation)&"
            }
            
            if isNeedToBeSorted {
                temp += "sortBy=publishedAt&"
            }
            baseUrl += temp + "apiKey=263a34d6549a4d1da2dafd47ff9d4859"
        }
        
        baseUrl = baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        guard let url = URL(string: baseUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {return}
            do {
                let decoder = JSONDecoder()
                let articleResponce = try? decoder.decode(Articles.self, from: data)
                self.articles = articleResponce!.articles
                
                completion?(self.articles, nil)
            }
        }.resume()
    }
}
