//
//  UIimageView Extention.swift
//  radiotest02
//
//  Created by Kerolles Roshdi on 12/26/18.
//  Copyright © 2018 Kerolles Roshdi. All rights reserved.
//

import UIKit

extension UIImageView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 3
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
        debugPrint("rotation animation created")
    }
    
    func pauseAnimation(){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        debugPrint("rotation animation paused")
    }
    
    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        debugPrint("rotation animation resumed")
    }
    
//    func stopAnimation() {
//        self.layer.removeAllAnimations()
//    }
    

}
