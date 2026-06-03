//
//  ISSMapView.swift
//  ISS Tracker
//
//  Created by Mark Bush on 03/06/2026.
//

import SwiftUI
import MapKit

struct ISSMapView: View {
  @ObservedObject var viewModel: ISSViewModel
  
  var body: some View {
    Map {
      // Historical Path
      MapPolyline(coordinates: viewModel.historicalPath, contourStyle: .geodesic)
        .stroke(.white.opacity(0.3), lineWidth: 1)
      
      // Future Path
      MapPolyline(coordinates: viewModel.futurePath, contourStyle: .geodesic)
        .stroke(.white, lineWidth: 1)
      
      // ISS Marker
      Annotation("ISS", coordinate: viewModel.coordinate) {
        Image("iss")
          .resizable()
          .scaledToFit()
          .frame(width: 44, height: 44)
      }
      
      // ISS Horizon
      MapCircle(center: viewModel.coordinate, radius: ISS.issHorizon)
        .foregroundStyle(.blue.opacity(0.1))
        .stroke(.blue, lineWidth: 1)
    }
    .mapStyle(.hybrid(elevation: .realistic))
  }
}

#Preview {
  ISSMapView(viewModel: ISSViewModel())
}
