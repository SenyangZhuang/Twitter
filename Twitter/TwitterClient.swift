//
//  TwitterClient.swift
//  Twitter
//
//  Created by Senyang Zhuang on 2/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking


let twitterConsumerKey = "5YLp19evuctBqah6NDk5mZsSr"
let twitterConsumerSecret = "lVMsv1BWVqE9JfTrJ2yAeFGaQ6yMhFwuN3CEwDTWLhdPs5fNKM"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient{
        struct Static{
            static  let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("homeline \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed in getting my homeline")
            completion(tweets: nil, error: error)
        })
    
    
    }
    
    func postHasNotBeenRetweeted(id: Int?, completion: (error: NSError?) -> ()){
        let sid = String(id!)
        //print("https://api.twitter.com/1.1/statuses/retweet/\(sid).json")
        POST("1.1/statuses/retweet/\(sid).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("homeline \(response)")
           //var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed in posting my retweet count")
                print(error)
                completion(error: error)
        })
    
        
    }
    
    func postHasBeenRetweeted(id: Int?, completion: (error: NSError?) -> ()){
        let sid = String(id!)
        //print("https://api.twitter.com/1.1/statuses/retweet/\(sid).json")
        POST("1.1/statuses/unretweet/\(sid).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("homeline \(response)")
            //var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed in posting my retweet count")
                print(error)
                completion(error: error)
        })
    }
    
    func postHasNotBeenLiked(id: Int?, completion: (error: NSError?) -> ()){
        let sid = String(id!)
        POST("1.1/favorites/create.json?id=\(sid)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed in posting my retweet count")
                print(error)
                completion(error: error)
        })
    }
    
    func postHasBeenLiked(id: Int?, completion: (error: NSError?) -> ()){
        let sid = String(id!)
        POST("1.1/favorites/destroy.json?id=\(sid)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed in posting my retweet count")
                print(error)
                completion(error: error)
        })
    }
    
    
    
//    func postHomeTimeLineWithParams(id: String, params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) ->()){
//        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//            var tweet = Tweet(dictionary: response as! NSDictionary)
//            completion(tweet: tweet, error: nil)
//            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
//                
//                print("retweet error\(error)")
//                completion(tweet: nil, error: error)
//                
//        }
//    }

    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Sucessfully got the token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get the token")
                self.loginCompletion?(user: nil, error: error)
        }
    
    
    }
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:
            BDBOAuth1Credential!) -> Void in
            print("Successfully received the token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("user \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                //print("user \(user.name)")
                self.loginCompletion!(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print(error)
                })
            }) { (error: NSError!) -> Void in
                print(error)
                self.loginCompletion?(user: nil, error: error)
            }
    }
}
