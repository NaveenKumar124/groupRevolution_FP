//
//  Annotations.swift
//  groupRevolution_FP
//
//  Created by Navi Malhotra on 2020-06-25.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import Foundation
import MapKit

class Annotations: NSObject, MKAnnotation{
    
    init(coordinate: CLLocationCoordinate2D, identifier: String){
        self.coordinate = coordinate
        self.identifier = identifier
    }
    
    var coordinate: CLLocationCoordinate2D
    var identifier: String
    
}
