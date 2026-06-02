//
//  SatelliteElementSet.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class SatelliteElementSet: CustomStringConvertible {
  private static var toDegrees = 180.0 / M_PI
  private static var toRadians = M_PI / 180.0
  private static var twoPi = 2.0 * M_PI

  var argPerigeeDeg: Double!
  var argPerigee: Double!
  var drag: Double!
  var eccentricity: Double!
  var elementSetNumber: Int!
  var ephemerisType: Int!
  var epoch: Double!
  var inclinationDeg: Double!
  var inclination: Double!
  var internationalDesignator: String!
  var meanAnomolyDeg: Double!
  var meanAnomoly: Double!
  var meanMotion: Double!
  var name: String!
  var decay: Double!
  var revolutionNumber: Int!
  var rightAscensionDeg: Double!
  var rightAscension: Double!
  var satelliteClassification: String!
  var satelliteId: Int!

  var description: String {
    return "SatelliteElementSet for \(name)"
  }

  init?(name: String, line1: String, line2: String) {
    self.name = name
    if !line1IsValid(line1) {
      return nil
    }
    if !line2IsValid(line2) {
      return nil
    }
    let id1 = line1.from(2, to: 6)
    let id2 = line2.from(2, to: 6)
    if id1 != id2 {
      return nil
    }
  }

  private func line1IsValid(line: String) -> Bool {
    if line.characters.count < 68 { return false }
    if line.from(1, to: 1) != "1" { return false }
    self.satelliteId = Int(line.from(3, to: 7).trim())
    let classification = line.from(8, to: 8)
    if !["U", "C", "S", "T"].contains(classification) { return false }
    self.satelliteClassification = classification
    self.internationalDesignator = line.from(10, to: 17)
    guard var epochYear = Int(line.from(19, to: 20).trim()) else { return false }
    if epochYear < 57 { epochYear += 100 }
    epochYear += 1900
    guard let epochDay = Double(line.from(21, to: 32).trim()) else { return false }
    self.epoch = MJD.mjdFromMonths(1, days: epochDay, years: epochYear)
    self.decay = Double(line.from(34, to: 43).trim())
    if self.decay == nil { return false }
    let fracPart = line.from(55, to: 59).trim()
    let exponent = line.from(60, to: 61).trim()
    let dragStr = "."+fracPart+"e"+exponent
    self.drag = Double(dragStr.trim())
    if self.drag == nil { return false }
    if line.from(54, to: 54) == "-" {
      self.drag = -self.drag
    }
    let ephemerisTypeStr = line.from(63, to: 63)
    if ephemerisTypeStr == " " { return false }
    self.ephemerisType = Int(ephemerisTypeStr)
    if self.ephemerisType == nil { return false }
    self.elementSetNumber = Int(line.from(65, to: 68).trim())
    if self.elementSetNumber == nil { return false }
    return SatelliteElementSet.validChecksum(line)
  }
  private func line2IsValid(line: String) -> Bool {
    if line.characters.count < 68 { return false }
    if line.from(1, to: 1) != "2" { return false }
    guard let inclinationDeg = Double(line.from(9, to: 16).trim()) else { return false }
    if inclinationDeg < 0 || inclinationDeg > 180 { return false }
    self.inclinationDeg = inclinationDeg
    self.inclination = inclinationDeg * SatelliteElementSet.toRadians
    guard let rightAscensionDeg = Double(line.from(18, to: 25).trim()) else { return false }
    if rightAscensionDeg < 0 || rightAscensionDeg > 360 { return false }
    self.rightAscensionDeg = rightAscensionDeg
    self.rightAscension = rightAscensionDeg * SatelliteElementSet.toRadians
    guard let eccentricityMultiplier = Double(line.from(27, to: 33)) else { return false }
    self.eccentricity = eccentricityMultiplier * 1e-7
    if self.eccentricity == nil || self.eccentricity < 0 || self.eccentricity >= 1.0 { return false }
    guard let argPerigeeDeg = Double(line.from(35, to: 42).trim()) else { return false }
    if argPerigeeDeg < 0 || argPerigeeDeg > 360 { return false }
    self.argPerigeeDeg = argPerigeeDeg
    self.argPerigee = argPerigeeDeg * SatelliteElementSet.toRadians
    guard let meanAnomolyDeg = Double(line.from(44, to: 51).trim()) else { return false }
    if meanAnomolyDeg < 0 || meanAnomolyDeg > 360 { return false }
    self.meanAnomolyDeg = meanAnomolyDeg
    self.meanAnomoly = meanAnomolyDeg * SatelliteElementSet.toRadians
    self.meanMotion = Double(line.from(53, to: 63).trim())
    if self.meanMotion == nil || self.meanMotion > 17 { return false }
    self.revolutionNumber = Int(line.from(64, to: 68).trim())
    if self.revolutionNumber == nil { return false }
    return SatelliteElementSet.validChecksum(line)
  }
  private static func validChecksum(line: String) -> Bool {
    guard line.characters.count >= 69 else { return true }
    guard let checksum = Int(line.from(69, to: 69)) else { return true }
    let values = line.from(1, to: 68).characters.map {
      String($0) == "-" ? 1 : (Int(String($0)) ?? 0)
    }
    // Ignore last value which is the checksum!
    let sum = values.reduce(0, combine: +)
    let validChecksum = sum % 10
    return checksum == validChecksum
  }
}
