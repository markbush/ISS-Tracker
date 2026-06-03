//
//  Vec3.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct Vec3: CustomStringConvertible {
  var x = 0.0
  var y = 0.0
  var z = 0.0
  func scaledBy(_ scale: Double) -> Vec3 {
    let scaledX = self.x * scale
    let scaledY = self.y * scale
    let scaledZ = self.z * scale
    return Vec3(x: scaledX, y: scaledY, z: scaledZ)
  }
  func length() -> Double {
    return sqrt((x * x) + (y * y) + (z * z))
  }
  var description: String {
    return "Vec3(\(x), \(y), \(z))"
  }
}
