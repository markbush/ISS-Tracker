//
//  TLEReader.swift
//  ISS Tracker
//
//  Created by Mark Bush on 28/03/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class TleReader {
  var tleLine1: String!
  var tleLine2: String!

  init?(name: String, tleSourceUrl: String) {
    guard let url = NSURL(string: tleSourceUrl) else { return nil }
    guard let content = try? String(contentsOfURL: url) else { return nil }
    let nsString = content as NSString
    let pattern = "TWO LINE MEAN ELEMENT SET\\s+\(name)\\s+(1\\s+[^\\n]+)\\s+(2\\s+[^\\n]+)"
    let now = NSDate()
    if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
      let matches = regex.matchesInString(content, options: [], range: NSMakeRange(0, nsString.length))
      for match in matches {
        if match.numberOfRanges > 2 {
          let thisLine = nsString.substringWithRange(match.rangeAtIndex(1))
          let year = 2000 + Int(thisLine.from(19, to: 20))!
          let days = Double(thisLine.from(21, to: 32))!
          let date = NSDate(dateString: "1-1-\(year)")
          let seconds = date.timeIntervalSince1970 + (days * 86400)
          if seconds > now.timeIntervalSince1970 && tleLine1 != nil {
            break
          }
          tleLine1 = thisLine
          tleLine2 = nsString.substringWithRange(match.rangeAtIndex(2))
        }
      }
    }
    if self.tleLine1 == nil || self.tleLine2 == nil {
      return nil
    }
  }
}
