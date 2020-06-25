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

class z: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate , AVAudioRecorderDelegate {
    
     @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var catagoryTextField: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
     @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var icMap: UIBarButtonItem!
    
    var context: NSManagedObjectContext?
    
    var categoryName: String?
    var isNewNote = true
    var isToSave = false
    var noteTitle: String?
    
    var newNote: NSManagedObject?
    
    var isPlaying = false
    var isRecording = false
    var recordingSession: AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var records = 0
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    let mainColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showCurrentNote(_ title: String){
        
        txtTitle.isEnabled = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do{
            let results = try context!.fetch(request)
            newNote = results[0] as! NSManagedObject
            
            txtTitle.text = newNote!.value(forKey: "title") as! String
            txtDescription.text = newNote!.value(forKey: "descp") as! String
            noteImageView.image = UIImage(contentsOfFile: getFilePath("/\(txtTitle.text!)_img.txt"))
            
        }catch{
            print("unable to fech note-data")
        }
    }
    
    // MARK: - file functions
    func getFilePath(_ fileName: String)->String{
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            let filePath = documentDirectory.appending(fileName)
            return filePath
        }
        return ""
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
