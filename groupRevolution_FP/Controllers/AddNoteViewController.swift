//
//  AddNoteViewController.swift
//  groupRevolution_FP
//
//  Created by Syed Nooruddin Fahad on 24/06/20.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import UIKit
import AVFoundation

class AddNoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate , AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var catagoryTextField: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    var newNote: NSManagedObject?
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    @IBOutlet weak var icMap: UIBarButtonItem!
    
    var context: NSManagedObjectContext?
    
    var categoryName: String?
    var isNewNote = true
    var isToSave = false
    var noteTitle: String?
    
    
    
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
    
    // MARK: Saving Note on Button Click
    
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
                    if (txtTitle.text!.isEmpty || txtDescription.text! == "Write Note...." || txtDescription.text!.isEmpty || catagoryTextField.text!.isEmpty){
                        // empty field
                        okAlert(title: "None Of The Fields Can Be Empty!!")
                        
                    }else{
                        self.addData()
                        isNewNote = false
                    }
                    
                } else{
                    okAlert(title: "Note With Name '\(txtTitle.text!)' Already Exists!")
                    isNewNote = true
                }
            }catch{
                print(error)
            }
            
        }else{
            
            addData()
            
        }
    }
    
    func addData(){
        if isNewNote{
            newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context!)
        }
        
        newNote!.setValue(txtTitle.text!, forKey: "title")
        newNote!.setValue(txtDescription.text!, forKey: "descp")
        newNote!.setValue(categoryName!, forKey: "category")
        let createdDate =  isNewNote ? Date() : (newNote?.value(forKey: "dateTime")! as! Date)
        newNote!.setValue(createdDate, forKey: "dateTime")
        newNote!.setValue(catagoryTextField.text!.uppercased(), forKey: "category")
        let lat = isNewNote ? currentLocation.latitude : newNote?.value(forKey: "lat") as! Double
        newNote?.setValue(lat, forKey: "lat")
        let long = isNewNote ? currentLocation.longitude : newNote?.value(forKey: "long") as! Double
        newNote?.setValue(long, forKey: "long")
        
        updateCatagoryList()
        // save image to file
        saveImageToFile()
        saveData()
        
        isToSave = true
        okAlert(title: isNewNote ? "Note saved successfully!!" : "Updated successfully!!")
    
    }
    
    func updateCatagoryList(){
        var catagoryPresent = false
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        request.returnsObjectsAsFaults = false
        
        // we find our data
        do{
            let results = try context?.fetch(request) as! [NSManagedObject]
            
            for r in results{
                if catagoryTextField.text! == (r.value(forKey: "catname") as! String) {
                    catagoryPresent = true;
                    break
                }
            }
        } catch{
            print("Error2...\(error)")
        }
        
        if !catagoryPresent{
            
            let newFolder = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context!)
            newFolder.setValue(catagoryTextField.text!, forKey: "catname")
            saveData()
        }
    }
    
    func saveImageToFile(){
        let url = URL(fileURLWithPath: getFilePath("/\(txtTitle.text!)_img.txt"))
        
        // write to path
        do{
            try noteImageView.image?.pngData()!.write(to: url)
            //.write(toFile: filePath, atomically: true, encoding: .utf8)
        }catch{
            print(error)
        }
    }
    
    func saveData(){
        do{
            try context!.save()
        }catch{
            print(error)
        }
    }
    
    func okAlert(title: String){
        let titleString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        
        let alertController = UIAlertController(title: "" , message: nil, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            if self.isToSave{
                self.navigationController?.popViewController(animated: true)
            }
            self.isToSave = false
        }
        okAction.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Image functions
    
    @objc func choosePhoto(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let action = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                    case .authorized: // The user has previously granted access to the camera.
                        self.present(imagePicker, animated: true, completion: nil)
                    case .notDetermined: // The user has not yet been asked for camera access.
                        AVCaptureDevice.requestAccess(for: .video) { granted in
                            if granted {
                                self.present(imagePicker, animated: true, completion: nil)
                            }
                        }
                    default:
                        return
                }
            }
            else{
                self.cameraNotAvailable()
            }
        }))
        action.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        action.addAction(UIAlertAction(title: "cancel", style:.cancel, handler: nil ))
        self.present(action, animated: true, completion: nil)
    }
    
    func cameraNotAvailable(){
        
        let action = UIAlertController(title: "Camera not available", message: "", preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
           
           // new note
           noteImageView.image = image
           
           //old note
           
           picker.dismiss(animated: true, completion: nil)
           saveImageToFile()
           
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MapViewController{
            dest.segueLatitude = newNote?.value(forKey: "lat") as! Double
            dest.segueLongitude = newNote?.value(forKey: "long") as! Double
            
        }
        if let iv = segue.destination as? ViewController{

            iv.image = noteImageView.image

        }
    }
    

}

extension AddNoteViewController: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtDescription.text == "Write Note...."{
            txtDescription.text = ""
        }
        txtDescription.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
    }
    
}

