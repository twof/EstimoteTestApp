//
//  ViewController.swift
//  EstimoteTestApp
//
//  Created by fnord on 1/11/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import Foundation


struct BeaconDetails {
    var beaconConnection: ESTBeaconConnection?
    let beaconRegion: CLBeaconRegion?
    var selectedBeacon: ESTDeviceLocationBeacon?
    var major: Int?
    var minor: Int?
}

class ViewController: UIViewController, ESTBeaconManagerDelegate, ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate, ESTBeaconConnectionDelegate {
    
    var details = BeaconDetails(beaconConnection: nil, beaconRegion: CLBeaconRegion(proximityUUID: NSUUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")! as UUID, identifier: "monitored region"), selectedBeacon: ESTDeviceLocationBeacon(), major: 0, minor: 0)
    
    
    let deviceManager = ESTDeviceManager()
    let beaconManager = ESTBeaconManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        self.deviceManager.delegate = self
        
        
        //self.deviceManager.startDeviceDiscovery(with: ESTDeviceFilterLocationBeacon())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: self.details.beaconRegion!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
        if beacons.count > 0{
            let matchingBeacons = beacons.filter({ (beacon) -> Bool in
                beacon.proximityUUID == self.details.selectedBeacon?.peripheralIdentifier
            })
                
                //{ ($0 as CLBeacon).proximityUUID == self.details.selectedBeacon?.peripheralIdentifier }
            
            if matchingBeacons.count > 0{
                let match = matchingBeacons[0]
                self.details.beaconConnection = ESTBeaconConnection(beacon: match, delegate: self)
                self.details.minor = match.minor as Int?
                self.details.major = match.major as Int?
                print("minor: " + String(describing: self.details.minor))
                print("major: " + String(describing: self.details.major))
                print(self.details.beaconConnection?.proximityUUID ?? "failed")
            }
        }
    }
    
    func deviceManager(_ manager: ESTDeviceManager, didDiscover devices: [ESTDevice]) {
        if devices.count > 0 && devices[0] != self.details.selectedBeacon{
            self.details.selectedBeacon = (devices[0] as! ESTDeviceLocationBeacon)
            self.details.selectedBeacon?.delegate = self;
            
            self.details.selectedBeacon?.connect()
        }
    }

    // add these methods inside our ViewController class
    
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable) {
        print("Connected")
        

        print("uuid: " + (self.details.selectedBeacon?.peripheralIdentifier.uuidString)!)
        //print("major: " + (self.details.selectedBeacon?.settings?.iBeacon.minor.getValue().description)!)
        //print("minor: " + (self.details.selectedBeacon?.settings?.iBeacon.minor.getValue().description)!)
        
        //            self.beaconConnection = ESTBeaconConnection(proximityUUID: devices[0].peripheralIdentifier, major: ((devices[0] as! ESTDeviceLocationBeacon).settings?.iBeacon.major.getValue())!, minor: ((devices[0] as! ESTDeviceLocationBeacon).settings?.iBeacon.minor.getValue())!, delegate: self)
    }
    
    func estDevice(_ device: ESTDeviceConnectable,
                   didFailConnectionWithError error: Error) {
        print("Connnection failed with error: \(error)")
    }
    
    func estDevice(_ device: ESTDeviceConnectable,
                   didDisconnectWithError error: Error?) {
        print("Disconnected")
        // disconnection can happen via the `disconnect` method
        //     => in which case `error` will be nil
        // or for other reasons
        //     => in which case `error` will say what went wrong
    }
}

