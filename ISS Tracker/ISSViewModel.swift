//
//  ISSViewModel.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import Foundation
import Combine
import CoreLocation

enum DisplayUnits {
  case metric
  case imperial
}

@Observable
class ISSViewModel: ObservableObject {
  enum SidebarItem: Hashable {
    case map
    case about
    case settings
  }

  static let KPS2MPH = 2236.936292
  static let KM2M = 0.6213712
  var latitude: Double = 0
  var longitude: Double = 0
  var altitude: Double = 0
  var speed: Double = 0
  var localTime: String = ""
  var tleAvailable: Bool = false
  var displayUnits: DisplayUnits = .metric
  var selectedSidebarItem: SidebarItem? = .map
  
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var historicalPath: [CLLocationCoordinate2D] = []
  var futurePath: [CLLocationCoordinate2D] = []
  
  private var locationService = ISSLocationService()
  private var cancellables = Set<AnyCancellable>()
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
  }()
  
  init() {
    locationService.objectWillChange
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        self?.updateFromService()
      }
      .store(in: &cancellables)
    
    updateFromService()
  }
  
  private func updateFromService() {
    self.tleAvailable = locationService.tleAvailable
    self.latitude = locationService.latitude
    self.longitude = locationService.longitude
    self.altitude = locationService.altitude
    self.speed = locationService.speed
    
    self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    self.historicalPath = locationService.historicalPath
    self.futurePath = locationService.futurePath
    
    // Solar Time
    let secondsOffset = longitude * 240
    let solarDate = Date().addingTimeInterval(secondsOffset)
    self.localTime = dateFormatter.string(from: solarDate)
    
    objectWillChange.send()
  }
  
  func displaySpeed() -> String {
    switch displayUnits {
        case .metric:
        return String(format: "%.2f km/s", speed)
      case .imperial:
        return String(format: "%.0f mph", speed * ISSViewModel.KPS2MPH)
    }
  }
  
  func displayAltitude() -> String {
    switch displayUnits {
        case .metric:
        return String(format: "%.0f km", altitude)
      case .imperial:
        return String(format: "%.0f miles", altitude * ISSViewModel.KM2M)
    }
  }
}
