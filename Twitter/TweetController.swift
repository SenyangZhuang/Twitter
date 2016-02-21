//
//  TweetController.swift
//  Twitter
//
//  Created by Senyang Zhuang on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking


class TweetController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var cureent_user = User.currentUser
    var tweets = [Tweet]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion:{(tweets, error) -> () in
            if let tweets = tweets{
                self.tweets = tweets
            }
              self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion:{(tweets, error) -> () in
            if let tweets = tweets{
                self.tweets = tweets
            }
            self.tableView.reloadData()
        })
       
        refreshControl.endRefreshing()
    }

    
    @IBAction func onLogoutClicked(sender: AnyObject) {
       cureent_user = nil
        self.dismissViewControllerAnimated(true, completion: {});
    }
    @IBAction func likeButtonOnClick(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TweetCell {
                    let indexPath = self.tableView.indexPathForCell(cell)
                    let tweet = tweets[indexPath!.row]
                    if tweet.isLiked == false{
                        TwitterClient.sharedInstance.postHasNotBeenLiked(tweet.id, completion:{(error) -> () in
                            if error != nil{
                                tweet.favorriteCount += 1
                                button.setImage(UIImage(named:"like"),forState:UIControlState.Normal)
                                tweet.isLiked = true
                            }
                            self.tableView.reloadData()
                        })
                    }else{
                        TwitterClient.sharedInstance.postHasBeenLiked(tweet.id, completion:{(error) -> () in
                            if error != nil{
                                tweet.favorriteCount -= 1
                                button.setImage(UIImage(named:"unliked"),forState:UIControlState.Normal)
                                tweet.isLiked = false
                            }
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
        
    }
    
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: NSDate(), options: []).hour
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetOnClick(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TweetCell {
                    let indexPath = self.tableView.indexPathForCell(cell)
                    let tweet = tweets[indexPath!.row]
                    if tweet.isRetweeted == false{
                        TwitterClient.sharedInstance.postHasNotBeenRetweeted(tweet.id, completion:{(error) -> () in
                        if error != nil{
                                tweet.retweetCount += 1
                            button.setImage(UIImage(named:"retweet"),forState:UIControlState.Normal)
                            tweet.isRetweeted = true
                        }
                        self.tableView.reloadData()
                    })
                    }else{
                        TwitterClient.sharedInstance.postHasBeenRetweeted(tweet.id, completion:{(error) -> () in
                            if error != nil{
                                tweet.retweetCount -= 1
                                button.setImage(UIImage(named:"unretweeted"),forState:UIControlState.Normal)
                                tweet.isRetweeted = false
                            }
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        let user = tweet.user
        let imagePath = user?.profileImageUrl!
        let url = NSURL(string: imagePath!)
        cell.profileImageView.setImageWithURL(url!)
        let screenname = (user?.screenname)!
        cell.screennameLabel.text = "@\(screenname)"
        let username = (user?.name)!
        cell.usernameLabel.text = username
        cell.contentLabel.text = tweet.text
        cell.retweetCountLabel.text! = String(tweet.retweetCount)
        cell.favorCountLabel.text! = String(tweet.favorriteCount)
        let hourInterval = self.hoursFrom(tweets[indexPath.row].createdAt!)
        cell.timeStampLabel.text = "\(hourInterval)h"
        //print(self.hoursFrom(tweets[indexPath.row].createdAt!))
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
