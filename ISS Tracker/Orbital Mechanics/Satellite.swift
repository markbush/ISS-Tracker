//
//  Satellite.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class Satellite {
  private static let earthRadius: Double = 6.37816e6
  private static let earthRadiusKM: Double = earthRadius / 1000.0
  private static let siderialSolar = 1.0027379093
  private static let earthFlattening = 1.0 / 298.25
  private let tleSourceUrl: String
  private var elementSet: SatelliteElementSet!
  private var lastTLEUpdate = Date()
  let name: String
  var position = Vec3()
  var velocity = Vec3()
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  var height: Double = 0.0

  init?(name: String, tleSourceUrl: String) {
    self.name = name
    self.tleSourceUrl = tleSourceUrl
    guard let tleReader = TleReader(tleSourceUrl: tleSourceUrl) else { return nil }
    self.elementSet = SatelliteElementSet(name: name, line1: tleReader.tleLine1, line2: tleReader.tleLine2)
    if self.elementSet == nil {
      return nil
    }
  }

  func update() -> Bool {
    return self.updateForDate(Date())
  }

  @discardableResult func updateForDate(_ date: Date) -> Bool {
    if fabs(lastTLEUpdate.timeIntervalSinceNow) > (24.0 * 60.0 * 60.0) {
      if let tleReader = TleReader(tleSourceUrl: tleSourceUrl) {
        self.elementSet = SatelliteElementSet(name: name, line1: tleReader.tleLine1, line2: tleReader.tleLine2)
        lastTLEUpdate = Date()
      } else {
        return false
      }
    }
    let minutesPerDay = 24.0 * 60
    var (years, days) = MJD.yearsDaysFromMjd(elementSet.epoch)
    years -= 1900
    days += 1.0
    var satElem = SatelliteElements()
    satElem.epoch = (1000.0 * Double(years)) + days
    satElem.xno = elementSet.meanMotion * (2.0 * .pi / minutesPerDay)
    satElem.xincl = elementSet.inclination
    satElem.xnodeo = elementSet.rightAscension
    satElem.eo = elementSet.eccentricity
    satElem.omegao = elementSet.argPerigee
    satElem.xmo = elementSet.meanAnomoly
    satElem.bstar = elementSet.drag
    satElem.xndt20 = elementSet.decay * (2.0 * .pi / minutesPerDay / minutesPerDay)

    let mjd = MJD.mjdFromDate(date)
    let dt = (mjd - elementSet.epoch) * minutesPerDay
    let (position, velocity) = (satElem.xno >= (1.0/225.0)) ? satElem.sgp4(dt) : satElem.sdp4(dt)
    self.position = position.scaledBy(Satellite.earthRadiusKM)
    self.velocity = velocity.scaledBy(Satellite.earthRadiusKM / 60.0)
    let currentTime = mjd + 0.5
    let sidDay = floor(currentTime)
    let t = (floor(sidDay) - 0.5) / 36525.0
    let t2 = t * t
    let ref = (6.6460656 + (2400.051262 * t) + (0.00002581 * t2)) / 24.0
    let sidReference = ref - floor(ref)
    var longitudeRad = (2.0 * .pi * (((currentTime - sidDay) * Satellite.siderialSolar) + sidReference)) - atan2(self.position.y, self.position.x)
    let longOffset = 2.0 * .pi * floor(longitudeRad / (2.0 * .pi))
    longitudeRad = longitudeRad - longOffset
    if longitudeRad > .pi {
      longitudeRad = longitudeRad - (2.0 * .pi)
    }
    self.longitude = (-longitudeRad) * 180.0 / .pi
    let lattitudeRad = atan(self.position.z / (sqrt(pow(self.position.x, 2.0) + pow(self.position.y, 2.0))))
    self.latitude = lattitudeRad * 180.0 / .pi
    let r = sqrt(pow(self.position.x, 2.0) + pow(self.position.y, 2.0) + pow(self.position.z, 2.0))
    let earthFlatSqr = pow(Satellite.earthFlattening, 2.0)
    let sinLatSqr = pow(sin(lattitudeRad), 2.0)
    self.height = r - Satellite.earthRadiusKM * (sqrt(1.0 - (2.0 * Satellite.earthFlattening - earthFlatSqr) * sinLatSqr))
    return true
  }
}
