 //  ViewController.swift
//  Weather Forecast
//  Created by Cosmin-Mugurel-Gmap on 19/10/2026.
import UIKit
import CoreLocation

class ViewController: UIViewController,
                      UITextFieldDelegate, WeatherManagerDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var imageWeatherCondition: UIImageView!
    @IBOutlet weak var nameOfCity: UILabel!

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.imageWeatherCondition.image = UIImage(systemName: weather.conditionName)
            self.nameOfCity.text = weather.cityName
        }
    }
    func didFailWithError(error: any Error) {
        print(error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //we need to set this as authority of the software program we use
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        cityField.delegate = self
        weatherManager.delegate = self
 }
    
    @IBAction func locationUpdate(_ sender: Any) {
        locationManager.requestLocation()
    }
    @IBAction func send(_ sender: UIButton) {
        weatherManager.fetchWeather(cityName: cityField.text!)
        cityField.text = ""
    }
}
//MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error ) {
            print(error)
    }
}
