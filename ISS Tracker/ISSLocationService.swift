//
//  ISSLocationService.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import Foundation
import Combine
import CoreLocation

class ISSLocationService: ObservableObject {
  @Published var latitude: Double = 0
  @Published var longitude: Double = 0
  @Published var altitude: Double = 0
  @Published var speed: Double = 0
  @Published var tleAvailable: Bool = false
  
  @Published var historicalPath: [CLLocationCoordinate2D] = []
  @Published var futurePath: [CLLocationCoordinate2D] = []
  
  private var iss: ISS?
  private var pathIss: ISS?
  private var timer: AnyCancellable?
  
  init() {
    self.iss = ISS()
    self.pathIss = ISS()
    update()
    
    timer = Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.update()
      }
  }
  
  private func update() {
    guard let iss = iss, let pathIss = pathIss else {
      tleAvailable = false
      return
    }
    tleAvailable = iss.update()
    
    self.latitude = iss.latitude
    self.longitude = iss.longitude
    self.altitude = iss.height
    self.speed = iss.velocity.length()
    
    let now = Date()
    
    // Calculate paths every 5 minutes for performance, covering 1 hour each way
    var history: [CLLocationCoordinate2D] = []
    for i in stride(from: -90, through: 0, by: 5) {
      pathIss.updateForDate(now.addingTimeInterval(Double(i * 60)))
      history.append(CLLocationCoordinate2D(latitude: pathIss.latitude, longitude: pathIss.longitude))
    }
    self.historicalPath = history
    
    var future: [CLLocationCoordinate2D] = []
    for i in stride(from: 0, through: 90, by: 5) {
      pathIss.updateForDate(now.addingTimeInterval(Double(i * 60)))
      future.append(CLLocationCoordinate2D(latitude: pathIss.latitude, longitude: pathIss.longitude))
    }
    self.futurePath = future
  }
}
