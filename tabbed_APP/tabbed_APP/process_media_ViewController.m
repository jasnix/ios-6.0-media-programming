/*
 * The MIT License
 *
 *  Created by Jasin Alili on 17.06.13.
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

#import "process_media_ViewController.h"
#import "ImageHelper.h"     // use of third-party Software, copyright reserved by (c) 2011 Paul Solt
                            // https://github.com/PaulSolt/UIImage-Conversion

@implementation process_media_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)open_album:(id)sender
{
    [self startMediaBrowserFromViewController:self usingDelegate:self];    
}

- (IBAction)tapped_screen:(id)sender
{
    NSLog(@"screen is tapped, dereference the image, close viewcontroller...\n");
    [imageView setImage:nil];
}

// open the photo library / camera roll 
- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
    {
        return NO;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

    // There is a camera on this device, show camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    [self presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

// reacts when the button choose is clicked --> DO THE TRANSFORMATION OF THE MEDIA!
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    // Transform the movie
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        NSLog(@"a video was choosen...\n");
        NSLog(@"%@", mediaType);
        
        
        // TODO:
        // Filter the movie here, and play it afterwards
        // *
        // *
        
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]
                                                 initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        [self presentMoviePlayerViewControllerAnimated:theMovie];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
    }
    else    // Transform the image 
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image)
        {
            NSLog(@"an image was choosen...");
            
            int imageWidth = image.size.width;
            int imageHeight = image.size.height;

            NSLog(@"width: %i and heigth: %i", imageWidth, imageHeight);
            
            // filter 1
            [self thresholdImage:image imageWidth:(int)imageWidth usingHeight:(int)imageHeight andtheImagePickerController:picker];
            // filter 2
            // [self loadImage:image imageWidth:imageWidth usingHeight:imageHeight andtheImagePickerController:picker];

        }
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}


// filter 1   -------------------------------------------------------------------------------------------
- (void) thresholdImage: (UIImage*)image imageWidth: (int)width usingHeight: (int)height andtheImagePickerController: (UIImagePickerController*)camera
{
    NSLog(@"image is getting transformed");
    NSLog(@"width: %i height: %i", width, height);
    
    // Representation of the image
    // NSData *imageData = UIImagePNGRepresentation(image);
    // NSData *dataObj = UIImageJPEGRepresentation(image, 1.0);
    // UIImage* img = [UIImage imageWithData:imageData];
    
    
    // Create a bitmap
    unsigned char *bitmap = [ImageHelper convertUIImageToBitmapRGBA8:image];
    
    // threshold the Bitmap
    for (int i = 40; i < width-40; i++)
    {
        for (int j = 40; j < height-40; j++)
        {
            int pixelpos = (i*4) + (j*4);        // get Bytes from Byte-Array of the Image, tmp -> pixelposition in Array!
            int v = *(bitmap + pixelpos);        // get the pixel in the pointer of the Byte Array!
       
            int r=(v &0xFF);
            int g = (v >> 8 & 0xFF);
            int b = (v >> 8 & 0xFF);
        
            int gray = (int) (0.299*r + 0.587*g + 0.114*b);
        
            if (gray>128)
                *(bitmap + pixelpos) = 255;      // 255 = White
            else
                *(bitmap + pixelpos) = 0;        // 0 = Black
            
        }
    }
    
    // Create a UIImage using the bitmap
    UIImage *imageCopy = [ImageHelper convertBitmapRGBA8ToUIImage:bitmap withWidth:width withHeight:height];
    
    // Display the image copy on the GUI
    imageView = [[UIImageView alloc] initWithImage:imageCopy];
    [self.view addSubview:imageView];
    NSLog(@"\n Display image.");
    
    // Cleanup
    // free(bitmap);
}



// filter 2    -------------------------------------------------------------------------------------------
- (void) loadImage: (UIImage*)image imageWidth: (int)width usingHeight: (int)height andtheImagePickerController: (UIImagePickerController*)camera
{
    UIImage *imageCopy;
    
    // Create a bitmap
    unsigned char *bitmap = [ImageHelper convertUIImageToBitmapRGBA8:image];
    /*
     CGImageRef imageRef = image.CGImage;
     CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipLast;
     
     CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
     CGContextRef bitmapContext = CGBitmapContextCreate(
     rgbs,
     width,
     height,
     CGImageGetBitsPerComponent(imageRef),
     width * 4,                  // Bytes per Row
     rgbColorSpace,              //CGImageGetColorSpace(imageRef)
     bitmapInfo);
     
     CGColorSpaceRelease(rgbColorSpace);
     */
    
    // Create a UIImage from array
    @try
    {
        int *rgbs = [self decodeYUV:bitmap imageWidth:width imageHeight:height];
        imageCopy = [ImageHelper convertIntArrayToUIImage:rgbs withWidth:width withHeight:height];
    }
    @catch (NSException *e)
    {
        NSLog(@"Exception: %@", e);        
    }

    
    if(imageCopy == nil)
        NSLog(@"decoding failed");
    else
    {
        // Display the image copy on the GUI
        imageView = [[UIImageView alloc] initWithImage:imageCopy];
        [self.view addSubview:imageView];
        NSLog(@"\n Display image.");
    }
    
    /*  output the first 20 pixel
     for (int j = 0; j < 20; j++)
     {
        NSLog(@" rgbs [%i] = %i ", j , *(rgbs+j));
     }     
     */

}

