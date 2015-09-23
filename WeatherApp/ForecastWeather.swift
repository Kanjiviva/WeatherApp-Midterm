//
//  ForecastWeather.swift
//  WeatherApp
//
//  Created by Steve on 2015-09-22.
//  Copyright © 2015 Steve. All rights reserved.
//

import Foundation

class ForecastWeather: NSObject {
    
    var cityName:String
    var country:String
    var currentTemp:Float
    var highestTemp:Float
    var lowestTemp:Float
    var humidity:Float
    var condition:String
    var weatherDesciption:String
    var time:Double
    
    init(cityName:String, country:String, currentTemp:Float, highestTemp:Float, lowestTemp:Float, humidity:Float, condition:String, weatherDesciption:String, time:Double) {
        self.cityName = cityName
        self.country = country
        self.currentTemp = currentTemp
        self.highestTemp = highestTemp
        self.lowestTemp = lowestTemp
        self.humidity = humidity
        self.condition = condition
        self.weatherDesciption = weatherDesciption
        self.time = time
    }
    
    
    
}