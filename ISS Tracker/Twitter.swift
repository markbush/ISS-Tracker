//
//  Twitter.swift
//  ISS Tracker
//
//  Created by Mark Bush on 10/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct TwitterUrl {
  static let Base = "https://api.twitter.com"
  static let AuthToken = "\(Base)/oauth2/token"
  static let Search = "\(Base)/1.1/search/tweets.json"
  static let Lookup = "\(Base)/1.1/statuses/lookup.json"
}

struct TwitterKey {
  static let Grant = "grant_type"
  static let Token = "access_token"
  static let Query = "q"
  static let Entities = "include_entities"
  static let ResultType = "result_type"
  static let Tweets = "statuses"
  static let IdStr = "id_str"
  static let Id = "id"
}

struct TweetKey {
  static let Text = "text"
  static let Timestamp = "created_at"
  static let Entities = "entities"
  static let ExtendedEntities = "extended_entities"
  static let Media = "media"
  static let URLs = "urls"
  static let MediaType = "type"
  static let URL = "expanded_url"
  static let MediaURL = "media_url_https"
  static let Indices = "indices"
  static let User = "user"
  static let AvatarURL = "profile_image_url"
  static let Name = "name"
  static let ScreenName = "screen_name"
}

class Twitter {
  static var tweetCache = [String:(NSDate,[Tweet])]()
  static let cacheTimeout = 1.0 * 60.0 * 60.0 // One hour
  private let apiKey: String
  private let apiSecret: String
  private var token: String?

  private var apiHeaders: [String:String] {
    return ["Authorization":"Bearer \(self.token!)"]
  }

  init(key: String, secret: String) {
    self.apiKey = key
    self.apiSecret = secret
  }

  func isAuthenticated() -> Bool {
    return token != nil
  }

  private func authenticate(callback: Bool -> Void) {
    guard token == nil else {
      callback(true)
      return
    }
    let encodedKey = apiKey.urlEncoded()
    let encodedSecret = apiSecret.urlEncoded()
    let credentials = "\(encodedKey):\(encodedSecret)"
    guard let base64Credentials = credentials.asBase64String() else { return }
    let headers = ["Authorization":"Basic \(base64Credentials)", "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"]
    let parameters = [TwitterKey.Grant:"client_credentials"]
    HTTPFetcher.post(TwitterUrl.AuthToken, headers: headers, parameters: parameters) { json in
      if let resultDict = json as? NSDictionary, let authToken = resultDict[TwitterKey.Token] {
        self.token = authToken as? String
        callback(true)
      } else {
        callback(false)
      }
    }
  }

  func tweetsForUser(username: String, callback: [Tweet] -> Void) {
    if let (date, tweets) = Twitter.tweetCache[username] where fabs(date.timeIntervalSinceNow) < Twitter.cacheTimeout {
      callback(tweets)
      return
    }
    self.authenticate { authenticated in
      guard authenticated else {
        callback([])
        return
      }
      let search = "from:\(username)"
      let parameters = [TwitterKey.Query:search, TwitterKey.ResultType:"recent", TwitterKey.Entities:"true"]
      HTTPFetcher.get(TwitterUrl.Search, headers: self.apiHeaders, parameters: parameters) { jsonResults in
        var ids = [String]()
        if let resultDict = jsonResults as? NSDictionary, let rawTweets = resultDict[TwitterKey.Tweets] as? NSArray {
          for rawTweet in rawTweets {
            if let tweetDict = rawTweet as? NSDictionary {
              if let id = tweetDict[TwitterKey.IdStr] as? String {
                ids.append(id)
              }
            }
          }
        }
        if ids.count > 0 {
          self.tweetsWithIds(ids) { tweets in
            Twitter.tweetCache[username] = (NSDate(), tweets)
            callback(tweets)
          }
        }
      }
    }
  }

  func tweetsWithIds(ids: [String], callback: [Tweet] -> Void) {
    self.authenticate { authenticated in
      guard authenticated else {
        callback([])
        return
      }
      let parameters = [TwitterKey.Id:ids.joinWithSeparator(","), TwitterKey.Entities:"true"]
      HTTPFetcher.get(TwitterUrl.Lookup, headers: self.apiHeaders, parameters: parameters) { jsonResults in
        if let rawTweets = jsonResults as? NSArray {
          var tweets = [Tweet]()
          for rawTweet in rawTweets {
            if let tweetDict = rawTweet as? NSDictionary {
              if let tweet = Tweet(fromDict: tweetDict) {
                tweets.append(tweet)
              }
            }
          }
          tweets = tweets.sort({ $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })
          callback(tweets)
        }
      }
    }
  }

  func imageDataFromURL(url: String, callback: NSData? -> Void) {
    self.authenticate { authenticated in
      guard authenticated else {
        callback(nil)
        return
      }
      HTTPFetcher.get(url, headers: self.apiHeaders) { result in
        if let imageData = result as? NSData {
          callback(imageData)
        } else {
          callback(nil)
        }
      }
    }
  }
}
