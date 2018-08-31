//
//  ViewController.swift
//  indroDataCommunication
//
//  Created by Benjamin Ursel on 2018-07-27.
//  Copyright © 2018 Indro Robotics. All rights reserved.
//

import UIKit
import DJISDK

class ViewController: UIViewController, DJISDKManagerDelegate, DJIOnboardSDKDeviceDelegate {
    
    //Create the DJIOnboardSDKDevice instance
    var onboardSDKDevice: DJIOnboardSDKDevice?
    
    //Label for communication with user
    @IBOutlet weak var labelView: UILabel!
    
    //Going to use this action to send data to the drone
    @IBAction func ConnectToDrone(_ sender: Any) {
        
        //creates 4 bytes of zeros
        let var1 = Data(count: 4)
        //Look into nil completion
        onboardSDKDevice?.sendDataFromMobile(toOnboard: var1, withCompletion: nil)
    }
    
    //label to display data
    @IBOutlet weak var dataDisplay: UILabel!
    
    
    //Once view appears this method will run
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DJISDKManager.registerApp(with: self)

    }
    
    //Once view loads (only happens once per lifecycle) this runs
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Shows registration alert (app has appropriate app key)
    func showAlertViewWithTitle(title: String, withMessage message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title:"OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // DJISDKManagerDelegate Methods
    func productConnected(_ product: DJIBaseProduct?) {
        //when product connects set the label and create and onboard object
        NSLog("Product Connected")
        labelView.text = DJISDKManager.product()?.model
        onboardSDKDevice = DJIOnboardSDKDevice()
        onboardSDKDevice?.delegate = self
        if(onboardSDKDevice != nil){
            dataDisplay.text = "Delegate set"
        }
    }
    
    func productDisconnected() {
        NSLog("Product Disconnected")
        labelView.text = "Product disconnected"
    }
    
    func appRegisteredWithError(_ error: Error?) {
        var message = "Register App Successed!"
        
        if (error != nil) {
            message = "Register app failed! Please enter your app key and check the network."
        }else{
            NSLog("Register App Successed!");
        }
        
        self.showAlertViewWithTitle(title:"Register App", withMessage: message)
    }
    
    //MARK: DJIOnboardSDKDevicDelegate Methods
    
    //This is for recieving data sent from the drone
    //This crashes app every time it is called
    func onboardSDKDevice(_ osdkDevice: DJIOnboardSDKDevice, didSendDataToMobile data: Data) {
        dataDisplay.text = "recieved data"
    }
    
    //Obj-C instance method for reference, from the framework
    //- (void)sendDataFromMobileToOnboard:(NSData *)data withCompletion:(DJICompletionBlock)completion;

}
