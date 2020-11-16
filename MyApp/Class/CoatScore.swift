//
//  CoatScore.swift
//  MyApp
//
//  Created by Muhammad Farooq on 11/16/20.
//

import Foundation
/*
 */

//RIP THESE TEMPS ARE IN KELVIN!

func coatScore(weatherInfo: WeatherObject) -> Double{ //takes in temp
    
    var score = 0.0
    
    
    //windchill check
    if weatherInfo.tempObject.temp <= 50.0 && convertToMPH(speed: weatherInfo.windInfo.speed) >= 10.0  {
        
        //calculate wind chill
        let val = calculateWindChillMPH(airTemp: weatherInfo.tempObject.temp, speed: weatherInfo.windInfo.speed)
        
        score = val * 0.10
        print("Val: \(val)")
        print("Score:  \(score)")
        
    }
    
    else{
        score = weatherInfo.tempObject.temp * 0.10
        print(weatherInfo.tempObject.temp)
        print("Score at first if/else: \(score)")
    }
    
    
    // OK I will figure this out later
    /*
    let time = currentTime()
    let hour = Int(time.prefix(2))
    
    //if time between 5p and 5 a recommend colder coat
    // 5p to midnight, midnight to 5 a
    // 17 p < x < 23  && 00 < x < 5
    if hour < 17 &&  >=
 */
    
    //if humidity greater than 65%, recommend colder coat
    if weatherInfo.tempObject.humidity >= 65 {
        score -= 0.5
        print("Score at humidity greater than 65 \(score)")
    }
    //if humidity between 55 and 65 % recommend cooler coat
    else if weatherInfo.tempObject.humidity >= 55 && weatherInfo.tempObject.humidity < 65{
        score -= 0.25
        print("Score at humidity greater than 55 - 65 \(score)")
    }
    // if below 55%, do nothing
    
    
    /*still need to add user preference / user profile */
    
    print("This is your coatscore: \(score)")
    return score
}

/*
 Count = 0 → higher = warmer, lower = colder 0-10 range
 //basic temp clause
 If current temp <= 50 && wind speed >= 10mph:
     Calculate Wind Chill
     Use This Value
     Multiply by 10% add to count

 If ^ !=  → Temp --> by increments of 10 from 0 - 100 , add 10% to count

 //time of day clause
 Check time on device or API Call:
 If time between 5p and 5a:
     Recommend colder coat
     Minus .5

 If time between 5a to 5p:
     Recommend warmer coat
 Plus .5

 User Preference
 If user prefers being warmer
     Minus .5

 If user prefers being colder
     Plus .5
  

 */

