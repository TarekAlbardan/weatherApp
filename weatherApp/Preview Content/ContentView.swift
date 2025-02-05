//
//  ContentView.swift
//  weatherApp
//
//  Created by MacBook on 2025-02-03.
//

import SwiftUI

struct ContentView: View {
    @State private var locationService = LocationManager()
    @State private var api = Api()
    
    var body: some View {
        ScrollView {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            if let location = locationService.address{
                Text((location.locality ?? "Current location"))
            } else {
                Text("No location")
            }
        }
        .padding()
        .onAppear {
            locationService.requestLocation()
        }
        .refreshable {
            locationService.requestLocation()
            VStack {
                           if let weather = api.weather {
                               Text("Current Temperature: \(weather.current.temperature2M, specifier: "%.1f")°C")
                                   .font(.largeTitle)
                               
                               HStack {
                                   Text("H: \(api.max)")
                                       .bold()
                                   Text("L: \(api.min, specifier: "%.1f")°C")
                                       .bold()
                               }
                               .font(.title2)
                           } else if api.isLoading {
                               ProgressView("Fetching Weather...")
                           } else {
                               Text("No weather data available")
                           }
                       }
                       .padding()
                   }
                   .padding()
                   .onAppear {
                       locationService.requestLocation()
                       Task {
                          
