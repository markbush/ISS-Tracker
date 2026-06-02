//
//  Tweet.swift
//  ISS Tracker
//
//  Created by Mark Bush on 10/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct TweetUser {
  let name: String
  let username: String
  let avatar: String

  init?(fromDict userDict: NSDictionary) {
    guard let name = userDict[TweetKey.Name] as? String else { return nil }
    self.name = name
    guard let username = userDict[TweetKey.ScreenName] as? String else { return nil }
    self.username = username
    guard let avatar = userDict[TweetKey.AvatarURL] as? String else { return nil }
    self.avatar = avatar
  }
}

class Tweet: CustomStringConvertible {
  let user: TweetUser
  let rawText: String
  let text: String
  let timestamp: NSDate
  var images = [TwitterPic]()
  var urls = [TwitterURL]()
  var description: String {
    return "Tweet(text: \"\(text)\", images: \(images), urls: \(urls))"
  }

  init?(fromDict tweetDict: NSDictionary) {
    guard let timestamp = (tweetDict[TweetKey.Timestamp] as? String)?.dateFromTwitterDateString() else { return nil }
    self.timestamp = timestamp
    guard let rawText = tweetDict[TweetKey.Text] as? String else { return nil }
    self.rawText = rawText
    guard let userDict = tweetDict[TweetKey.User] as? NSDictionary else { return nil }
    guard let user = TweetUser(fromDict: userDict) else { return nil }
    self.user = user
    var text = rawText
    if let entities = tweetDict[TweetKey.ExtendedEntities] as? NSDictionary {
      if let mediaItems = entities[TweetKey.Media] as? NSArray {
        for mediaItem in mediaItems {
          if let mediaDict = mediaItem as? NSDictionary {
            if let mediaType = mediaDict[TweetKey.MediaType] as? String where mediaType == "photo" {
              if let media = TwitterPic(fromDict: mediaDict) {
                images.append(media)
              }
            }
          }
        }
      }
    }
    if let entities = tweetDict[TweetKey.Entities] as? NSDictionary {
      if let urlItems = entities[TweetKey.URLs] as? NSArray {
        for urlItem in urlItems {
          if let urlDict = urlItem as? NSDictionary {
            if let url = TwitterURL(fromDict: urlDict) {
              urls.append(url)
            }
          }
        }
      }
      var items: [TwitterEntity] = self.images
      items = items + self.urls
      let sortedEntities = items.sort( { $0.indices.1 > $1.indices.1 } )
      for entity in sortedEntities {
        if text.characters.count >= entity.indices.1 {
          text.remove(entity.indices.0, to: entity.indices.1)
        }
      }
    }
    self.text = text.decodeHTML()
  }
}