// Count the lenght of he ArrayPointer
- (unsigned long long int) countLength: (void *)ptrToArray
{
    unsigned long long int counter = 0;
    while(ptrToArray++)
        counter++;

    NSLog(@"counter = %lli", counter);
    return counter;
}

// originally from http://groups.google.com/group/android-developers/browse_thread/thread/c85e829ab209ceea/3f180a16a4872b58?lnk=gst&q=onpreviewframe#3f180a16a4872b58
// Converts a Byte Array in YUV to an int Array in RGB
- (int*) decodeYUV: (unsigned char*)fg imageWidth: (int)width imageHeight: (int)height
{
    int sz = width * height;
    int *out = malloc(sizeof(int) * sz);

  //  NSLog(@"out = %lli", [self countLength:out]);
  //  NSLog(@"fg = %lli", [self countLength:fg]);
  //  NSLog(@"sz = %i", sz);
    
    /*
    Information:
     Exceptions are resource-intensive in Objective-C.
     You should better not use exceptions for general flow-control."
     */
    if (out == nil)     // NSLog(@"buffer 'out' is null");
        @throw [NSException exceptionWithName:@"NullPointerException" reason:@"buffer 'out' is null." userInfo: nil];
    if ((sizeof(int) * sz) < sz)
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"buffer 'out' size < minimum" userInfo: nil];
    if (fg == nil)      // NSLog(@"buffer 'fg' is null");
        @throw [NSException exceptionWithName:@"NullPointerException" reason:@"buffer 'fg' is null." userInfo: nil];
    if ([self countLength:fg] < sz)
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"buffer 'fg' size < minimum" userInfo: nil];
    
    int i, j;
    int Y, Cr = 0, Cb = 0;
    
    for (j = 0; j < height; j++)
    {
        int pixPtr = j * width;
        int jDiv2 = j >> 1;
        for (i = 0; i < width; i++)
        {
            Y = fg[pixPtr];
            if (Y < 0)
                Y += 255;
            if ((i & 0x1) != 1)
            {
                int cOff = sz + jDiv2 * width + (i>>1) * 2;
                Cb = fg[cOff];
                if (Cb < 0)
                    Cb += 127;
                else
                    Cb -= 128;
                Cr = fg[cOff + 1];
                if (Cr<0)
                    Cr += 127;
                else
                    Cr -= 128;
            }
            
            int R = Y + Cr + (Cr >> 2) + (Cr >> 3) + (Cr >> 5);
            if (R<0)
                R = 0;
            else if (R > 255)
                R = 255;
            int G = Y - (Cb >> 2) + (Cb >> 4) + (Cb >> 5) - (Cr >>1)+ (Cr >> 3) + (Cr >> 4) + (Cr >> 5);
            if (G < 0)
                G = 0;
            else if (G > 255)
                G = 255;
            int B = Y + Cb + (Cb >>1) + (Cb >>2) + (Cb >>6);
            if (B<0)
                B = 0;
            else if (B>255)
                B = 255;
            out[pixPtr++] = 0xff000000 + (B<<16) + (G<<8) + R;
        }
    }    
    return out;
}

@end
