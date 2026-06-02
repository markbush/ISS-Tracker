//
//  HTTPFetcher.swift
//  ISS Tracker
//
//  Created by Mark Bush on 10/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import Foundation

struct HTTPMethod {
  static let Get = "GET"
  static let Post = "POST"
}

class HTTPFetcher {
  private static let session = NSURLSession.sharedSession()

  private static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String {
    let params = parameters.map { key, value in
      "\(key)=\(value.urlEncoded())"
    }
    return params.joinWithSeparator("&")
  }

  private static func requestForPath(path: String, headers: Dictionary<String,String> = [:]) -> NSMutableURLRequest? {
    guard let url = NSURL(string: path) else { return nil }
    let request = NSMutableURLRequest(URL: url)
    request.timeoutInterval = 5
    for (header, value) in headers {
      request.addValue(value, forHTTPHeaderField: header)
    }
    return request
  }

  private static func getRequestForPath(path: String, headers: Dictionary<String,String> = [:], parameters: Dictionary<String,String> = [:]) -> NSURLRequest? {
    let queryString = queryStringFromParameters(parameters)
    let fullPath = "\(path)?\(queryString)"
    guard let request = requestForPath(fullPath, headers: headers) else { return nil }
    request.HTTPMethod = HTTPMethod.Get
    return request
  }

  private static func postRequestForPath(path: String, headers: Dictionary<String,String> = [:], parameters: Dictionary<String,String> = [:]) -> NSURLRequest? {
    guard let request = requestForPath(path, headers: headers) else { return nil }
    let queryString = queryStringFromParameters(parameters)
    request.HTTPMethod = HTTPMethod.Post
    request.HTTPBody = queryString.dataUsingEncoding(NSUTF8StringEncoding)
    return request
  }

  static func get(path: String, headers: Dictionary<String,String> = [:],
                  parameters: Dictionary<String,String> = [:], callback: AnyObject? -> Void) {
    if let request = getRequestForPath(path, headers: headers, parameters: parameters) {
      let task = session.dataTaskWithRequest(request) { data, response, error in
        if let resultData = data {
          if let json = try? NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.AllowFragments) {
            callback(json)
          } else {
            callback(data)
          }
        } else {
          callback(data)
        }
      }
      task.resume()
    } else {
      callback(nil)
    }
  }

  static func post(path: String, headers: Dictionary<String,String> = [:],
                   parameters: Dictionary<String,String> = [:], callback: AnyObject? -> Void) {
    if let request = postRequestForPath(path, headers: headers, parameters: parameters) {
      let task = session.dataTaskWithRequest(request) { data, response, error in
        if let resultData = data {
          if let json = try? NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.AllowFragments) {
            callback(json)
          } else {
            callback(data)
          }
        } else {
          callback(data)
        }
      }
      task.resume()
    } else {
      callback(nil)
    }
  }
}
