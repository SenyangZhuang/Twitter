//
//  TweetCell.swift
//  Twitter
//
//  Created by Senyang Zhuang on 2/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
   
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    
    @IBOutlet weak var retweetCountButton: UIButton!
    
    @IBOutlet weak var favorButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    
    @IBOutlet weak var favorCountLabel: UILabel!
    
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
