//
//  ButtonExtension.swift
//  DollyControl
//
//  Created by Alejandro Hernández Cortés on 24/04/20.
//  Copyright © 2020 Alejandro Hernández Cortés. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration  =   0.3
        pulse.fromValue =   0.95
        pulse.toValue   =   1.0
        pulse.autoreverses  =   true
        pulse.repeatCount   =   1
        pulse.initialVelocity   =   0.8
        pulse.damping   =   0.1
        layer.add(pulse, forKey: nil)
    }
}

