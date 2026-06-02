//
//  CrewMember.swift
//  ISS Tracker
//
//  Created by Mark Bush on 09/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct CrewMember {
  static let issItem = CrewMember(name: "ISS", nationality: "International", twitterHandle: "Space_Station", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/International_Space_Station_after_undocking_of_STS-132.jpg/1024px-International_Space_Station_after_undocking_of_STS-132.jpg", arrives: NSDate(dateString: "20-11-1998"), departs: nil)
  var name: String?
  var nationality: String?
  var twitterHandle: String?
  var imageUrl: String?
  var arrives: NSDate?
  var departs: NSDate?
}
