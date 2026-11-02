 //  ViewController.swift
//  Weather Forecast
//  Created by Cosmin-Mugurel-Gmap on 19/10/2026.
import UIKit
import CoreLocation

class ViewController: UIViewController,
                        UITextFieldDelegate,
                      WeatherManagerDelegate {

    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var imageWeatherCondition: UIImageView!
    @IBOutlet weak var nameOfCity: UILabel!

    var weatherManager = WeatherManager()
    
    func didUpdateWeather(weather: WeatherModel) {
            print(weather.temperature , "please check room")
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.imageWeatherCondition.image = UIImage(systemName: weather.conditionName)
            self.nameOfCity.text = weather.cityName
            
        }
    }
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //we need to set this as authority of the software program we use
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        cityField.delegate = self
        weatherManager.delegate = self
 }
    
    @IBAction func send(_ sender: UIButton) {
        
        weatherManager.fetchWeather(cityName: cityField.text!)
        cityField.text = ""
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
        print("got my nerdie address.")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error ) {
            print(error)
    }
    
}
