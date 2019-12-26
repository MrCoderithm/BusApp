//
//  CityDetails.swift
//  w9TvApp
//
//  Created by Jawaad Sheikh on 2016-10-13.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import UIKit

class CityDetails: NSObject {
    
    // step 3b define arrays & add images to project
    let cities = ["toronto.jpg", "oakville.jpg", "burlington.jpg", "hamilton.jpg", "nyc.jpg"]
    
    let cityNames = ["Toronto", "Oakville", "Burlington", "Hamilton", "Missisauga"]
    
    let cityLatLong = [
        "https://api.forecast.io/forecast/d3250bf407f0579c8355cd39cdd4f9e1/43.653226,-79.383184",
        "https://api.forecast.io/forecast/d3250bf407f0579c8355cd39cdd4f9e1/45.501689,-73.567256",
        "https://api.forecast.io/forecast/d3250bf407f0579c8355cd39cdd4f9e1/45.638728,-122.661486",
        "https://api.forecast.io/forecast/d3250bf407f0579c8355cd39cdd4f9e1/37.774929,-122.419416",
        "https://api.forecast.io/forecast/d3250bf407f0579c8355cd39cdd4f9e1/40.712784,-74.005941"]
    
    // step 3c create variables to hold resulting weather data
    var title : String = ""
    var summary : String = ""

    // step 3d create method below to retrieve JSON weather
    func getDataFromJson( selected : Int)
    {
        // define url object based on weather url
        if let url = NSURL(string: cityLatLong[selected]) {
            // retrieve json data from url
            if let data = NSData(contentsOf: url as URL){
                do {
                    // convert json data to dictionary
                    let parsed = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    // retrieve dictionary for current forecast
                    let newDict = parsed as? NSDictionary
                    let cityForecast = newDict?["currently"] as? NSDictionary
                    title = "\(cityForecast!["temperature"]!)"
                    
                    summary = "\(cityForecast!["summary"]!)"
                   // self.showAlert(status: summary, title: title)
                }
                catch let error as NSError {
                    //print("A JSON parsing error occurred, here are the details:\n \(error)")
                    title = "A JSON parsing error occurred, here are the details: "
                    summary = error.description
                }
            }
        }

    }
    
}
