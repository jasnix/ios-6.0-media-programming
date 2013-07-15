/*
 * The MIT License
 *
 *  Created by Jasin Alili on 12.06.13.
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

#import "audio_ViewController.h"

@implementation audio_ViewController

@synthesize play_button, record_button, stop_button;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSpeaker];
    play_button.enabled = NO;
    stop_button.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    // Create recording path and settings for the audio recording
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"record.caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [audioRecorder prepareToRecord];
    }
}

// set from Standard Audio-Out to Bottom-Speaker
-(void)setSpeaker
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    OSStatus error = AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    if (error) NSLog(@"Couldn't configure speaker!");
}

// record the audio from microphone
- (IBAction)recordAudio:(id)sender
{
    if (!audioRecorder.recording)
    {
        play_button.enabled = NO;
        stop_button.enabled = YES;
        [stop_button setTitle:@"Stop Recording" forState:UIControlStateNormal];
        [audioRecorder record];
    }
}

// play the audio-record
- (IBAction)playAudio:(id)sender
{
    if (!audioRecorder.recording)
    {
        stop_button.enabled = YES;
        [stop_button setTitle:@"Stop Playing" forState:UIControlStateNormal];
        //stop_button.titleLabel.text = @"Stop Playing"; // would also change the title
        record_button.enabled = NO;
        
        /* ARC is on, so release is done by IOS!
         if (audioPlayer)
             [audioPlayer release];
        */
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:audioRecorder.url
                       error:&error];
        
        audioPlayer.delegate = self;
        [audioPlayer setVolume:1.0];    // set to maximum
        
        if (error)
            NSLog(@"Error: %@", [error localizedDescription]);
        else
            [audioPlayer play];
    }
}

// stop playing or stop recording
- (IBAction)stop:(id)sender
{
    stop_button.enabled = NO;
    [stop_button setTitle:@"Stop" forState:UIControlStateNormal];
    play_button.enabled = YES;
    record_button.enabled = YES;
    
    if (audioRecorder.recording) {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// AVAudioRecorderDelegate, AVAudioPlayerDelegate delegate methods - optional ---------------------
-(void)audioPlayerDidFinishPlaying: (AVAudioPlayer *)player successfully:(BOOL)flag
{
    record_button.enabled = YES;
    stop_button.enabled = NO;
    [stop_button setTitle:@"Stop" forState:UIControlStateNormal];
}

-(void)audioPlayerDecodeErrorDidOccur: (AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end