//
//  ContentView.swift
//  WeatherApp
//
//  Created by MacBook on 2025-02-03.
//

import SwiftUI

struct ContentView: View {
    @State private var locationService = LocationManager()
    @State private var api = Api()
    
    var body: some View {
        
        
        ZStack {
           
            LinearGradient(gradient: Gradient(colors: getBackgroundColors()),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(spacing: 16) {
                    
                  
                    Text(locationService.address?.locality ?? "Din plats")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding(.top, 40)
                    
                 
                    if let temp = api.weather?.current.temperature2M {
                        VStack {
                            Text(String(format: "%.f°C", temp))
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(getWeatherEmoji(temp: temp))
                                .font(.system(size: 50))
                        }
                        .padding()
                    } else {
                        Text("Laddar...")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    
                    
                    if let maxTemp = api.weather?.daily.temperature2MMax.first,
                       let minTemp = api.weather?.daily.temperature2MMin.first {
                        HStack(spacing: 20) {
                            WeatherInfoCard(title: "H", value: "\(String(format: "%.f°C", maxTemp))", icon: "thermometer.sun.fill")
                            WeatherInfoCard(title: "L", value: "\(String(format: "%.f°C", minTemp))", icon: "thermometer.snowflake")
                        }
                    }
                    
                   
                    if let weather = api.weatherlist.first {
                        VStack {
                            Text("7-day forecast")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            
                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(0..<weather.time.count, id: \.self) { index in
                                        let day = daysName(from: weather.time[index])
                                        let weatherCode = weather.weatherCode[index]
                                        let description = weatherDescription(code: weatherCode)
                                        let icon = weatherIcon(code: weatherCode)
                                        
                                        ForecastRow(day: day,
                                                    high: weather.temperature2MMax[index],
                                                    low: weather.temperature2MMin[index],
                                                    icon: icon,
                                                    description: description)
                                    }
                                }
                            }
                            .frame(height: 300)
                        }
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(20)
                        .padding()
                    }
                }
            }
            .onAppear {
                locationService.requestLocation()
                
                Task { @MainActor in
                    await api.fetchWeather()
                }
            }
            .refreshable {
                locationService.requestLocation()
                
                Task { @MainActor in
                    await api.fetchWeather()
                }
            }
        }
    }
}

func getBackgroundColors() -> [Color] {
    if let temp = Api().weather?.current.temperature2M {
        if temp > 25 {
            return [Color.orange, Color.red]
        } else if temp > 10 {
            return [Color.blue, Color.purple]
        } else {
            return [Color.gray, Color.blue]
        }
    }
    return [Color.gray, Color.blue]
}


func getWeatherEmoji(temp: Double) -> String {
    switch temp {
    case ..<0: return "❄️"
    case 0..<10: return "🌥"
    case 10..<25: return "☀️"
    case 25...: return "🔥"
    default: return "❓"
    }
}


func weatherDescription(code: Int) -> String {
    switch code {
    case 0: return "Sunny"
    case 1: return "Cloudy"
    case 2: return "Rainy"
    case 3: return "Snowy"
    default: return "Okänt"
    }
}


func weatherIcon(code: Int) -> String {
    switch code {
    case 0: return "sun.max.fill"
    case 1: return "cloud.fill"
    case 2: return "cloud.rain.fill"
    case 3: return "cloud.snow.fill"
    default: return "questionmark"
    }
}


func daysName(from date: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    if let dateObj = formatter.date(from: date) {
        formatter.dateFormat = "EEEE"
        return formatter.string(from: dateObj)
    }
    return date
}


struct WeatherInfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


struct ForecastRow: View {
    let day: String
    let high: Double
    let low: Double
    let icon: String
    let description: String
    
    var body: some View {
        HStack {
            Text(day)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: icon)
                .foregroundColor(.white)
            
            Text(description)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("H: \(String(format: "%.1f°C", high))")
                .foregroundColor(.white)
            
            Text("L: \(String(format: "%.1f°C", low))")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.4))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


#Preview {
    ContentView()
}
