/*
 * The MIT License
 *
 *  Created by Jasin Alili on 16.06.13.
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

#import "snapshot_ViewController.h"

@implementation snapshot_ViewController

@synthesize snapshot_button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startCameraControllerFromViewController:self usingDelegate:self];
    
    // There is not a camera on this device, so don't show the camera button.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        snapshot_button.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// take another picture, button was pressed
- (IBAction)record_picture:(id)sender
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

// start camera UI
-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id )delegate
{
    // check if camera is available
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    
    // open the imagepicker/camera for recording
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    // cameraUI.allowsEditing = YES;   // allow to trim/scale the image
    cameraUI.delegate = delegate;
    [self presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

// save the image to the PhotoLibrary
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *image;  
    
    // check the image
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)== kCFCompareEqualTo) {
        
        image = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
        // Get the image metadata from the camera and not from the library!
        UIImagePickerControllerSourceType pickerType = picker.sourceType;
        if(pickerType == UIImagePickerControllerSourceTypeCamera)
        {
            NSDictionary *imgMetadata = [info objectForKey: UIImagePickerControllerMediaMetadata];
            
            // get the access to the photolibrary
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            ALAssetsLibraryWriteImageCompletionBlock imgWriteCompletionBlock = ^(NSURL *newURL, NSError *error) {
                if (error) {
                    NSLog( @"Error occured while saving the image to Photo Library: %@", error );
                } else {
                    NSLog( @"Saved the image with metadata to Photo Library");
                }
            };
            
            // Save the new image 
            [library writeImageToSavedPhotosAlbum:[image CGImage]
                                         metadata:imgMetadata
                                  completionBlock:imgWriteCompletionBlock];
        }
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}

// cancel button was pressed
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Let the Orientation happen by returning YES
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
    //return ( UIInterfaceOrientationPortrait == interfaceOrientation ); // == YES
}

// do a popup if an error occured
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *) error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Failure"
                              message: @"Failed to save the image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

@end














