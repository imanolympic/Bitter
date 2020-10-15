//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Theron Mansilla on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    @IBAction func logoutBarItemTapped(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    let myRefreshControl = UIRefreshControl()
    
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadTweets()
    }
    
    @objc func loadTweets() {
        numberOfTweets = 20
        let twitterAPIURL:String = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["Count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterAPIURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (error) in
            print("Could not retreive tweets! Oh no..")
        })
        
    }
    
    func loadMoreTweets() {
        print("loading more")
        let twitterAPIURL:String = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 5
        let myParams = ["Count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: twitterAPIURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (error) in
            print("Could not retreive tweets! Oh no..")
        })
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        let userName:String = user["name"] as! String
        cell.userNameLabel.text = userName
        
        let userProfileImageURL = URL(string: (user["profile_image_url_https"] as! String))!
        let data = try? Data(contentsOf: userProfileImageURL)
        
        if let imageData = data {
            cell.userProfileImageView.image = UIImage(data: imageData)
        }
        
        let tweetContent:String = tweetArray[indexPath.row]["text"] as! String
        cell.userTweetLabel.text = tweetContent
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        print(tweetArray[indexPath.row])
        cell.tweetID = tweetArray[indexPath.row]["id"] as! Int
        
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
  
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("willDisplay")
//        print(tweetArray.count)
//        if indexPath.row + 1 == tweetArray.count {
//            loadMoreTweets()
//        }
//    }
}
