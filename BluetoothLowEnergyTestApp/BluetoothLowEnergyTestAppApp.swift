//
//  BluetoothLowEnergyTestAppApp.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/3/23.
//

import SwiftUI



@main
struct BluetoothLowEnergyTestAppApp: App {
    
    @StateObject var bluetoothCommViewModel: BluetoothCommunicationViewModel = BluetoothCommunicationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                BluetoothScanningView()
            }
            .environmentObject(bluetoothCommViewModel)
        }
    }
}
