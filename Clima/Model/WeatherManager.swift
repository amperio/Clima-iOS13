import UIKit
import CoreLocation

// By convention in Swift, create the protocol in the same file as the class that will use the protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let url = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=b3ceaef88d93238d6f3c0cfe6212bf48&"
    
    func getWeather(city: String) {
        performRequest(with: url+"&q=\(city)")
    }
    
    func performRequest(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString){
            // Cretae a URL Session: The object that's going to be doing on networking
            let urlSession = URLSession(configuration: .default)
            // Give the session a task: Fetching the data for the particular source
            let sessionTask = urlSession.dataTask(with: url) { (data, response, error) in // A closures
                if error != nil{
                    // print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    // print(String(data: safeData, encoding: .utf8)!) // utf8: The encoding for most of the data we get back from the web is UTF-8
                    if let weather = self.parseJason(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather) // Usamos el self, devido a que estamos en un Clousure
                    }
                }
            } // Este es el completionHandler, que sera Trigeado por el 'sessionTask' Cuando la urlSession complete la conexion y la sessionTask tambien se compelete, entonces, este ultimo llamara la ejecucion del completionHandler (la funcion closure)
            // Start the task: Is like the enter key - Trigger the entire networking process
            sessionTask.resume()
        }
    }
    
    func parseJason(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder() // Object that can decode JSON
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // Modelled the respond data to decodedData
            //print(decodedData.main.temp) // Se inicializa con los volores obtenidos del Jason, siempre y cuendo sean iguales tanto la variable como la key en el Jason. (debe haber MATCH)
            // El objeto 'decodedData' va ha ser inicializado solo con los valores que se hayan establecido com parametros, y no con todos los datos obtenidos del Jason
            let weatherID = decodedData.weather[0].id
            let cityName = decodedData.name
            let temperatura = decodedData.main.temp
            let weatherModel = WeatherModel(cityName: cityName, weatherID: weatherID, temperatura: temperatura)
//            print(weatherModel.weatherName)
//            print(weatherModel.newTemp)
//            print(weatherModel.cityName)
            return weatherModel
        }catch let error{
            // print("error ocurring while decoding \(error.localizedDescription)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

extension WeatherManager{
    func getWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        performRequest(with: url + "&lat=\(lat)&lon=\(lon)")
    }
}
