/*
 * The MIT License
 *
 *  Created by Jasin Alili on 09.04.13.
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

#import "WEB_ViewController.h"

@implementation WEB_ViewController

@synthesize websiteName;
@synthesize activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.web_view setOpaque:NO];
    // self.activityIndicator.hidden = TRUE;
    //[self.web_view setBackgroundColor:[UIColor clearColor]];
    
    self.websiteName = @"tuwien.ac.at";
    self.title = self.websiteName;
    NSString *URL = [NSString stringWithFormat:@"http://www.%@", self.websiteName];
    NSURL *websiteURL = [NSURL URLWithString:URL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:websiteURL];
    
    // first variant open via view, without safari-app    
    [self.web_view loadRequest:requestObj];
    
    
    // second variant
    // [self web_viewing: self.web_view shouldStartLoadWithRequest:requestObj navigationType: UIWebViewNavigationTypeLinkClicked];
    
    // third variant via button and textfield and navigation controlller 
    /*
    URL = [NSString stringWithFormat:@"http://www.%@", self.websiteName];
    websiteURL = [NSURL URLWithString:URL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:websiteURL];
    [self.web_view loadRequest:requestObj];
    */
    
}

// first variant loads automatically via web_view controller -----------------

// second variant opens via Safari --------------------------
- (BOOL)web_viewing:(UIWebView *)web_view shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    // Test if URL ist local Fileurl for the Iphone
    NSURL *url = [request URL];
    if ([url isFileURL])
        return YES;
    
    [[UIApplication sharedApplication] openURL:url];
    return YES;
}


// third variant with button and textfield ---------------------------
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowWebsite"]) {
        WEB_ViewController *website = [segue destinationViewController];
        website.websiteName = @"tuwien.ac.at";
    }
}


// Optional UIWebViewDelegate delegate methods
-(void)webViewDidStartLoad:(UIWebView *)web_view
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    self.activityIndicator.hidden = FALSE;
//    [self.activityIndicator startAnimating];
}


-(void)webViewDidFinishLoad:(UIWebView *)web_view
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    self.activityIndicator.hidden = TRUE;
//    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)web_view didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // Garbage Collector does the work automatic 
}

/* // IF Garbage Collection would not be active, the Release of the Memory must be done manually!
 - (void)dealloc 
 {
    [self.web_view setDelegate:nil];
    [self.web_view release];
    [self.activityIndicator release];
    [super dealloc];
 }
 
 // Set ivar to null, to release them afterwards! 
 - (void)viewDidUnload 
 {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.web_view.delegate = nil;
    self.web_view = nil;
    self.activityIndicator = nil;
 }
 */

@end
