//
//  ListRowView.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/6/23.
//

import SwiftUI
import CoreBluetooth

struct ListRowView: View {
    let item: BluetoothDeviceModel
    var body: some View {
        HStack{
            Text(item.deviceName)
        }
        .font(.caption)
        .foregroundColor(.black)
        .padding(.vertical, 8)
    }
}

struct ListRowView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            //ListRowView(item: item1)
        }
        .previewLayout(.sizeThatFits)
    }
}
