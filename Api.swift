import Foundation

@Observable
class Api{
    let urlString = "https://api.open-meteo.com/v1/forecast?latitude=57.78145&longitude=14.15618&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin"
    private(set) var isLoading = false
    private(set) var weather : WeatherResponse?
    private (set)var weatherlist:[WeatherResponse.daily] = []
    init (){
        
    }
    func fetchWeather() async{
        guard let url = URL(string : urlString)else {
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            print(String(data: data, encoding: .utf8))
            let decoder = JSONDecoder()
            
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try decoder.decode(WeatherResponse.self, from: data)
            weatherlist = [result.daily]
            print(result)
            self.weather=result
        }catch {
            print(error)
        }
    }
}
