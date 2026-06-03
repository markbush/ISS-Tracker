//
//  MJD.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

class MJD {
  static func isLeapYear(_ year: Int) -> Bool {
    return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
  }
  static func mjdFromMonths(_ months: Int, days: Double, years: Int) -> Double {
    var m = months
    var y = years < 0 ? years - 1 : years
    if months < 3 {
      m += 12
      y -= 1
    }
    var b = 0
    if !(years < 1582 || (years == 1582 && (months < 10 || (months == 10 && days < 15)))) {
      let a = years / 100
      b = 2 - a + (a/4)
    }
    let adj = y < 0 ? 0.75 : 0.0
    let c = Int((365.25 * Double(y)) - adj) - 694025
    let d = Int(30.6001 * Double((m + 1)))
    return Double(b) + Double(c) + Double(d) + days - 0.5
  }
  static func monthsDaysYearsFromMjd(_ mjd: Double) -> (months: Int, days: Double, years: Int) {
    var months = 0
    var days = 0.0
    var years = 0
    if (mjd == 0) { return (12, 31.5, 1899) }
    let d = mjd + 0.5
    var i = floor(d)
    var f = d - i
    if (f == 1) {
      f = 0
      i += 1
    }
    if i > -115860.0 {
      let a = floor((i / 36524.25) + 0.99835726) + 14
      i += 1 + a - floor(a / 4.0)
    }
    let b = floor((i / 365.25) + 0.802601)
    let ce = i - floor((365.25 * b) + 0.750001) + 416
    let g = floor(ce / 30.6001)
    months = Int(g - 1)
    days = ce - floor(30.6001 * g) + f
    years = Int(b + 1899)
    if g > 13.5 { months = Int(g - 13) }
    if months < 3 { years = Int(b + 1900) }
    if years < 1 { years -= 1 }
    return (months, days, years)
  }
  static func yearFromMjd(_ mjd: Double) -> Double {
    var (_, _, years) = monthsDaysYearsFromMjd(mjd)
    if years == -1 { years = -2 }
    let e0 = mjdFromMonths(1, days: 1.0, years: years)
    let e1 = mjdFromMonths(1, days: 1.0, years: years + 1)
    let year = Double(years) + ((mjd - e0) / (e1 - e0))
    return year
  }
  static func yearsDaysFromMjd(_ mjd: Double) -> (years: Int, days: Double) {
    let year = yearFromMjd(mjd)
    let years = Int(year)
    let daysPerYear = isLeapYear(years) ? 366.0 : 365.0
    let days = daysPerYear * (year - Double(years))
    return (years, days)
  }
  static func mjdFromDate(_ date: Date) -> Double {
    return 25567.5 + date.timeIntervalSince1970/3600.0/24.0
  }
  static func mjdFromNow() -> Double {
    let now = Date()
    return mjdFromDate(now)
  }
}
