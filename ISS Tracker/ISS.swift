//
//  ISS.swift
//  ISS Tracker
//
//  Created by Mark Bush on 28/03/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class ISS: Satellite {
  private static var tleSourceUrl = "http://spaceflight.nasa.gov/realdata/sightings/SSapplications/Post/JavaSSOP/orbit/ISS/SVPOST.html"
  init?() {
    super.init(name: "ISS", tleSourceUrl: ISS.tleSourceUrl)
  }
}
