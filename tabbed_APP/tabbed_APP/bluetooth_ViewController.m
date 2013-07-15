/*
 * The MIT License
 *
 *  Created by Jasin Alili on 21.04.13.
 *  Copyright (c) 2013 Jasin Alili. All rights reserved.
 *  Email: jasin@aon.at
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "bluetooth_ViewController.h"

@implementation bluetooth_ViewController


- (void)viewDidLoad
 {
    [super viewDidLoad];
    
    // Start the CBCentralManager for BT
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // incoming data storage
    _data = [[NSMutableData alloc] init];
}

- (void)didReceiveMemoryWarning
 {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
 {
    // cancel, if the view is not showing
    [self.centralManager stopScan];
    NSLog(@"Stopped Scanning");
    
    [super viewWillDisappear:animated];
}

// required method -> checks for LE Support, checks if central BT is on!
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
 {
    if (central.state != CBCentralManagerStatePoweredOn)
        return;
    
    [self scan];
}


// Scan for peripherals - 128bit CBUUID
- (void)scan
 {
     // service UUID for device information
     CBUUID *uid = [CBUUID UUIDWithString:@"180A"];
     
     // dictionary with options
     NSDictionary *scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
     
     // central manager has to scan for peripheral devices
     [self.centralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:uid] options:scanOptions];
    
    NSLog(@"Scanning started");
}


// This callback comes whenever a peripheral is advertising the UUID
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *) peripheral
                                                    advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
 {
     
    NSLog(@"Discovered device %@ at %@", peripheral.name, RSSI);
   
    if (self.discoveredPeripheral != peripheral) {
        self.discoveredPeripheral = peripheral;
        NSLog(@"Try to connect to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// connection fails
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 {
    NSLog(@"Connection failed: %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}

// to be implemented
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
 {
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
 {
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
 {
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
 {
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
 {
}

// Once the disconnection happens
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 {
    NSLog(@"Disconnected.");
    self.discoveredPeripheral = nil;
    
    // start scanning again
    [self scan];
}

// Connection done, clean up 
- (void)cleanup
 {
    // if we're not connected, nothing to do
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}
  

@end


