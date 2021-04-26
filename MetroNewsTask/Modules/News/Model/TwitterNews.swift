//
//  TwitterNews.swift
//  MetroNewsTask
//
//  Created by Roman Khodukin on 26.04.2021.
//

import SwiftyJSON

struct Response {
    let success: Bool
    let data: [Tweet]
}

struct Tweet {
    let id: Int
    let text: String
    let createdAt: Int
    let retweetCount: Int
    let favoriteCount: Int
    let mediaEntities: [String]
    
    init?(json: JSON) {
        let mediaEntities = json["mediaEntities"].arrayValue.map({ $0.stringValue })
        
        guard
            let id = json["id"].int,
            let text = json["text"].string,
            let createdAt = json["createdAt"].int,
            let retweetCount = json["retweetCount"].int,
            let favoriteCount = json["favoriteCount"].int
        else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.createdAt = createdAt
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.mediaEntities = mediaEntities
    }
}
