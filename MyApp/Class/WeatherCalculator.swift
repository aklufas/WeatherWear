//
//  WeatherCalculator.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import Foundation

/* Translates Kelvin to Farenheit for Display */
func kelvinToFarenheit(temp: Double) -> Double {
    let tempFarenheit = (temp - 273.15) * (9/5) + 32
    print(tempFarenheit.rounded())
    return tempFarenheit.rounded()
}

/*Selects Image from Repository when Recommending Coat*/
func decideCoat(min: Double) -> String {
    
    //based on temp recommend coat
    let minF = kelvinToFarenheit(temp: min)
    var coatPic = ""
    
    if minF < 32.0{
        coatPic = "winterCoat"
    }
    else if 32.0 < minF && minF <= 55.0 {
        coatPic = "rainCoat"
    }
    else if 55.0 < minF && minF <= 65.0  {
        coatPic = "sweatshirt"
    }
    else if minF == 0 {
        coatPic = "weather icons"
    }
    else{
        coatPic = "noCoat"
    }
    return coatPic
}

//to select weather icon to display in app
func selectWeatherIcon(min: Double) -> String{
    
    return ""
}

func convertToMPH(speed: Double) -> Double {
    return speed * 2.23
}

//exponential func
func pow(a: Double, b: Double) -> Double{
    return a * b
}


//returns feel  of temp in WindChill
func calculateWindChillMPH(airTemp: Double, speed: Double) -> Double{
    let exponential = pow(airTemp,  0.16)
    let windChill = 35.74 + 0.6215*airTemp - 35.75*exponential + 0.4275*airTemp*exponential
    return windChill
}

//Returns  string of current time, will want to change to time value ?
//I will come back to this
func currentTime() -> String {
    
    let now = Date()

    let formatter = DateFormatter()

    formatter.timeZone = TimeZone.current

    formatter.dateFormat = "HH:mm"

    let dateString = formatter.string(from: now)
    
    
    print(type(of: dateString))
    print(dateString.prefix(2))
    let numHour = Int(dateString.prefix(2))
    print(numHour ?? (Any).self)
    return dateString
}


func errorMessage(err: String, zip: String){
    // display error message
    
    print("\(zip) is not a valid zip code.\nPlease enter a different zip code.")
}
