//
//  NotesTableViewCell.swift
//  groupRevolution_FP
//
//  Created by Syed Nooruddin Fahad on 23/06/20.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import CoreData
import UIKit
import CoreLocation

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    func setData(note: NSManagedObject){
        titleLabel.text = note.value(forKey: "title") as! String
        
        //get date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormat.string(from: note.value(forKey: "dateTime") as! Date)
        dateLabel.text = formattedDate

        //get time
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:MM:SS"
        let formattedTime = timeFormat.string(from: note.value(forKey: "dateTime") as! Date)
        timeLabel.text = formattedTime
        
        getAddress(lat: note.value(forKey: "lat") as! Double, long: note.value(forKey: "long") as! Double)
    }
    
        func getAddress(lat: Double, long: Double){
            var address = ""
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { (placemarks, error) in
                if let error = error{
                    print(error)
                    
                } else{
                    
                    if let placemark = placemarks?[0]{
                        if placemark.locality != nil{
                            address += placemark.locality!
                        }
                    }
                    if let placemark = placemarks?[0]{
                        if placemark.subAdministrativeArea != nil{                        address += ", \(placemark.subAdministrativeArea!), "
                        }
                    }
                    if let placemark = placemarks?[0]{
                        if placemark.administrativeArea != nil{
                            address += placemark.administrativeArea!
                        }
                    }
                    self.locationLabel.text = address
                }
            }
        }
}
