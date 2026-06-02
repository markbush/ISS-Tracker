//
//  TrackerViewController.swift
//  ISS Tracker
//
//  Created by Mark Bush on 28/03/2016.
//  Copyright © 2016 Mark Bush. All rights reserved.
//

import UIKit
import MapKit

class TrackerViewController: UIViewController, MKMapViewDelegate {
  static let issHorizon = 1.60934e6
  static let nightHorizon = 1.1e7
  @IBOutlet weak var mapView: MKMapView! {
    didSet {
      mapView.delegate = self
      var region = mapView.region
      region.span = MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
      mapView.setRegion(region, animated: false)
    }
  }

  var iss = ISS()
  var issOverlay = ISS()
  var issIcon: UIImage? = UIImage(named: "annotation")
  lazy var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd MMM yyyy HH:mm:ss zzz"
    formatter.timeZone = NSTimeZone(abbreviation: "GMT")
    return formatter
  }()
  var issPrevPathOverlay: MKOverlay?
  var issNextPathOverlay: MKOverlay?
  var issHorizonOverlay: MKOverlay?
  var nightOverlay: MKOverlay?

  var timer: NSTimer?

  func polyLineFrom(fromOffset: Double, to: Double) -> MKPolyline {
    var coordinates = [CLLocationCoordinate2D]()
    for offset in fromOffset.stride(through: to, by: 300) {
      let time = NSDate(timeIntervalSinceNow: offset)
      self.issOverlay!.updateForDate(time)
      let position = CLLocationCoordinate2D(latitude: issOverlay!.latitude, longitude: issOverlay!.longitude)
      coordinates.append(position)
    }
    return MKGeodesicPolyline(coordinates: &coordinates[0], count: coordinates.count)
  }

  func updateOverlay() {
    if self.nightOverlay != nil {
      self.mapView.removeOverlay(self.nightOverlay!)
      self.nightOverlay = nil
    }
    let now = NSDate()
    let position = CLLocationCoordinate2D(latitude: now.nightLatitude(), longitude: now.nightLongitude())
    self.nightOverlay = MKCircle(centerCoordinate: position, radius: TrackerViewController.nightHorizon)
    self.mapView.addOverlay(self.nightOverlay!)

    if self.issHorizonOverlay != nil {
      self.mapView.removeOverlay(self.issHorizonOverlay!)
      self.issHorizonOverlay = nil
    }
    self.issHorizonOverlay = MKCircle(centerCoordinate: iss!.coordinate, radius: TrackerViewController.issHorizon)
    self.mapView.addOverlay(self.issHorizonOverlay!)

    if self.issPrevPathOverlay != nil {
      self.mapView.removeOverlay(self.issPrevPathOverlay!)
      self.issPrevPathOverlay = nil
    }
    self.issPrevPathOverlay = self.polyLineFrom(-3600, to: 0)
    self.mapView.addOverlay(self.issPrevPathOverlay!)

    if self.issNextPathOverlay != nil {
      self.mapView.removeOverlay(self.issNextPathOverlay!)
      self.issNextPathOverlay = nil
    }
    self.issNextPathOverlay = self.polyLineFrom(0, to: 3600)
    self.mapView.addOverlay(self.issNextPathOverlay!)
  }

  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    if let polyLine = overlay as? MKPolyline {
      let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
      polyLineRenderer.strokeColor = (polyLine === self.issPrevPathOverlay!) ? UIColor.yellowColor() : UIColor.whiteColor()
      polyLineRenderer.lineWidth = 5
      return polyLineRenderer
    } else if let circle = overlay as? MKCircle {
      let circleRenderer = MKCircleRenderer(overlay: circle)
      if circle === self.nightOverlay {
        circleRenderer.strokeColor = UIColor.blackColor()
        circleRenderer.fillColor = UIColor.blackColor()
        circleRenderer.alpha = 0.7
        circleRenderer.lineWidth = 1
      } else {
        circleRenderer.strokeColor = UIColor.greenColor()
        circleRenderer.lineWidth = 2
      }
      return circleRenderer
    } else {
      return MKOverlayRenderer(overlay: overlay)
    }
  }

  func updateLocation() {
    let queue: dispatch_queue_t = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    dispatch_async(queue, {
      if let iss = self.iss {
        iss.update()
        dispatch_async(dispatch_get_main_queue()) {
          self.mapView?.removeAnnotations(self.mapView.annotations)
          self.updateOverlay()
          self.mapView?.addAnnotation(iss)
          var region = self.mapView.region
          region.center = iss.coordinate
          self.mapView.setRegion(region, animated: true)
        }
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

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    var view = mapView.dequeueReusableAnnotationViewWithIdentifier("ISS")
    if view == nil {
      view = MKAnnotationView(annotation: annotation, reuseIdentifier: "ISS")
    }
    view?.canShowCallout = false
    view?.image = self.issIcon
    view?.annotation = annotation
    return view
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

extension ISS: MKAnnotation {
  @objc var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: self.latitude ?? 0.0, longitude: self.longitude ?? 0.0)
  }
  @objc var title: String? {
    return self.name
  }
}