//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation // Obtain the geographic location and orientation of a device

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView! // Icono
    @IBOutlet weak var temperatureLabel: UILabel! // Temperatura
    @IBOutlet weak var cityLabel: UILabel! // Nombre de la Ciudad
    @IBOutlet weak var txt_search: UITextField!
    
    var weatherManager = WeatherManager()
    let coreLocation = CLLocationManager() // The object that is used to start and stop the delivery of location related events to your app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coreLocation.requestWhenInUseAuthorization()
        //conditionImageView.image = UIImage(systemName: "questionmark.circle.fill")
        weatherManager.delegate = self
        coreLocation.delegate = self
        txt_search.delegate = self
        
        coreLocation.requestLocation()
    }
    
    
    @IBAction func btn_ownLocation(_ sender: UIButton) {
        coreLocation.stopUpdatingLocation()
        coreLocation.requestLocation()
    }
    
}


// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func btn_search(_ sender: UIButton) {
        txt_search.endEditing(true) // 1
    }
    
    // The user taps the keyboard's return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true) // 1
        // txt_search.resignFirstResponder() // // Ask the system to dismiss the keyboard
        return true
    }
    
    // Detects the user dismissing the keyboard (Before resigning as first responder. Validate the text)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // 2
        // Servira para hacer validaciones
        if textField.text != ""{
            textField.placeholder = "Search"
            return true // En este caso la funcion 'textFieldDidEndEditing' si se ejecutara
        }else{
            textField.placeholder = "Type Something!"
            return false // En este caso el teclado estara disponible, la funcion 'textFieldDidEndEditing' no se ejecutara
        }
    }
    
    // Cuando el teclado se esconde
    func textFieldDidEndEditing(_ textField: UITextField) { // 3
        // Se ejecuta cuando '.endEditing' es aplicado
        weatherManager.getWeather(city: txt_search.text!)
        textField.text = ""
    }
}


// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    // FUNCIONES DELEGADAS
    // Se especifica la identificacion del objeto que causa o ejecuta a el metodo delegado
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
//        print(weather.newTemp)
//        print(weather.cityName)
        // ENCLOSE THE CALL TO RUN IT IN THE MAIN THREAD
        DispatchQueue.main.async {
            // DispatchQueue is an object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread
            self.temperatureLabel.text = weather.newTemp
            self.conditionImageView.image = UIImage(systemName: weather.weatherName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    // *****************************************
}


// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Ha habido un cambio en la Ubicacion!")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Escogemos el ultimo elemnto del Array (.last), devido a que este es el que tendra mas presicion
        if let ubicacion = locations.last{
            let lat = ubicacion.coordinate.latitude
            let lon = ubicacion.coordinate.longitude
            weatherManager.getWeather(lat: lat, lon: lon)
        }
    }
}







//                ___                  ___ 
//               -   -________________-   -
//             /----.       AMP        .----\
//            (  __  |                |  __  )
//            | (@ ) |                | ( @) |
//           /\\____//                \\____//\
//          /              *:   :*             \
//          \`\ ____________________________ /`/
//           \                                /
//            \    $$$$$$$$$$$$$$$$$$$$$$    /
//             \    $$$$$$$$$$$$$$$$$$$$    /
//              -__  $$$$$$$$$$$$$$$$$$  __-
//                  -_$$$$$$$$$$$$$$$$_-






