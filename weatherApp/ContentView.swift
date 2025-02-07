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
            VStack {
              
                Text(locationService.address?.locality ?? "Din plats")
                    .font(.title)
                    .bold()
                    .padding()
                
               
                if let temp = api.weather?.current.temperature2M {
                    Text(String(format: "%.f°C", temp))
                        .bold()
                        .font(.largeTitle)
                        .padding()
                } else {
                    Text("Laddar...")
                        .foregroundColor(.gray)
                }
                
              
                HStack {
                    if let maxTemp = api.weather?.daily.temperature2MMax.first {
                        Text(String(format: "H: %.f°C", maxTemp))
                            .bold()
                            .padding()
                    } else {
                        Text("H: --°C")
                            .foregroundColor(.gray)
                            .bold()
                            .padding()
                    }
                    
                    if let minTemp = api.weather?.daily.temperature2MMin.first {
                        Text(String(format: "L: %.f°C", minTemp))
                            .bold()
                            .padding()
                    } else {
                        Text("L: --°C")
                            .foregroundColor(.gray)
                            .bold()
                            .padding()
                    }
                }
                
             
                if let weather = api.weatherlist.first {
                    Text("Väder för 7 dagar")
                        .padding()
                        .foregroundColor(.white)
                    
                    ForEach(0..<weather.time.count, id: \.self) { index in
                        let day = daysName(from: weather.time[index])
                        
                        HStack {
                            Text(day)
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Text("H: \(String(format: "%.1f°C", weather.temperature2MMax[index]))")
                                .foregroundColor(.white)
                            
                            Text("L: \(String(format: "%.1f°C", weather.temperature2MMin[index]))")
                                .foregroundColor(.white)
                            
                            let weatherCode = weather.weatherCode[index]
                            let description = weatherdescription(code: weatherCode)
                            let icon = weathericon(code: weatherCode)
                            
                            Image(systemName: icon)
                                .foregroundColor(.white)
                            
                            Text(description)
                                .foregroundColor(.white)
                        }
                        .frame(width: 500, height: 40)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 8)
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                locationService.requestLocation()
                
                Task { @MainActor in
                    await api.fetchWeather()
                    if let time = api.weather?.current.time, time.count >= 5 {
                        print("Fetched time: \(time)")
                    }
                }
            }
            .refreshable {
                locationService.requestLocation()
                
                Task { @MainActor in
                    await api.fetchWeather()
                    if let time = api.weather?.current.time, time.count >= 5 {
                        print("Fetched time: \(time)")
                    }
                }
            }
        }
    }
        func weatherdescription(code: Int) -> String {
            switch code {
            case 0:
                return "Sunny"
            case 1:
                return " Cloudy"
            case 2:
                return "Rainy"
            case 3:
                return "snowy"
            default:
                return "unkown"
            }
        }
        func weathericon(code: Int) -> String {
            switch code {
            case 0:
                return "sun.max.fill"
            case 1:
                return "cloud.fill"
            case 2:
                return "cloud.rain.fill"
            case 3:
                return "cloud.snow.fill"
            default:
                return "unkown"
            }
        }
        func daysName( from date: String) -> String {
            let dateForm=DateFormatter()
            dateForm.dateFormat="yyyy-MM-dd"
            if let formattedDate=dateForm.date(from: date){
                let weekday = DateFormatter()
                weekday.dateFormat="EEEE"
                return weekday.string(from: formattedDate)
            }
            return date
        }
   
    #Preview {
        ContentView()
    }
