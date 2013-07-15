/*
 * The MIT License
 *
 *  Created by Jasin Alili on 26.06.13.
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

#import "snapshot_from_video_ViewController.h"

@implementation snapshot_from_video_ViewController

@synthesize preView, start_stop_button, snap_button;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupAVCapture];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
 

- (BOOL)setupAVCapture
{
	NSError *error = nil;
        
	AVCaptureSession *session = [AVCaptureSession new];
	[session setSessionPreset:AVCaptureSessionPresetHigh];
	
	// Select camera for input, back or front 
	AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
	if (error)
		return NO;
	if ([session canAddInput:input])
		[session addInput:input];
	
	stillImageOutput = [AVCaptureStillImageOutput new];
	if ([session canAddOutput:stillImageOutput])
		[session addOutput:stillImageOutput];
	
	// the preview layer shows the visual output of an AVCaptureSession
	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	[previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
	[previewLayer setFrame:[preView bounds]];
	[previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];    
	[self.view.layer insertSublayer:previewLayer atIndex:0];            // set at Level 0 = Background
    
    
    // start the capture session
    [session startRunning];
	
	return YES;
}

- (IBAction)takePicture:(id)sender
{
    // TODO ...
}

- (void)saveToLibrary
{
    // TODO ...
    // save to camera roll
	// ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	// NSLog(@"writing \"%@\" to photos album", outputURL);
    
}

- (IBAction)startStop:(id)sender
{
	if (running) {
		if (assetWriter) {
			[assetWriterInput markAsFinished];
            [assetWriter finishWritingWithCompletionHandler:^(){
                NSLog (@"writing finished");
            }];
            assetWriterInput = nil;
			assetWriter = nil;
			[self saveToLibrary];
		}
		[sender setTitle:@"Start"];
		[snap_button setEnabled:NO];
	}
	else {
		[sender setTitle:@"Stop"];
		[snap_button setEnabled:YES];
		
	}
	running = !running;
}

@end
