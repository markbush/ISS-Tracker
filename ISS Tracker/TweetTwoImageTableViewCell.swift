//
//  TweetTwoImageTableViewCell.swift
//  ISS Tracker
//
//  Created by Mark Bush on 16/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

class TweetTwoImageTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var displayImage: UIImageView!
  @IBOutlet weak var displayImage2: UIImageView!

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
    displayImage?.image = nil
    let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    dispatch_async(queue) {
      self.twitter?.imageDataFromURL(self.tweet.user.avatar) { imageData in
        if imageData != nil {
          dispatch_async(dispatch_get_main_queue()) {
            self.avatarImage?.image = UIImage(data: imageData!)
          }
        }
      }
      if let imageURL = NSURL(string: self.tweet.images[0].url), let imageData = NSData(contentsOfURL: imageURL) {
        dispatch_async(dispatch_get_main_queue()) {
          self.displayImage?.image = UIImage(data: imageData)
          self.displayImage?.layer.masksToBounds = true
        }
      }
      if let imageURL = NSURL(string: self.tweet.images[1].url), let imageData = NSData(contentsOfURL: imageURL) {
        dispatch_async(dispatch_get_main_queue()) {
          self.displayImage2?.image = UIImage(data: imageData)
          self.displayImage2?.layer.masksToBounds = true
        }
      }
    }
    nameLabel?.text = tweet.user.name
    usernameLabel?.text = "@" + tweet.user.username
    tweetTextLabel?.text = tweet.text
    timestampLabel?.text = dateFormatter.stringFromDate(tweet.timestamp)
  }
}
