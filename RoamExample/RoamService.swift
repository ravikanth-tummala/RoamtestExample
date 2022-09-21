//
//  RoamService.swift
//  Lifestream
//
//  Created by Hiran Peiris on 2022-09-20.
//  Copyright © 2022 Guardian Pty Ltd. All rights reserved.
//

import CoreLocation
import Roam
import UIKit

let current_userId = "632ae1c48ce7db1ca1b39b3c"
let subscribe_userId = "632ae845081252331fb5f6fd"
let subscribe_userId1 = "632ae2558e218e1f1fd227ff"
let publishable_key = ""
class RoamService {
    
    init() {
//        DispatchQueue.global(qos: .background).async {
            Roam.setLoggerEnabled(logger: true)
            Roam.initialize(publishable_key)
            Roam.delegate = self
//        }
    }
    
    
    private func requestLocation() {
//        DispatchQueue.global(qos: .background).sync {
            print("Roam.isLocationEnabled()", Roam.isLocationEnabled())
            print("CLLocationManager.locationServicesEnabled()", CLLocationManager.locationServicesEnabled())
            if Roam.isLocationEnabled() == false && CLLocationManager.locationServicesEnabled() {
                Roam.requestLocation()
            }
//        }
    }
    
    func getUser() {
//        DispatchQueue.global(qos: .background).sync {
            Roam.getUser(current_userId) { user, error in
                if error == nil {
                    print("Get User -> \(user?.userId ?? "unknown")")
                    self.requestLocation()
                }else{
                    print("onError -> ErrorCode:\(error?.code ?? "unknown") -> ErrorMesage:\(error?.message ?? "unknown")")
                }
            }
//        }
    }
    
    func toggleListener(){
//        DispatchQueue.global(qos: .background).sync {
            Roam.toggleListener(Events: true, Locations: true)
            Roam.publishSave()
            Roam.enableAccuracyEngine()
//        }
    }

    
    func subscribe(){
//        DispatchQueue.global(qos: .background).sync {
            Roam.subscribe(.Location, current_userId)
            Roam.subscribe(.Location, subscribe_userId)
            Roam.subscribe(.Location, subscribe_userId1)
//        }
    }
    
    func startTracking() {
//        DispatchQueue.global(qos: .background).async {
            if Roam.isLocationEnabled() {
                Roam.startTracking(.active)

//                Roam.subscribe(.Location, "6323c3b497f30b06252b0629")
//                Roam.subscribe(.Location, "6322bb5a06f8a019ea72ef5e")
//                Roam.subscribe(.Location, "6322bb788ce7db2f1b24c28c")
//                Roam.subscribe(.Location, "6322b98406f8a01856a66d2a")
            }
//        }
    }
    
    func stopTracking() {
//        DispatchQueue.global(qos: .background).async {
            Roam.unsubscribe(.Location, subscribe_userId)
            Roam.unsubscribe(.Location, subscribe_userId1)
//            Roam.unsubscribe(.Location, "6322bb5a06f8a019ea72ef5e")
//            Roam.unsubscribe(.Location, "6322bb788ce7db2f1b24c28c")
//            Roam.unsubscribe(.Location, "6322b98406f8a01856a66d2a")
            Roam.stopTracking()
//        }
    }
}

extension RoamService: RoamDelegate {
    func didUpdateLocation(_ locations: [RoamLocation]) {
        print("didUpdateLocation user: ", locations[0].description)
    }
    
    func didReceiveEvents(_ events: RoamEvents) {
        
    }
    
    func didReceiveUserLocation(_ location: RoamLocationReceived) {
        print("didReceiveUserLocation -> debugDescription:\(location.debugDescription), userID:\(location.userId ?? "unknown")")
        
        let dict:[String:Any] = ["userId":location.userId!,"latitude":location.latitude,"longitude":location.longitude]
        NotificationCenter.default
                    .post(name: NSNotification.Name("contactLocationUpdate"),
                     object: nil,
                     userInfo: dict)
    
    }
    
    func onError(_ error: RoamError) {
        print("onError -> ErrorCode:\(error.code ?? "unknown") -> ErrorMesage:\(error.message ?? "unknown")")
    }
}
 
