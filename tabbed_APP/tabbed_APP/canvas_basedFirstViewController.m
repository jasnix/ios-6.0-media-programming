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

#import "canvas_basedFirstViewController.h"

@implementation canvas_basedFirstViewController

// tells the father, that id laoded well
- (void)viewDidLoad
{
     [super viewDidLoad];
}

// didn't handle Memory, cause the Garbage-Collections does this for me since IOs 6.0
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// handle the touch of the buttons.
// after each use of self.viewRect.frame, the UIView gets updated, so the developer doesn't have to update the View
- (IBAction)click_right:(id)sender
{
    CGRect frame = self.viewRect.frame;
    frame.size.width += 10;
    self.viewRect.frame = frame;
}

- (IBAction)click_up:(id)sender
{
    CGRect frame = self.viewRect.frame;
    frame.size.height += 10;
    self.viewRect.frame = frame;
}

- (IBAction)click_down:(id)sender
{
    CGRect frame = self.viewRect.frame;
    frame.size.height -= 10;
    self.viewRect.frame = frame;
}

- (IBAction)click_left:(id)sender {
    CGRect frame = self.viewRect.frame;
    frame.size.width -= 10;
    self.viewRect.frame = frame;
}

@end