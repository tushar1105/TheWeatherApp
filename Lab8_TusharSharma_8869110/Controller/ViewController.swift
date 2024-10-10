//
//  ViewController.swift
//  Lab8_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-04.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // custom variables
    var locationManager = CLLocationManager()
    var cityLatitude : CLLocationDegrees?
    var cityLongitude : CLLocationDegrees?
    var customCityName : String?
    
    
    //IBOutlets
    @IBOutlet weak var cityNameInput: UITextField!
    
    @IBOutlet weak var currentCityName: UILabel!
    
    @IBOutlet weak var currentWeather: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var currentTemperature: UILabel!
    
    @IBOutlet weak var currentHumidity: UILabel!
    
    @IBOutlet weak var currentWindSpeed: UILabel!
    
    @IBOutlet weak var maximumTemperature: UILabel!
    
    @IBOutlet weak var minimumTemperature: UILabel!
    
    // override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationManager.delegate = self
        // ask for user permission to share location information.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // custom functions
    // sets location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.startUpdatingLocation()
            let coordinate = CLLocationCoordinate2D (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )
            //            print(coordinate)
            cityLatitude = coordinate.latitude
            cityLongitude = coordinate.longitude
            updateWeatherData(cityValue: "current")
        }
    }
    
    // function to update weather data on view.
    func updateWeatherData(cityValue : String){
        // initialising API call structure object with query string based on the city or coordinates.
        var finalAPIEndpointURL : String?
        // generate final API endpoint.
        if cityValue == "current" {
            // api call according to current latitude and longitude values.
            let requestString = "lat=\(cityLatitude!)&lon=\(cityLongitude!)"
            let apiCall = APICall(apiRequestString: requestString)
            finalAPIEndpointURL = apiCall.completeAPIEndpoint()
        } else {
            // api call according to entered city name.
            let requestString = "q=\(customCityName!)"
            let apiCall = APICall(apiRequestString: requestString)
            finalAPIEndpointURL = apiCall.completeAPIEndpoint()
        }
        //print(finalAPIEndpointURL!)
        // call openweather API and update view using this generated URL.
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: finalAPIEndpointURL!)
        // api call to receive data, response, error
        if let url = url {
            let dataTask = urlSession.dataTask(with: url) {
                (data, response, error) in
                //print(data!)
                //let jsonString = String(data: data!, encoding: .utf8)
                //print("Raw JSON data: \(jsonString!)")
                let jsonDecoder = JSONDecoder()
                do{
                    let readableData = try jsonDecoder.decode(WeatherAPI.self, from: data!)
                    //print(readableData)
                    let cityName = "\(readableData.name), \(readableData.sys.country)"
                    let weather = readableData.weather.first?.main ?? "No weather info"
                    // kelvin to celsius conversion.
                    let temperature = readableData.main.temp - 273.15
                    let maximumTemperature = readableData.main.tempMax - 273.15
                    let minimumTemperature = readableData.main.tempMin - 273.15
                    let formattedTemp = String(format: "%.0f", temperature)
                    let formattedMaximumTemperature = String(format: "%.0f", maximumTemperature)
                    let formattedMinimumTemperature = String(format: "%.0f", minimumTemperature)
                    // m/s to km/hr
                    let windSpeedKmH = readableData.wind.speed * 3.6
                    let formattedWindSpeed = String(format: "%.2f", windSpeedKmH)
                    let humidity = "\(readableData.main.humidity) %"
                    let iconCode = readableData.weather.first?.icon ?? "default_icon"
//                    print(iconCode)
                    //print("\(cityName),\(weather),\(formattedTemp)°C,\(formattedWindSpeed)km/hr,\(humidity)")
                    // updateing the view on the main thread with the received values.
                    DispatchQueue.main.async {
                        self.currentCityName.text = cityName
                        self.currentWeather.text = weather
                        self.currentTemperature.text = "\(formattedTemp) °C"
                        self.maximumTemperature.text = "\(formattedMaximumTemperature) °C"
                        self.minimumTemperature.text = "\(formattedMinimumTemperature) °C"
                        self.currentWindSpeed.text = "\(formattedWindSpeed) km/h"
                        self.currentHumidity.text = humidity
                        // Set the weather icon image based on the icon code
                        self.setWeatherIcon(iconCode: iconCode)

                    }
                }
                catch{
                    DispatchQueue.main.async {
                        let responseError = UIAlertController(title: "Error", message: "Sorry! Invalid location or city name.", preferredStyle: .alert)
                        responseError.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(responseError, animated: true, completion: nil)
                        self.cityNameInput.text = ""
                        self.cityNameInput.placeholder = "Enter a city name..."
                        self.updateWeatherData(cityValue: "current")
                    }
                }
            }
            dataTask.resume()
        }
        
        
    }
    
    // function to set weather icon based on the returned icon code from API.
    // reference chatGPT.
    func setWeatherIcon(iconCode: String) {
        // Map iconCode to SF Symbol names
            let iconName: String
            switch iconCode {
            case "01d":
                    iconName = "sun.max"
                case "01n":
                    iconName = "moon.stars"
                case "02d":
                    iconName = "cloud.sun"
                case "02n":
                    iconName = "cloud.moon"
                case "03d":
                    iconName = "cloud"
                case "03n":
                    iconName = "cloud.moon"
                case "04d":
                    iconName = "cloud.fill"
                case "04n":
                    iconName = "cloud.fill"
                case "09d":
                    iconName = "cloud.rain"
                case "09n":
                    iconName = "cloud.rain"
                case "10d":
                    iconName = "cloud.heavyrain"
                case "10n":
                    iconName = "cloud.heavyrain"
                case "11d":
                    iconName = "cloud.bolt.rain"
                case "11n":
                    iconName = "cloud.bolt.rain"
                case "13d":
                    iconName = "snow"
                case "13n":
                    iconName = "snow"
                case "50d":
                    iconName = "cloud.fog"
                case "50n":
                    iconName = "cloud.fog"
                default:
                    iconName = "questionmark"
                }
            // Set the image for the UIImageView
            weatherImage.image = UIImage(systemName: iconName)
        }
    
    // IBActions
    //dismiss keyboard.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        cityNameInput.resignFirstResponder()
    }
    
    // update weather info according to the enterd city name.
    @IBAction func searchCityWeather(_ sender: UIButton) {
        // check for entered city name.
        if((cityNameInput == nil || cityNameInput.text!.isEmpty)){
            updateWeatherData(cityValue: "current")
            let cityNameEmpty = UIAlertController(title: "Error", message: "Please enter a city name.", preferredStyle: .alert)
            cityNameEmpty.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(cityNameEmpty, animated: true, completion: nil)
        }else{
            //set entered city name to the custom city name variable and update view with its weather data.
            customCityName = cityNameInput.text
            updateWeatherData(cityValue: "custom")
            cityNameInput.resignFirstResponder()
        }
    }
    
    // reset to current location.
    @IBAction func resetToCurrentCity(_ sender: UIButton) {
        updateWeatherData(cityValue: "current")
        cityNameInput.text = ""
        cityNameInput.placeholder = "Enter a city name..."
        let resetToCurrentCity = UIAlertController(title: "Reset", message: "Weather information set back to current location.", preferredStyle: .alert)
        resetToCurrentCity.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(resetToCurrentCity, animated: true, completion: nil)
        cityNameInput.resignFirstResponder()
    }
}

// END //
