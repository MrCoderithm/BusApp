//
//  WeatherTable1ViewController.swift
//  w9TvApp
//
//  Created by Jawaad Sheikh on 2016-10-11.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import UIKit

class Weather1ViewController: UIViewController {

    // Step 12b - define variables for custom view
    @IBOutlet var imgCity : UIImageView!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var lblTemperature : UILabel!
    @IBOutlet var lblSummary : UILabel!
    let cityData = CityDetails()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateWeather(select: 0)
        
    }

    // Step 12c - define method to update view
    func updateWeather(select : Int)
    {
        imgCity.image = UIImage(named: cityData.cities[select])
        lblCity.text = cityData.cityNames[select]
        cityData.getDataFromJson(selected: select)
        
        lblTemperature.text = cityData.title
        lblSummary.text = cityData.summary
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
