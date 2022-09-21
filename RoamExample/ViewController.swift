//
//  ViewController.swift
//  RoamExample
//
//  Created by GeoSpark on 21/09/22.
//

import UIKit
import Roam

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: Notification.Name("contactLocationUpdate"), object: nil)
        
        // Do any additional setup after loading the view.
    }
        
    @IBAction func getUserAction(_ sender: Any) {
        RoamService().getUser()
    }
    
    @IBAction func startTrackingAction(_ sender: Any) {
        RoamService().startTracking()
    }
    
    @IBAction func stopTrackingAction(_ sender: Any) {
        RoamService().stopTracking()
    }
    
    @IBAction func subscribeLocationAction(_ sender: Any) {
        RoamService().subscribe()
    }
    
    @IBAction func toggleAction(_ sender: Any) {
        RoamService().toggleListener()
    }
    
    @objc func updateLocation(_ notification: NSNotification){
        if let locationDict = notification.userInfo as? [String:Any] {
            DispatchQueue.main.async {
                self.label.text = "Received location \(locationDict.description)"
            }
        }
    }
}

