//
//  AppIcon.swift
//  ISS Tracker
//
//  Created by Mark Bush on 06/06/2026.
//

import SwiftUI

struct AppIcon: View {
  var body: some View {
#if os(visionOS)
    ZStack {
      Image("AppIcon/Back/Content")
        .resizable()
        .frame(width: 150, height: 150)
        .clipShape(Circle())
      Image("AppIcon/Middle/Content")
        .resizable()
        .frame(width: 150, height: 150)
        .clipShape(Circle())
        .offset(z: 10)
      Image("AppIcon/Front/Content")
        .resizable()
        .frame(width: 150, height: 150)
        .clipShape(Circle())
        .offset(z: 20)
    }
#else
    VStack {
      Image("ISS-Icon")
        .resizable()
        .frame(width: 150, height: 150)
        .cornerRadius(8)
    }
#endif
  }
}

#Preview {
  AppIcon()
}

