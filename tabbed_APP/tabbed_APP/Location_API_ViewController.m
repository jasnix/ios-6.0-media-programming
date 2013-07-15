/*
 * The MIT License
 *
 *  Created by Jasin Alili on 20.04.13.
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

#import "Location_API_ViewController.h"

@implementation Location_API_ViewController 

// automatically creates setter and getter methods for the properties!
@synthesize locationManager, currentLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // 100.0f means the accurate distance of the gps-signal in meteres!
    // if we wouldn't do, it would take longer to find the nearest signal, so we save battery
    // by stopping the update, if we have found the signal once.
    /*
    if(newLocation.horizontalAccuracy <= 100.0f)
    {
        [locationManager stopUpdatingLocation];
    }
    */
    
    // if the updating is not stopped, this method will get periodically called every second
    // if it has a reachable signal! 
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    float longitude = coordinate.longitude;
    float latitude = coordinate.latitude;
    
    NSLog(@"Longitude : %f",longitude);
    NSLog(@"Latitude : %f", latitude);

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // if the user denies to access to find his position, stop searching!
    if(error.code == kCLErrorDenied)
    {
        [locationManager stopUpdatingLocation];
    }
    // if the process isn't able to immediatly find the position, this error occurs, keep searching anyway
    else if(error.code == kCLErrorLocationUnknown)
    {
        // try again, don't stop 
    }
    // in other situations, magnetic field, tunnel, or something else inform the user, that retrieving the location is worse
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end