//
//  Weather1TableViewController.swift
//  w9TvApp
//
//  Created by Jawaad Sheikh on 2016-10-13.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import UIKit

// step 7 - drag a splitview into the storyboard
// step 8 - create a UITableViewController based VC
class Weather1TableViewController: UITableViewController {

    // step 9 - define CityDetails() object
    let cityData = CityDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // Step 10 - set number of rows to array length
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityData.cityNames.count
    }

    // Step 11 - define how cell will look
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Step 11b - create custom cell and define reuse
        // identifer - also configure how cell looks in
        // storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell

        // Configure the cell...
        cell.lblCity.text = cityData.cityNames[indexPath.row]
        cell.imgCity.image = UIImage(named:cityData.cities[indexPath.row])
        return cell
    }
 
    // Step 12 - define how data is transferred 
    // to detail view controller
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //  let cell = tableView.cellForRow(at: indexPath)
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            let detailViewController = controllers[controllers.count-1]
                as? Weather1ViewController
            detailViewController?.updateWeather(select: indexPath.row)
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false wif you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let svc = segue.destination as! Weather1ViewController
        
        svc.select = self.select
        
        
    }*/
    

}
