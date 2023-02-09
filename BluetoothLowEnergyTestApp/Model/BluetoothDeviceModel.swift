//
//  BluetoothDeviceModel.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/6/23.
//

import Foundation
import CoreBluetooth

struct BluetoothDeviceModel: Identifiable {
    var id: String = UUID().uuidString
    var devicePeripheral: CBPeripheral
    var deviceName: String
}
