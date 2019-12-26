//
//  CustomPointAnnotation.swift
//  BusApp
//
//  Created by Xcode User on 2019-12-08.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import Foundation
import MapKit

class CustomPointAnnotation: NSObject, MKAnnotation
{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coor: CLLocationCoordinate2D)
    {
        coordinate = coor
    }
}
