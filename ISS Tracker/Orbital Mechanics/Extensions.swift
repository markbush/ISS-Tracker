//
//  Extensions.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct DateConstants {
  static let VernalEquinoxDay = 80
  static let SummerSolsticeDay = 173
  static let AutumnalEquinox = 267
  static let WinterSolstice = 357
  static let MaxDaysInYear = 366
}

extension Date {
  init(dateString:String) {
    let dateStringFormatter = DateFormatter()
    dateStringFormatter.dateFormat = "dd-MM-yyyy"
    dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateStringFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let d = dateStringFormatter.date(from: dateString)!
    self.init(timeInterval:0, since:d)
  }
  func sunLongitude() -> Double {
    let cal = Calendar.current
    let secInDay = cal.ordinality(of: .second, in: .day, for: self) ?? 0
    let hours = Double(secInDay) / (60.0 * 60.0)
    let angle = hours * 15.0
    return 180.0 - angle
  }
  func sunLatitude() -> Double {
    let cal = Calendar.current
    let day = cal.ordinality(of: .day, in: .year, for: self) ?? 0
    let offsetInSolarYear = (day < 357) ? day + 10 : day - 357
    let offsetFromEquinox = (offsetInSolarYear < 183) ? offsetInSolarYear - 90 : 277 - offsetInSolarYear
    let angle = 23.0 * Double(offsetFromEquinox) / 92.0
    return angle
  }
  func nightLongitude() -> Double {
    let nightLongitude = self.sunLongitude() + 180.0
    return (nightLongitude > 180) ? nightLongitude - 360 : nightLongitude
  }
  func nightLatitude() -> Double {
    return -self.sunLatitude()
  }
}

extension String {
  func trim() -> String {
    return self.trimmingCharacters(in: .whitespaces)
  }
  func from(_ from: Int, to: Int) -> String {
    return String(self.prefix(to).suffix(to-from+1))
  }
  func asBase64String() -> String {
    return Data(self.utf8).base64EncodedString()
  }
  func urlEncoded() -> String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
  }
}
