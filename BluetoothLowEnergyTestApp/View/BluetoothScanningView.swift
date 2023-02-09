//
//  BluetoothScanningView.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/3/23.
//

import SwiftUI
struct BluetoothScanningView: View {
    
    @EnvironmentObject var bluetoothCommViewModel: BluetoothCommunicationViewModel
    
    var body: some View {
        ZStack() {
            
            Color("Background")
                .ignoresSafeArea()
            
            VStack() {
                // MARK: Title
                Text("Bluetooth Low Energy")
                    .font(.title)
                    .foregroundColor(.white)
                
             
                HStack(alignment: .center, spacing: 20.0) {
                    // MARK: Bluetooth Logo
                    Image("Bluetooth")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    
                }
                .frame(height: 200)
                .frame(width: 200)
                .padding()
                
                // MARK: List View
                List {
                    ForEach(bluetoothCommViewModel.bluetoothDevicePeripheral) { item in
                        NavigationLink(destination: BluetoothOperationView(item: item)) {
                            
                            ListRowView(item: item)
                            
                            
                        }
                        
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .foregroundColor(Color("Background"))
                .cornerRadius(15)
                .padding()
                
                
                // MARK: Scan Button
                Button {
                    bluetoothCommViewModel.scanLeDevice()
                } label: {
                    Text("Scan".uppercased())
                }
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding()
                
                
                Spacer()
                Spacer()
                
                
            }
            
            // MARK: Connecting dialog
            if bluetoothCommViewModel.isProcessing {
                ProgressView("Scanning")
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(2)
                   
    
            }
            
        }
    }
}

struct BluetoothScanningView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BluetoothScanningView(bluetoothCommViewModel: .init())
        }
    }
}
