//
//  ViewController.swift
//  DollyControl
//
//  Created by Alejandro Hernández Cortés on 23/04/20.
//  Copyright © 2020 Alejandro Hernández Cortés. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreBluetooth
@available(iOS 13.0, *)
class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    struct DataPassed {
        var velocityData: Any
        var distanceABData: Any
        var distanceBCData: Any
        var delayTimeData: Any
    }
    
    var delay: Int?
    var finalVelocity : Int = 1
    var finalDistanceAB : Int = 0
    var finalDistanceBC : Int = 0
    var finalDelayTime : Int = 0
    var stopAlertActive = false
    var returnToHome = false

    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("Velocity value in ViewController: \(finalVelocity)")
        print("Distance AB value in ViewController: \(finalDistanceAB)")
        print("Distance BC value in ViewController: \(finalDistanceBC)")
        print("Delay Time value in ViewController: \(finalDelayTime)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstButton.layer.cornerRadius = 20
        firstButton.layer.masksToBounds = true
        secondButton.layer.cornerRadius = 20
        secondButton.layer.masksToBounds = true
        thirdButton.layer.cornerRadius = 20
        thirdButton.layer.masksToBounds = true
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
        
    }
    
    //Unwind To One from ParametersViewcontroller
    @IBAction func unwindToOne(_ sender: UIStoryboardSegue){}
    
    //Segue preparation to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as! OptionsViewController
            vc.delayTime = finalDelayTime
            vc.velocity = finalVelocity
            vc.distanceAB = finalDistanceAB
            vc.distanceBC = finalDistanceBC
            vc.optionsCharacteristics  = writeCharacteristic
            vc.optionsPeripheral = myBluetoothPeripheral
    }
    
    //Routine Actions
    @IBAction func oneDirectionButton(_ sender: AnyObject) {
            delay = finalDelayTime
            let ledOn = "A".data(using: .utf8)
            myBluetoothPeripheral.writeValue(ledOn!, for: writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            AlertService()
        }

    @IBAction func biDirectionButton(_ sender: AnyObject) {
            delay = finalDelayTime
            let ledOn = "B".data(using: .utf8)
            myBluetoothPeripheral.writeValue(ledOn!, for: writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            AlertService()
        }

    @IBAction func multipleDirectionButton(_ sender: AnyObject) {
            delay = finalDelayTime
            let ledOn = "C".data(using: .utf8)
            myBluetoothPeripheral.writeValue(ledOn!, for: writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            AlertService()
        }
    
   
    //Alert types
    func AlertService(){
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false, shouldAutoDismiss: false) // hide default button
                let alert = SCLAlertView(appearance: appearance) // create alert with appearance
                alert.addButton("Cancel") {
                    self.StopAlert()
                    let ledOff = "X".data(using: .utf8)
                    self.myBluetoothPeripheral.writeValue(ledOff!, for: self.writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
                    self.delay = 0
                    alert.hideView()
                }
                alert.showWait("Routine in Progress", subTitle: "Currently there is a routine active")
                //Creating delay time for progress alert
                let when: DispatchTime = DispatchTime.now() + DispatchTimeInterval.seconds(delay ?? 0)
                DispatchQueue.main.asyncAfter(deadline: when) {
                    if self.stopAlertActive == true {
                        self.delay = 0
                        alert.hideView()
                    }
                    self.ResetAlert()
                    
                    alert.hideView()
                }
        }
    
     func StopAlert(){
                stopAlertActive = true
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let innerAlert = SCLAlertView(appearance: appearance)
                innerAlert.addButton("Got it!") {
                }
                innerAlert.showError("Error", subTitle: "The process stopped")
        }
    
    func ResetAlert(){
        if self.stopAlertActive == true{
            stopAlertActive = false
            return
        }else {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let innerAlert = SCLAlertView(appearance: appearance)
                innerAlert.addButton("Return to home position") {
                    self.returnToHome = true
                    if self.returnToHome == true {
                        print ("Return to home")
                        let ledOff = "X".data(using: .utf8)
                        self.myBluetoothPeripheral.writeValue(ledOff!, for: self.writeCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
                        self.returnToHome = false
                        print(self.returnToHome)
                    }
                }
                innerAlert.showSuccess("Routine Finished", subTitle: "")
                }
        }
    
  

//Bluetooth Configuration (Scan for peripherals and automatically connects to module 'MLT-BT05')

        var manager : CBCentralManager!
        var myBluetoothPeripheral : CBPeripheral!
        var writeCharacteristic : CBCharacteristic!
        let myCustomService = "FFE0"
        let writeChar = "FFE1"
        var peripheralNames = [String]()
        var isMyPeripheralConected: Bool!
    
   

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
           
           var msg = ""
           
           switch central.state {
               
           case .poweredOff:
               msg = "Bluetooth is Off"
           case .poweredOn:
               msg = "Bluetooth is On"
               manager.scanForPeripherals(withServices: nil, options: nil)
           case .unsupported:
               msg = "Not Supported"
           default:
               msg = "😔"
               
           }
           
           print("State: " + msg)
           
       }
       
       
       func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
           peripheralNames.append(peripheral.name ?? "Unknown Device")
           //print(peripheral)
           //print("Name: \(peripheral.name)") //print the names of all peripherals connected.
           
           //you are going to use the name here down here ⇩
           
           //if peripheral.name == "" { //if is it my peripheral, then connect B13400262
               
               //self.myBluetoothPeripheral.append(peripheral)      //save peripheral
               //self.myBluetoothPeripheral.delegate = self
               
               //manager.stopScan()                          //stop scanning for peripherals
               //manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
               
           //}
    
           print(peripheralNames)
           let deviceName = "MLT-BT05"
           let deviceNameFound = peripheral.name
               if deviceNameFound == deviceName {
                    isMyPeripheralConected = true
                   print("Device found")
                   manager.stopScan()
                   print("Stopped scanning")
                   myBluetoothPeripheral = peripheral
                   peripheral.delegate = self
                   manager.connect(myBluetoothPeripheral, options: nil)
               }
                  else {
                    isMyPeripheralConected = false
                    print("Could not find the device")
                  }
          //myTableView.reloadData()
       }
    
       
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Module succesfully connected")
           //peripheral.delegate = self
           peripheral.discoverServices([CBUUID(string: "FFE0")])
           peripheral.delegate = self
           let state = peripheral.state == CBPeripheralState.connected ? "Yes" : "No"
            print("Connected:\(state)")
       }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
                print("Discover Service Error: \(String(describing: error))")
            }else {
                print("Discovered Service")
                for service in peripheral.services!{
                    print("Service: \(service)")
                    let aService = service as CBService
                    if service.uuid == CBUUID(string: myCustomService){
                    peripheral.discoverCharacteristics(nil, for: aService)
                    }
                }
              //  print(peripheral.services!)
                //print("Done")
            }
        }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics!{
            let aCharacteristic = characteristic as CBCharacteristic
            if characteristic.uuid == CBUUID(string: writeChar){
                print("Characteristic found")
                print("Characteristic: \(characteristic)")
                writeCharacteristic = aCharacteristic
            }
            //print("Characteristics\(characteristic)")
        }
    }

   
    
}
