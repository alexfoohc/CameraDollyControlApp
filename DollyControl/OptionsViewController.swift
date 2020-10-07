//
//  OptionsViewController.swift
//  
//  
//  Created by Alejandro Hernández Cortés on 04/05/20.
//  Copyright © 2020 Alejandro Hernández Cortés. All rights reserved.


import UIKit
import CoreBluetooth
@available(iOS 13.0, *)
class OptionsViewController: UIViewController {

    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var delayTimeSlider: UISlider!
    @IBOutlet weak var delayTimeLabel: UILabel!
    @IBOutlet weak var distanceABSlider: UISlider!
    @IBOutlet weak var distanceBCSlider: UISlider!
    @IBOutlet weak var timeDelayLabel: UILabel!
    @IBOutlet weak var distanceABLabel: UILabel!
    @IBOutlet weak var distanceBCLabel: UILabel!

    
    var velocity: Int = 1, distanceAB: Int = 0, delayTime : Int = 0, distanceBC:Int = 0
    var optionsPeripheral : CBPeripheral!
    var optionsCharacteristics : CBCharacteristic!
    var stringVelocity : String = ""
    var stringDistanceAB : String = ""
    var stringDistanceBC : String = ""
    var stringDelayTime : String = ""
    var arrayData = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("New value velocity: \(velocity)")
        print("New value distance: \(distanceAB)")
        print("New value time delay: \(delayTime)")
        print("New value distance B-C: \(distanceBC)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    
    //Sliders Section
    @IBAction func velocityChanged(_ sender: Any) {
    velocitySlider.isContinuous = false
                   velocitySlider.value = roundf(velocitySlider.value)
                   velocity = Int(velocitySlider.value)
                   stringVelocity = String(velocity)
           arrayData.insert(stringVelocity, at: 0)
    }
    
    @IBAction func distanceABChanged(_ sender: Any) {
    distanceABSlider.isContinuous = true
            distanceABSlider.value = roundf(distanceABSlider.value)
            distanceAB = Int(distanceABSlider.value)
            distanceABLabel.text = ("\(distanceAB) cm")
    }
    
    @IBAction func distanceABFinal(_ sender: Any) {
                distanceABSlider.isContinuous = false
                distanceABSlider.value = roundf(distanceABSlider.value)
                distanceAB = Int(distanceABSlider.value)
                stringDistanceAB = String(distanceAB)
                arrayData.insert(stringDistanceAB, at: 1)
    
    }
    
    @IBAction func distanceBCChanged(_ sender: Any){
                distanceBCSlider.value = roundf(distanceBCSlider.value)
                distanceBC = Int(distanceBCSlider.value)
                distanceBCLabel.text = ("\(distanceBC) cm")
    }
  
    @IBAction func distanceBCFinal(_ sender: Any) {
                distanceBCSlider.value = roundf(distanceBCSlider.value)
                distanceBC = Int(distanceBCSlider.value)
                stringDistanceBC = String(distanceBC)
                arrayData.insert(stringDistanceBC, at: 2)
    }
    
    @IBAction func delayTimeChanged(_ sender: Any) {
                 delayTimeSlider.value = roundf(delayTimeSlider.value)
                 delayTime = Int(delayTimeSlider.value)
                delayTimeLabel.text = ("\(delayTime) s")
                 //stringDelayTime = String(delayTime)
                

     }
    
     @IBAction func delayTimeFinal(_ sender: Any) {
                    delayTimeSlider.isContinuous = false
                 delayTimeSlider.value = roundf(delayTimeSlider.value)
                 delayTime = Int(delayTimeSlider.value)
                 stringDelayTime = String(delayTime)
                 arrayData.insert(stringDelayTime, at: 3)
     }
    
    //Save Button- It sends the data via HM-10 
    @IBAction func saveButtonPressed(_ sender: Any) {
       /* let arrayPassed = "\(arrayData)".data(using: .utf8)
        optionsPeripheral.writeValue(arrayPassed!, for: optionsCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
        print(arrayData)*/
        let arrayPassed = "\(arrayData)".data(using: .utf8)
        optionsPeripheral.writeValue(arrayPassed!, for: optionsCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
      /*let velocityPassed = "\(String(describing: velocity))".data(using: .utf8)
        optionsPeripheral.writeValue(velocityPassed!, for: optionsCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
        let distanceABPassed = "\(String(describing: distanceAB))".data(using: .utf8)
        optionsPeripheral.writeValue(distanceABPassed!, for: optionsCharacteristics, type: CBCharacteristicWriteType.withoutResponse)
        let distanceBCPassed = "\(String(describing: distanceBC))".data(using: .utf8)
        optionsPeripheral.writeValue(distanceBCPassed!, for: optionsCharacteristics, type: CBCharacteristicWriteType.withoutResponse)*/
        
    }

    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.finalDelayTime = delayTime
        vc.finalVelocity = velocity
        vc.finalDistanceAB = distanceAB
        vc.finalDistanceBC = distanceBC
        vc.myBluetoothPeripheral = optionsPeripheral
        vc.writeCharacteristic = optionsCharacteristics
        }
    
}

