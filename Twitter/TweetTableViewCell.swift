//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Theron Mansilla on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userTweetLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoiteButtonPressed(_ sender: Any) {
        if (self.favorited) {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: self.tweetID, success: {
                self.favoriteButton.tintColor = UIColor.lightGray
                self.favorited = false
            }, failure: { (Error) in
                print("Unfavoriting failed \(Error)")
            })
        } else {
            TwitterAPICaller.client?.favoriteTweet(tweetID: self.tweetID, success: {
                self.favoriteButton.tintColor = UIColor.red
                self.favorited = true
            }, failure: { (Error) in
                print("Favoriting failed \(Error)")
            })
        }
    }
    
    @IBAction func retweetButtonPressed(_ sender: Any) {
        TwitterAPICaller.client?.retweetTweet(tweetID: self.tweetID, success: {
            self.isRetweed = true
            self.retweetButton.isEnabled = false
        }, failure: { (Error) in
            print("Error in retweeting \(Error)")
        })
    }
    
    var favorited:Bool = false
    var isRetweed:Bool = false
    var tweetID:Int = -1
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = .none
    }
    
    func setFavorited(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favoriteButton.tintColor = UIColor.red
        }
    }
    
    func setRetweeted(_ retweeted:Bool) {
        self.isRetweed = retweeted
        self.retweetButton.setImage(UIImage(named: "retweet-green"), for: .disabled)
        if (self.isRetweed) {
            self.retweetButton.isEnabled = false
            self.isRetweed = true
        } else {
            self.retweetButton.isEnabled = true
        }
    }
}
