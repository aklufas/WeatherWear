//
//  WeatherObject.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import Foundation
import UIKit

class WeatherObject {

        //var requestedWeather =
        var tempObject = TempDetail()
        var windInfo = WindDetail()
        var conditionDescription = [Conditions]()
        var zipError = false
        //var weatherDescript = WeatherDescription()
    
        
    
        func enteredZip(num: String) {
            //print("Here in WeatherObject > enteredZip")
            let requestedWeather = WeatherRequest(zipCode: num) //WeatherRequest Object

            requestedWeather.getWeatherTemps { [weak self] temp_result in //weatherRequest Object
                //print("Here in WeatherObject > requestedWeather > preswiitch ")
                switch temp_result {
                    case .failure(let error):
                        self!.zipError = true
                       // throw
                        print(error)
    
                case .success(let temp_values):
                    //print("Here in WeatherObject > requestedWeather > self.tempObject ")

                    self!.tempObject = temp_values
                    //print(self!.tempObject)
                }
            }

            requestedWeather.getWindValues{ [weak self] wind_result in
                switch wind_result{
                    case .failure(let error):
                                print(error)
                    case .success(let wind_values):
                        self!.windInfo = wind_values
                        
                       
                    }
                }
            
            requestedWeather.getConditionDescription { [weak self] condition_result in
            switch condition_result{
                case .failure(let error):
                            print(error)
                case .success(let condition_values):
                    self!.conditionDescription = condition_values
                    
                }
            }
            
            
    }
}
