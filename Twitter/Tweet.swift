//
//  Tweet.swift
//  Twitter
//
//  Created by Senyang Zhuang on 2/17/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary
    //
    var favorriteCount: Int
    var retweetCount: Int
    var isRetweeted: Bool
    var isLiked: Bool
    var id: Int
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        //retweetCount = dictionary[]
        favorriteCount = self.dictionary["favorite_count"] as! Int
        //print(favorriteCount!)
        retweetCount = self.dictionary["retweet_count"] as! Int
        self.id = self.dictionary["id"] as! Int
        self.isLiked = false
        self.isRetweeted = false
        
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        
        }
        
        return tweets
    }
    
}
