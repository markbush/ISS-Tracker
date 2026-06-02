//
//  CrewMemberViewController.swift
//  ISS Tracker
//
//  Created by Mark Bush on 09/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

class CrewMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var crewImageView: UIImageView! {
    didSet {
      crewImageView.backgroundColor = UIColor.clearColor()
      crewImageView.layer.masksToBounds = true
      crewImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
  }
  @IBOutlet weak var flagImageView: UIImageView! {
    didSet {
      flagImageView.backgroundColor = UIColor.clearColor()
      flagImageView.layer.masksToBounds = true
      flagImageView.contentMode = UIViewContentMode.ScaleAspectFit
    }
  }
  @IBOutlet weak var arrivalLabel: UILabel!
  @IBOutlet weak var departureLabel: UILabel!
  @IBOutlet weak var twitterFeed: UITableView! {
    didSet {
      twitterFeed.delegate = self
      twitterFeed.dataSource = self
    }
  }

  var dateFormatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    formatter.timeZone = NSTimeZone(abbreviation: "GMT")
    return formatter
  }()

  var crewMember: CrewMember? {
    didSet {
      tweets = []
    }
  }
  var twitter = Twitter(key: MyApp.TwitterKey, secret: MyApp.TwitterSecret)
  var tweets = [Tweet]() {
    didSet {
      twitterFeed?.reloadData()
    }
  }

  func updateUI() {
    guard crewMember != nil else { return }
    nameLabel?.text = crewMember?.name
    if let imageUrl = crewMember?.imageUrl {
      let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
      dispatch_async(queue) {
        if let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!) {
          dispatch_async(dispatch_get_main_queue()) {
            self.crewImageView?.image = UIImage(data: imageData)
          }
        }
      }
    }
    if let nationality = crewMember?.nationality,
      let flagImage = UIImage(named: nationality) {
      self.flagImageView?.image = flagImage
    }
    self.arrivalLabel?.text = (crewMember?.arrives == nil) ? nil : dateFormatter.stringFromDate(crewMember!.arrives!)
    self.departureLabel?.text = (crewMember?.departs == nil) ? nil : dateFormatter.stringFromDate(crewMember!.departs!)
    loadTweets()
  }

  func loadTweets() {
    guard crewMember != nil else { return }
    if let twitterName = crewMember!.twitterHandle {
      let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
      dispatch_async(queue) {
        self.twitter.tweetsForUser(twitterName) { newTweets in
          dispatch_async(dispatch_get_main_queue()) {
            self.tweets = newTweets
          }
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if let rowHeight = twitterFeed?.rowHeight {
      twitterFeed?.estimatedRowHeight = rowHeight
    }
    twitterFeed?.rowHeight = UITableViewAutomaticDimension
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if crewMember == nil {
      crewMember = CrewMember.issItem
    }
    updateUI()
  }

  // MARK: - Table view data source

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let tweet = tweets[indexPath.row]

    if tweet.images.count > 1 {
      let cell = tableView.dequeueReusableCellWithIdentifier("Tweet Two Image", forIndexPath: indexPath) as! TweetTwoImageTableViewCell
      cell.twitter = twitter
      cell.tweet = tweet
      return cell
    } else if tweet.images.count > 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("Tweet Image", forIndexPath: indexPath) as! TweetImageTableViewCell
      cell.twitter = twitter
      cell.tweet = tweet
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("Tweet No Image", forIndexPath: indexPath) as! TweetTableViewCell
      cell.twitter = twitter
      cell.tweet = tweet
      return cell
    }
  }
}
