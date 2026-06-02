//
//  Extensions.swift
//  ISS Tracker
//
//  Created by Mark Bush on 08/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

struct DateConstants {
  static let VernalEquinoxDay = 80
  static let SummerSolsticeDay = 173
  static let AutumnalEquinox = 267
  static let WinterSolstice = 357
  static let MaxDaysInYear = 366
}

extension NSDate {
  convenience
  init(dateString:String) {
    let dateStringFormatter = NSDateFormatter()
    dateStringFormatter.dateFormat = "dd-MM-yyyy"
    dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateStringFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
    let d = dateStringFormatter.dateFromString(dateString)!
    self.init(timeInterval:0, sinceDate:d)
  }
  func sunLongitude() -> Double {
    let cal = NSCalendar.currentCalendar()
    let secInDay = cal.ordinalityOfUnit(.Second, inUnit: .Day, forDate: self)
    let hours = Double(secInDay) / (60.0 * 60.0)
    let angle = hours * 15.0
    return 180.0 - angle
  }
  func sunLatitude() -> Double {
    let cal = NSCalendar.currentCalendar()
    let day = cal.ordinalityOfUnit(.Day, inUnit: .Year, forDate: self)
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
    return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
  }
  func from(from: Int, to: Int) -> String {
    return self[self.startIndex.advancedBy(from-1)...self.startIndex.advancedBy(to-1)]
  }
  func asBase64String() -> String? {
    let stringAsData = self.dataUsingEncoding(NSUTF8StringEncoding)
    return stringAsData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
  }
  func urlEncoded() -> String {
    return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) ?? ""
  }
  func dateFromTwitterDateString() -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    return dateFormatter.dateFromString(self)
  }
  func decodeHTML() -> String{
    let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)!
    let attributedOptions : [String: AnyObject] = [
      NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
      NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
    ]
    let attributedString = try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)

    return attributedString?.string ?? ""
  }
  mutating func remove(from: Int, to: Int) {
    self.removeRange(self.startIndex.advancedBy(from)..<self.startIndex.advancedBy(to))
  }
}
