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

class AddNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate , AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
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
    
    @objc func onTapped(){
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()
        catagoryTextField.resignFirstResponder()
    }
    
    //get user's current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location!.coordinate
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
    
    //MARK: Record audio
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if !isRecording {
            playButton.isHidden = true
            recordButton.backgroundColor = #colorLiteral(red: 0.006370984018, green: 0.4774341583, blue: 0.9984987378, alpha: 1)
            
            if audioRecorder == nil {
                //self.records += 1
                
                let url = URL(fileURLWithPath: getFilePath("/\(txtTitle.text!)_aud.m4a"))
                
                let settings = [AVFormatIDKey : kAudioFormatAppleLossless , AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue , AVEncoderBitRateKey : 320000 , AVNumberOfChannelsKey : 1 , AVSampleRateKey : 44100] as [String : Any]
                
                do {
                    audioRecorder = try AVAudioRecorder(url: url, settings: settings)
                    audioRecorder?.delegate = self
                    audioRecorder?.record()
                    isRecording = true
                } catch  {
                    print(error)
                }
            }
        }
            
        else{
            audioRecorder?.stop()
            audioRecorder = nil
            recordButton.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            isRecording = false
            playButton.isHidden = false
        }
    }
    
    // Mark: Play Audio
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        if !isPlaying{
            do {
                let url = URL(fileURLWithPath: getFilePath("/\(txtTitle.text!)_aud.m4a"))
                
                audioPlayer =  try AVAudioPlayer(contentsOf: url)
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
                audioPlayer.play()
                playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                isPlaying = true
            } catch  {
                print(error)
               
            }
        }else{
            
            audioPlayer.stop()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false
            
        }
    }
    
    // MARK: AudioPlayer finish Playing
       
       func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
           playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
       }
    @IBAction func btnSave(_ sender: UIButton) {
        
        if isNewNote{
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            do{
                let results = try self.context!.fetch(request)
                var alreadyExists = false
                if results.count > 0{
                    for result in results as! [NSManagedObject]{
                        if txtTitle.text! == result.value(forKey: "title") as! String{
                            alreadyExists = true
                            break
                        }
                    }
                }
                
                if !alreadyExists {
                    if (txtTitle.text!.isEmpty || txtDescription.text! == "Write note...." || txtDescription.text!.isEmpty || catagoryTextField.text!.isEmpty){
                        // empty field
                        okAlert(title: "None of the fields can be empty!!")
                        
                    }else{
                        self.addData()
                        isNewNote = false
                    }
                    
                } else{
                    okAlert(title: "Note with name '\(txtTitle.text!)' already exists!")
                    isNewNote = true
                }
            }catch{
                print(error)
            }
            
        }else{
            
            addData()
            
        }
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
