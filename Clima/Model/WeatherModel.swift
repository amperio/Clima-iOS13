
// USE THIS FILE TO MODEL WHAT A WEATHER OBJECT SHOULD LOOK LIKE

struct WeatherModel {
    // THESE THREE PROPERTIES ARE CALLED STORED PROPERTIES
    let cityName: String
    let  weatherID: Int
    let temperatura: Double
    
    
    // THIS TWO PROPERTIES ARE CALLED COMPUTED PROPERTIES
    // MUST BE 'VAR'
    var newTemp: String{
        return String(format: "%.1f", temperatura)
    }
    
    var weatherName: String{ // Valor Computado
        switch weatherID {
        case 200...232:
            return "cloud.bolt.rain" // Tormenta
        case 300...321:
            return "cloud.drizzle" // Llovizna
        case 500...531:
            return "cloud.rain" // LLUVIA
        case 600...622:
            return "cloud.snow" // NIEVE
        case 701...781:
            return "cloud.sun" // AMBIENTE
        case 800:
            return "sun.max" // DESPEJADO
        case 801...804:
            return "cloud" // NUBLADO
        default:
            print("Clima no registrado!")
            return "exclamationmark.icloud"
        }
    }
}
