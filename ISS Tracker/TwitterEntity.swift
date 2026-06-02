//
//  TwitterEntity.swift
//  ISS Tracker
//
//  Created by Mark Bush on 16/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class TwitterEntity {
  var indices: (Int,Int)

  init?(fromDict entityDict: NSDictionary) {
    guard let indicesArray = entityDict[TweetKey.Indices] as? NSArray where indicesArray.count == 2 else { return nil }
    guard let indices = indicesArray as? [Int] else { return nil }
    self.indices = (indices[0], indices[1])
  }
}

class TwitterPic: TwitterEntity, CustomStringConvertible {
  var url: String
  var description: String {
    return "TwitterPic(url: \(url), at: \(indices))"
  }

  override init?(fromDict mediaDict: NSDictionary) {
    guard let url = mediaDict[TweetKey.MediaURL] as? String else { return nil }
    self.url = url
    super.init(fromDict: mediaDict)
  }
}

class TwitterURL: TwitterEntity, CustomStringConvertible {
  var url: String
  var description: String {
    return "TwitterURL(url: \(url), at: \(indices))"
  }

  override init?(fromDict urlDict: NSDictionary) {
    guard let url = urlDict[TweetKey.URL] as? String else { return nil }
    self.url = url
    super.init(fromDict: urlDict)
  }
}
