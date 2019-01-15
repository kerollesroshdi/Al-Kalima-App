//
//  DesignableUIView.swift
//  radiotest02
//
//  Created by Kerolles Roshdi on 12/27/18.
//  Copyright © 2018 Kerolles Roshdi. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
}

}
}
