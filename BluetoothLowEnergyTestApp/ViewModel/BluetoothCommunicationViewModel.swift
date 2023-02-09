//
//  BluetoothCommunication.swift
//  BluetoothLowEnergyTestApp
//
//  Created by JC-Car key on 2/3/23.
//

import Foundation
import CoreBluetooth

class BluetoothCommunicationViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    private let targetDeviceName = "PHSWT180"
    public var centralManager: CBCentralManager?
    @Published var bluetoothDevicePeripheral: [BluetoothDeviceModel] = []
    @Published var temperatureData = ""
    @Published var humidityData = ""
    @Published var windPressure = ""
    @Published var airQuality = ""
    @Published var isProcessing = false;
    var bleTimer: Timer?
    
    
    override init() {
        super.init()
        self.centralManager  = CBCentralManager(delegate: self, queue: DispatchQueue.global())
        bluetoothDevicePeripheral = []
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            print("Bluetooth ON")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        print("Connected to the device")
        peripheral.discoverServices(getAllThingyServices())
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        DispatchQueue.main.async {
            self.centralManager?.stopScan()
            self.isProcessing = false
            self.bleTimer?.invalidate()
            let newItems = BluetoothDeviceModel(devicePeripheral: peripheral, deviceName: peripheral.name ?? "unknown device")
            self.bluetoothDevicePeripheral.append(newItems)
        }
        
    }
    
    
    func connectDevice(peripheral: CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
    }
    
    
    func scanLeDevice() {
        print("Scan Device")
        self.bleTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { bleTimer in
            print("Device not found")
            self.isProcessing = false
        })
        
        if self.centralManager?.state == .poweredOn {
            self.isProcessing = true
            self.centralManager?.scanForPeripherals(withServices: getAllThingyServices(),
                                                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        } else {
            print("Device Bluetooth is turned off!")
        }
    }
    
    
}

extension BluetoothCommunicationViewModel: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error == nil {
            for aService in peripheral.services! {
                
                
                if aService.uuid == getConfigurationServiceUUID() {
                    print("getConfigurationServiceUUID discovered")
                } else if aService.uuid == getUIServiceUUID() {
                    print("getUIServiceUUID discovered")
                } else if aService.uuid == getEnvironmentServiceUUID() {
                    print("getEnvironmentServiceUUID discovered")
                    
                    let environmentSericeUUIDArray: [CBUUID] = [getTemperatureCharacteristicUUID(),
                                                                getPressureCharacteristicUUID(),
                                                                getHumidityCharacteristicUUID(),
                                                                getAirQualityCharacteristicUUID(),
                                                                getLightIntensityCharacteristicUUID(),
                                                                getEnvironmentConfigurationCharacteristicUUID()]
                    
                    peripheral.discoverCharacteristics(environmentSericeUUIDArray, for: aService)
                    
                } else if aService.uuid == getMotionServiceUUID() {
                    print("getMotionServiceUUID discovered")
                } else if aService.uuid == getSoundServiceUUID() {
                    print("getSoundServiceUUID discovered")
                } else if aService.uuid == getSecureDFUServiceUUID() {
                    print("getSecureDFUServiceUUID discovered")
                } else if aService.uuid == getBatteryServiceUUID() {
                    print("getBatteryServiceUUID discovered")
                } else {
                    //Nothing to do
                }
            }
        } else {
            print(error!)
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error == nil {
            for aCharacteristic in service.characteristics! {
                print(aCharacteristic)
                peripheral.setNotifyValue(true, for: aCharacteristic)
            }
        } else {
            print(error!)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.isNotifying) {
            print("temp characteristic is notified")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            if characteristic.uuid == getTemperatureCharacteristicUUID() {
                print("Temperature Data Count: " , characteristic.value?.count as Any)
                DispatchQueue.main.async {
                    if let temperature = characteristic.value {
                        let digit        = Int8(truncatingIfNeeded: Int(temperature[0]))
                        let remainder    = UInt8(temperature[1])
                        var temp = Float(digit)
                        temp += Float(remainder) / 100
                        
                        self.temperatureData = String(format: "%.2f", temp)
                        print(self.temperatureData)
                    }
                }
                
                
            } else if characteristic.uuid == getHumidityCharacteristicUUID() {
                print("Humidity Data Count: " , characteristic.value?.count as Any)
                DispatchQueue.main.async {
                    if let humidity = characteristic.value {
                        self.humidityData = String(humidity[0])
                        print(self.humidityData)
                    }
                }
            } else if characteristic.uuid == getPressureCharacteristicUUID() {
                print("Pressure Data Count: " , characteristic.value?.count as Any)
                DispatchQueue.main.async {
                    if let data = characteristic.value {
                        var pressure : UInt32 = 0
                        var decimal  : UInt8  = 0
                        (data as NSData).getBytes(&pressure, range: NSRange(location: 0, length: 4))
                        (data as NSData).getBytes(&decimal, range: NSRange(location: 4, length: 1))
                        
                        var doubleVal = Double(pressure)
                        let decimalVal = Double(decimal)
                        if decimal < 10 {
                            doubleVal += decimalVal / 10
                        } else if decimal < 100 {
                            doubleVal += decimalVal / 100
                        } else {
                            doubleVal += decimalVal / 1000
                        }
                        self.windPressure = String(format: "%.2f", doubleVal)
                        print(doubleVal)
                    }
                }
            } else if characteristic.uuid == getAirQualityCharacteristicUUID() {
                print("Air Quality Data Count: " , characteristic.value?.count as Any)
                DispatchQueue.main.async {
                    if let data = characteristic.value {
                        var eCO2 : UInt16 = 0
                        var tvoc : UInt16  = 0
                        (data as NSData).getBytes(&eCO2, range: NSRange(location: 0, length: 2))
                        (data as NSData).getBytes(&tvoc, range: NSRange(location: 2, length: 2))
                        
                        self.airQuality = String(eCO2)
                        
                        print(eCO2)
                        print(tvoc)
                    }
                }
            }
        } else {
            print(error!)
        }
        
        
    }
    
    
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}



