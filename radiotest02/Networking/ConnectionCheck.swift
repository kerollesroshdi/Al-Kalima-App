//
//  ConnectionCheck.swift
//  radiotest02
//
//  Created by Kerolles Roshdi on 1/15/19.
//  Copyright © 2019 Kerolles Roshdi. All rights reserved.
//

import UIKit


func checkConnection() {
    let net = NetworkReachabilityManager()
    net?.startListening()
    
    net?.listener = { status in
        if net?.isReachable ?? false {
            
            switch status {
                
            case .reachable(.ethernetOrWiFi):
                debugPrint("The network is reachable over the WiFi connection")
                
                
            case .reachable(.wwan):
                debugPrint("The network is reachable over the WWAN connection")
                
            case .notReachable:
                debugPrint("The network is not reachable")
                
                let alertController = UIAlertController(title: "Connection Error", message:
                    "The network is not reachable", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
               
                
            case .unknown :
                debugPrint("It is unknown whether the network is reachable")
                
                let alertController = UIAlertController(title: "Connection Error", message:
                    "It is unknown whether the network is reachable", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
}
