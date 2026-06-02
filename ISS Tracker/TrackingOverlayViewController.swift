//
//  TrackingOverlayViewController.swift
//  ISS Tracker
//
//  Created by Mark Bush on 09/04/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit

class TrackingOverlayViewController: UIViewController {
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var altitudeLabel: UILabel!
  @IBOutlet weak var speedLabel: UILabel!
  @IBOutlet weak var issTimeLabel: UILabel!

  var iss = ISS()!
  var timer: NSTimer?
  lazy var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd MMM yyyy HH:mm:ss zzz"
    formatter.timeZone = NSTimeZone(abbreviation: "GMT")
    return formatter
  }()

  func updateLocation() {
    let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    dispatch_async(queue, {
      self.iss.update()
      dispatch_async(dispatch_get_main_queue()) {
        let latitude = fabs(self.iss.latitude)
        let latitudeNS = self.iss.latitude < 0.0 ? "S" : "N"
        let longitude = fabs(self.iss.longitude)
        let longitudeWE = self.iss.longitude < 0.0 ? "W" : "E"
        let height = self.iss.height
        self.longitudeLabel?.text = String.init(format: "%.1f %@", longitude, longitudeWE)
        self.latitudeLabel?.text = String.init(format: "%.1f %@", latitude, latitudeNS)
        self.altitudeLabel?.text = String.init(format: "%.0f km", height)
        let velocityKps = self.iss.velocity.length()
        let velocityKph = velocityKps * 60.0 * 60.0
        self.speedLabel?.text = String.init(format: "%.0f kph (%.2f kps)", velocityKph, velocityKps)
        self.issTimeLabel?.text = self.dateFormatter.stringFromDate(NSDate())
      }
    })
  }
  func updateLocation(timer: NSTimer) {
    updateLocation()
  }

  func stopTimer() {
    if let activeTimer = self.timer {
      activeTimer.invalidate()
      self.timer = nil
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    stopTimer()
    updateLocation()
    self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TrackerViewController.updateLocation(_:)), userInfo: nil, repeats: true)
    timer?.tolerance = 1
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    stopTimer()
  }
}
