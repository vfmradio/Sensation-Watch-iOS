//
//  DeviceControlViewController.swift
//  Sensation Watch
//
//  Created by Chriz Chow on 2/26/17.
//  Copyright © 2017 Sensation. All rights reserved.
//

import Foundation
import UIKit

class DeviceControlViewController: UIViewController, bleDeviceControlDelegate {
    
    // IBOutlets for connecting the view
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var heartRate: UILabel!
    @IBOutlet weak var footStep: UILabel!
    @IBOutlet weak var caloriesBurnt: UILabel!
    @IBOutlet weak var timesync: UIButton!
    @IBOutlet weak var editpersonaldata: UIButton!
    @IBOutlet weak var disconnect: UIButton!
    // Our business logic
    var devCtrlObj = bleDeviceControl()
    
    // MARK: - i18n Strings for displaying on UI:
    let str_OK = NSLocalizedString("OK", comment: "okay")
    let str_CONNECTED = NSLocalizedString("Connected", comment: "connected bt")
    let str_DISCONNECTED = NSLocalizedString("Disconnected", comment: "disconnected bt")
    let str_CONNECT_FAIL = NSLocalizedString("Fail to Connect", comment: "fail connect bt")
    let str_BTSTATE_STRANGE = NSLocalizedString("strange", comment: "strange state in bt")
    let str_SERVICE_FOUND = NSLocalizedString("Found Services", comment: "found bt service")
    let str_SERVICE_NOT_FOUND = NSLocalizedString("No Services", comment: "not found bt service")
    let str_CAHRS_FOUND = NSLocalizedString("Characteristics Found", comment: "found bt chars")
    let str_CAHRS_NOT_FOUND = NSLocalizedString("No Characteristics", comment: "not found bt chars")
    let str_NOTI_REGISTERED = NSLocalizedString("Registered", comment: "registered  bt notfication")
    
    @IBAction func onClick_synctime(_ sender: UIButton) {
        devCtrlObj.syncTime()
    }
    
    @IBAction func onClick_disconnect(_ sender: UIButton) {
        devCtrlObj.disconnectDevice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable all buttons until further action:
        timesync.isEnabled = false
        editpersonaldata.isEnabled = false
        disconnect.isEnabled = false
        
        //connect device immediately:
        devCtrlObj.connectDevice();
        
    }
    
    //iOS BT state update:
    func updateState(state: bleStatus){
        switch(state){
        case bleStatus.Bluetooth_OFF:
            connectionStatusLabel.text = str_DISCONNECTED
        default:
            connectionStatusLabel.text = str_BTSTATE_STRANGE
        }
    }
    
    //watch BT connection update:
    func deviceConnectionUpdate(state: connectionStatus){
        switch(state){
        case .connected:
            //update text:
            connectionStatusLabel.text = str_CONNECTED
            connectionStatusLabel.textColor = UIColor.blue
            //enable buttons:
            disconnect.isEnabled = true
            editpersonaldata.isEnabled = true
            
        case .disconnected:
            connectionStatusLabel.text = str_DISCONNECTED
            connectionStatusLabel.textColor = UIColor.gray
        case .failToConnect:
            connectionStatusLabel.text = str_CONNECT_FAIL
            connectionStatusLabel.textColor = UIColor.red
        }
    }
    
    func foundService(success: Bool){
        if(success){
            //update text:
            connectionStatusLabel.text = str_SERVICE_FOUND
            connectionStatusLabel.textColor = UIColor.orange
        }else{
            //update text:
            connectionStatusLabel.text = str_SERVICE_NOT_FOUND
            connectionStatusLabel.textColor = UIColor.red
        }
        
    }
    
    func foundCharacteristics(success: Bool){
        if(success){
            //update text:
            connectionStatusLabel.text = str_CAHRS_FOUND
            connectionStatusLabel.textColor = UIColor.orange
            //enable time sync button:
            timesync.isEnabled = true
            
        }else{
            //update text:
            connectionStatusLabel.text = str_CAHRS_NOT_FOUND
            connectionStatusLabel.textColor = UIColor.red
        }
    }
    
    func registeredCharacteristics(){
        //update text:
        connectionStatusLabel.text = str_NOTI_REGISTERED
        connectionStatusLabel.textColor = UIColor.green
    }
    
    func characteristicUpdated_HeartRate(beatcount: Int){
        //update text:
        heartRate.text = "\(beatcount)"
        //change color:
        if(beatcount < 30 || beatcount > 180){
            heartRate.textColor = UIColor.red
        }else{
            heartRate.textColor = UIColor.black
        }
    }
    
    func characteristicUpdated_FootStep(stepcount: Int){
        //update text:
        footStep.text = "\(stepcount)"
        
    }
    
    
    
}
