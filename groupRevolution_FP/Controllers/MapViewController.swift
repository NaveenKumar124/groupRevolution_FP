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

    @IBOutlet weak var navigationButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var segueLongitude: Double!
    var segueLatitude: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         mapView.delegate = self
               
               locationManager.delegate = self
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.startUpdatingLocation()
               showSavedLocation()
    }
    
    
    @IBAction func btnShowRoute(_ sender: UIButton) {
        
    }
    
    @IBAction func navButtonPressed(_ sender: UIButton) {
        
        let dest = CLLocationCoordinate2D(latitude: segueLatitude, longitude: segueLongitude)
               getDirection(dest: dest)
        
    }
    
    func showSavedLocation(){
        
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let location = CLLocationCoordinate2D(latitude: segueLatitude!, longitude: segueLongitude!)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = Annotations(coordinate: location, identifier: "pinAnnotation")
        
        //        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    
    func getDirection(dest: CLLocationCoordinate2D){
        
        let source = MKMapItem(placemark:MKPlacemark(coordinate: mapView.userLocation.coordinate))
        let dest = MKMapItem(placemark: MKPlacemark(coordinate: dest))
        
        MKMapItem.openMaps(with: [source , dest], launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving ])
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline{
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            renderer.lineWidth = 2
            
            return renderer
            
        }
        return MKOverlayRenderer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           navigationController?.isToolbarHidden = true
       }
       override func viewWillDisappear(_ animated: Bool) {
           navigationController?.isToolbarHidden = false
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
