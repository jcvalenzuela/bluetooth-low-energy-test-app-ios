//
//  BluetoothOperationView.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/3/23.
//

import SwiftUI
import CoreBluetooth

struct BluetoothOperationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var bluetoothCommViewModel: BluetoothCommunicationViewModel
    let item: BluetoothDeviceModel
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                // MARK: Title
                Text(item.deviceName)
                    .font(.title)
                    .foregroundColor(.white)
                
                // MARK: Card View
                ScrollView{
                    VStack(spacing: 20) {
                        // MARK: THINGY ENVIRONMENT DISPLAY
                        HStack(spacing: 20) {
                            // MARK: Humidity
                            EnvironmentCardView(iconName: "humidity.fill", index: "Humidity", measure: bluetoothCommViewModel.humidityData + "%")
                            
                            // MARK: Temperature
                            EnvironmentCardView(iconName: "thermometer", index: "Temperature", measure: bluetoothCommViewModel.temperatureData + "°c")
                        }
                        
                        HStack(spacing: 20) {
                            // MARK: Humidity
                            EnvironmentCardView(iconName: "wind", index: "Presssure", measure: bluetoothCommViewModel.windPressure + "hPa")
                            
                            // MARK: Temperature
                            EnvironmentCardView(iconName: "cloud.fill", index: "Co2", measure: bluetoothCommViewModel.airQuality + "ppm")
                        }
                    }
                }
                
                // MARK: Button
                Button {
                    bluetoothCommViewModel.connectDevice(peripheral: item.devicePeripheral)
                } label: {
                    Text("Connect".uppercased())
                }
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding()
                
            }
            
        }
        
    }
}

struct BluetoothOperationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //            BluetoothOperationView(item: BluetoothDeviceModel(devicePeripheral: "", deviceName: ""))
        }
        
    }
}
