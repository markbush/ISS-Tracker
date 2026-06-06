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

  init?(tleSourceUrl: String) {
    guard let url = URL(string: tleSourceUrl) else { return nil }
    guard let content = try? String(contentsOf: url, encoding: .utf8) else {
      print("Failed to load TLE")
      return nil
    }
    let pattern = #/\s+(?<first>1\s+[^\n]+)\s+(?<second>2\s+[^\n]+)/#
    guard let match = try? pattern.firstMatch(in: content) else { return nil }
    tleLine1 = String(match.1)
    tleLine2 = String(match.2)
  }
}
