//
//  ISSViewModel.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import Foundation
import Combine
import CoreLocation

class ISSViewModel: ObservableObject {
  @Published var latitude: Double = 0
  @Published var longitude: Double = 0
  @Published var altitude: Double = 0
  @Published var speed: Double = 0
  @Published var localTime: String = ""
  
  @Published var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  @Published var historicalPath: [CLLocationCoordinate2D] = []
  @Published var futurePath: [CLLocationCoordinate2D] = []
  
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
}
