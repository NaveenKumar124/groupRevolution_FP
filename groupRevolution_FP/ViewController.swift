//
//  ViewController.swift
//  groupRevolution_FP
//
//  Created by Navi Malhotra on 2020-06-22.
//  Copyright © 2020 Naveen Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let i = image{
            imageView.image = i
        }
    }

    

}

