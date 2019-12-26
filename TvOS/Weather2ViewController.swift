//
//  Weather2ViewController.swift
//  w9TvApp
//
//  Created by Jawaad Sheikh on 2016-10-11.
//  Copyright © 2016 Jawaad Sheikh. All rights reserved.
//

import UIKit

// step 1 - create the storyboard with collectionview
// and splitview
// step 2 add delegate stuff
class Weather2ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    // step 3 - create city details object
    let cityData = CityDetails()
    @IBOutlet var collectionView1 : UICollectionView!
    let reuseIdentifierFeatured = "FeaturedCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Step 4 - Collection View Methods
    
    // Step 4b - define spacing between images
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 50
    }
   
    // Step 4c - add flare to selected item

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 50.0, bottom: 0.0, right: 50.0)
    }
   
    // Step 4d - define number of row groups
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    // Step 4e - define number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView == self.collectionView1)
        {
            
            return cityData.cities.count
        }
        
        return 0
    }
    
    
        // Step 4f - define how cell will look
     func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.collectionView1)
        {
            // Step 5 create custom cell for collection view
            let cell : FeaturedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifierFeatured, for: indexPath as IndexPath) as! FeaturedCollectionViewCell
            
            let  imageFilename = cityData.cities[indexPath.row]
            cell.featuredImage.image = UIImage(named: imageFilename)
            cell.lblCity.text = cityData.cityNames[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // Step 6 - define for selecting - have alert box pop up
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        cityData.getDataFromJson(selected : indexPath.row)
        self.showAlert(status: cityData.summary, title: cityData.title)
        
        
    }
    
    // Step 6b - method for alert box
    func showAlert(status: String, title:String) {
        let alertController = UIAlertController(title: status, message: title, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(ok)
        
        self.present(alertController, animated: true) {
        }
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
