//
//  AddNoteViewController.swift
//  groupRevolution_FP
//
//  Created by Syed Nooruddin Fahad on 24/06/20.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import AVFoundation
import CoreData
import CoreLocation
import UIKit

class AddNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate , AVAudioRecorderDelegate {
    
     @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var catagoryTextField: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
     @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var icMap: UIBarButtonItem!
    
   

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
