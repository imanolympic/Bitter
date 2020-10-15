//
//  CreateTweetViewController.swift
//  Twitter
//
//  Created by Theron Mansilla on 10/14/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController {
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBAction func cancelTweet(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetContent: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                print("Error in posting tweet \(Error)")
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.becomeFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
