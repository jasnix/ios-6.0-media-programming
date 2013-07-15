/*
 * The MIT License
 *
 *  Created by Jasin Alili on 18.04.13.
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

#import "SMS_ViewController.h"

@implementation SMS_ViewController

- (void)loadView
{
    [super viewDidLoad];
    // [self sendSMS:@"Hello World SMS!" recipientList:[NSArray arrayWithObjects:@"+436641234567", nil]];
    [self sendMMS];
}

// creates the sms with a messageviewcontroller, which is a standard userinterface for sending sms
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *vcontroller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        vcontroller.body = bodyOfMessage;
        vcontroller.recipients = recipients;
        vcontroller.messageComposeDelegate = self;
        [self presentViewController:vcontroller animated:YES completion:nil];
    }
}

 - (void)sendMMS
{
    // copies the image to the clipboard, to manually add it than to the Message App
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    // pasteboard.image = [UIImage imageNamed:@"ME.png"];    
    
    NSString *phoneToCall = @"sms:";
    NSString *phoneToCallEncoded = [phoneToCall stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:phoneToCallEncoded];

    // open the Message App from apple, leaving this app!
    [[UIApplication sharedApplication] openURL:url];
    
    /*
    // set the text for the Message App
    // generate the SMS View Controller
    MFMessageComposeViewController *vcontroller = [[MFMessageComposeViewController alloc] init];

    if([MFMessageComposeViewController canSendText]) {
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"Text of the Email Buddy."];
        vcontroller.recipients = [NSArray arrayWithObject:@"+436641234567"];
        vcontroller.body = emailBody;
        vcontroller.messageComposeDelegate = self;
        [self presentViewController:vcontroller animated:YES completion:nil];
    }
     */
    
}

// This method gets automatically called by the delegate object!
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    if (result == MessageComposeResultCancelled)
        NSLog(@"SMS cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"SMS sent");
    else
        NSLog(@"SMS failed");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
