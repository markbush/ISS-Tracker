//
//  ISS.swift
//  ISS Tracker
//
//  Created by Mark Bush on 28/03/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class ISS: Satellite {
  static let issHorizon = 1.60934e6

  private static var tleSourceUrl = "http://live.ariss.org/iss.txt"
  init?() {
    super.init(name: "ISS", tleSourceUrl: ISS.tleSourceUrl)
  }
}
