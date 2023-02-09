//
//  EnvironmentCardView.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/7/23.
//

import SwiftUI

struct EnvironmentCardView: View {
    var iconName: String
    var index: String
    var measure: String
    
    var body: some View {
        ZStack {
            //MARK: Card
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color("Card Background"))
                .shadow(color: Color("Card Shadow"), radius: 40, x: 0, y: 20)
                .overlay {
                    // MARK: Card Border
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
            
            
            VStack(spacing: 10) {
                // MARK: Circle Icon
                Image(systemName: iconName)
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 80, height: 80)
                    .background(LinearGradient([Color("Temperature Ring 1"),
                                                Color("Temperature Ring 2")], startPoint: .top, endPoint: .bottom))
                    .clipShape(Circle())
                
                VStack(spacing: 8) {
                    // MARK: Index
                    Text(index)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // MARK: Measure
                    Text(measure)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(1.0)
                }
                
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            
        }
        .frame(width: 155, height: 180)
        
        
    }
}

struct EnvironmentCardView_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentCardView(iconName: "humidity.fill", index: "Humidity", measure: "50%")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
