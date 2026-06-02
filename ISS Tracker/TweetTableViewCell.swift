//
//  TweetTableViewCell.swift
//  ISS Tracker
//
//  Created by Mark Bush on 10/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!

  let dateFormatter:NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.timeZone = NSTimeZone.defaultTimeZone()
    formatter.timeStyle = NSDateFormatterStyle.ShortStyle
    formatter.dateStyle = NSDateFormatterStyle.MediumStyle
    return formatter
  }()
  var twitter: Twitter?
  var tweet: Tweet! {
    didSet {
      updateUI()
    }
  }

  func updateUI() {
    avatarImage?.image = nil
    let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    dispatch_async(queue) {
      self.twitter?.imageDataFromURL(self.tweet.user.avatar) { imageData in
        if imageData != nil {
          dispatch_async(dispatch_get_main_queue()) {
            self.avatarImage?.image = UIImage(data: imageData!)
          }
        }
      }
    }
    nameLabel?.text = tweet.user.name
    usernameLabel?.text = "@" + tweet.user.username
    tweetTextLabel?.text = tweet.text
    timestampLabel?.text = dateFormatter.stringFromDate(tweet.timestamp)
  }
}
