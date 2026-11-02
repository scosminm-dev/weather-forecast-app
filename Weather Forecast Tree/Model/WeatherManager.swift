import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather( weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=fdb483dcfa552e34adf5eeddb09a9462&units=metric"
    var delegate : WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

func performRequest(with urlString: String) {
	//1. First we recreate the code
    if let url = URL(string: urlString) {
        //2nd step is to create a URLSession
        let session = URLSession(configuration: .default)
        //3d will send a task to the session instance
        let task = session.dataTask(with: url) {
            (data, response, error ) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON( safeData) {
                    print("is here")
                    if (delegate != nil) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
        }
        //4th and last request
        task.resume()
	}
}
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //refractoring based on old syntax.
            print(weather.temperature)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
  }
