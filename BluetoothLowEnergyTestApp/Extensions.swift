//
//  Extensions.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/7/23.
//

import Foundation
import SwiftUI

 
extension LinearGradient {
    init(_ colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) {
        self.init(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}
