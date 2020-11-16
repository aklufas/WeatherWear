//
//  API Pull -  Weather.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import Foundation
// maps to information from API, must be unique to API

//to get inside of JSON output from API key
struct DailyWeather: Decodable {
    var weather: [Conditions]
    var main: TempDetail
    var wind: WindDetail
}

struct Conditions: Decodable {
    var icon = "" //string
    var description = "" //string
}

struct TempDetail: Decodable { //only Min
    var temp_min =  0.0 //Double
    var temp_max  =  0.0 //Double
    var feels_like =  0.0 //Double
    var temp = 0.0
    var humidity  = 0 //Int
    
}

struct WindDetail: Decodable {
    var speed =  0.0 // Double
    var deg = 1 // Int
}


//creating function to deal with errors
enum TempError:Error {
    case noDataAvailable
    case canNotProcessData
}

enum WindError: Error{
    case noDataAvailable
    case canNotProcessData
}

enum ConditionError: Error {
    case noDataAvailable
    case canNotProcessData
}

//API Call Within this Struct
struct WeatherRequest {
    
    //base of API call
    let resourceURL: URL
    let API_KEY = "fcb8c95d8335d44d6a013e1b3acaf585"
    
    //building API URL based on user input
    init(zipCode: String) {
        let resourceString = "https://api.openweathermap.org/data/2.5/weather?zip=\(zipCode),us&appid=\(API_KEY)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    /* Pulling 'main' from open weather API call
     ACCESS: TEMP (K), TEMP MIN (K), TEMP MAX (K), FEELS_LIKE (K),
            PRESSURE (hPa), HUMIDITY (%)
     */
    func getWeatherTemps(completion: @escaping(Result<TempDetail, TempError>)  -> Void ){ //added throws here
    print("Here in WeatherRequest > getWeatherTemps")
        //work within here to get the data from the API
     let dataTempTask = URLSession.shared.dataTask(with: resourceURL){data, _, _ in
        //Check for errors
        guard let jsonData = data else {
             completion(.failure(.noDataAvailable)) // added try here
            //this is where the thing needs to stop if the zip code is invalid
              

             //throw TempError.noDataAvailable
             print("Here in WeatherRequest > getWeatherTemps > no data ")
             return
         }
        //Decode JSON File
         do{
            let decoder = JSONDecoder()
            //decode JSON file from highest level
            let weatherResponse = try decoder.decode(DailyWeather.self, from: jsonData)
            //create TempDetail Object
            let tempObject  = weatherResponse.main
            print("Here in WeatherRequest > getWeatherTemps > do loop")
            print("this is the 'tempObject': \(tempObject)")
             completion(.success(tempObject))
             
         }
         catch{
            print("Here in WeatherRequest > getWeatherTemps > no processing data ")
             completion(.failure(.canNotProcessData))
         }
     }
     dataTempTask.resume()
    }
    
     /* Pulling 'wind' from open weather API call
        ACCESS: SPEED (m/s), DEGREE (0 deg = N, 90 deg = E, etc) */
    func getWindValues(completion: @escaping(Result<WindDetail, WindError>) -> Void ){
        //work within here to get the data from the API
        let dataWindTask = URLSession.shared.dataTask(with: resourceURL){data, _, _ in
            //Check for errors
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
         }
        //Decode JSON File
         do{
            let decoder = JSONDecoder()
            //create WindDetail Object
            let weatherResponse = try decoder.decode(DailyWeather.self, from: jsonData)
            //create WindDetail Object
            let windObject = weatherResponse.wind
            completion(.success(windObject))
             
         }
         catch{
             completion(.failure(.canNotProcessData))
         }
     }
     dataWindTask.resume()
    }
    
    /* Pulling 'weather' from open weather API call
        ACCESS: DESCRIPTION, ICON  */
    func getConditionDescription (completion: @escaping(Result<[Conditions], ConditionError>) -> Void ){
        //work within here to get the data from the API
        let descriptionTask = URLSession.shared.dataTask(with: resourceURL){data, _, _ in
            //Check for errors
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
        //Decode JSON File
        do{
            let decoder = JSONDecoder()
           //create ConditionDescrtiption Object
            let weatherResponse = try decoder.decode(DailyWeather.self, from: jsonData)
           //create ConditionDescription Object
            let weatherDescription = weatherResponse.weather
            completion(.success(weatherDescription))
            
            }
            catch{
                completion(.failure(.canNotProcessData))
            }
        }
        descriptionTask.resume()
        
        
    }

    
}





