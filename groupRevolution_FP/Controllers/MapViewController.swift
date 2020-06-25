//
//  MapViewController.swift
//  groupRevolution_FP
//
//  Created by Navi Malhotra on 2020-06-25.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    var locationManager = CLLocationManager()
    var segueLongitude: Double!
    var segueLatitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
