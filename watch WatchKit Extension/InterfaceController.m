//
//  InterfaceController.m
//  watch WatchKit Extension
//
//  Created by david reinfurt on 11/21/21.
//  Copyright © 2021 O-R-G, Inc. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController ()

@end


@implementation InterfaceController

@synthesize group;
@synthesize eye;
@synthesize mouth;
@synthesize leftEyeLabel;
@synthesize rightEyeLabel;
@synthesize mouthLabel;
@synthesize hzSlider;
@synthesize singleTapRecognizer;


- (void)awakeWithContext:(id)context {
    // Configure interface objects here.
    [self initWatchOS];

    WKCrownSequencer *sequencer = self.crownSequencer;
    [sequencer focus];
    sequencer.delegate = self;
}

- (void)willActivate {
    // This method is called when
    // watch view controller is about to be visible to user
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

- (void)initWatchOS {

    // instance variables
    hz = 10;

    // properties
    eye = [NSArray arrayWithObjects: @",", @".", @"*", @"+", @"-", @"—", @":", @";", @"•", @"°", @"‘", @"’", nil];
    mouth = [NSArray arrayWithObjects: @"o", @"+", @"-", @"+", @"–", @"/", @"∘", @"=", @"~", @".", @"-", @"×", @"*", nil];
    
    [self initTimer];
}

- (void) initTimer {

    period = 1.0/hz;
    multiTimer = [NSTimer
                  scheduledTimerWithTimeInterval:period
                  target:self
                  selector:@selector(multiTimerCallBack)
                  userInfo:nil
                  repeats:YES
                  ];
    [[NSRunLoop currentRunLoop]
     addTimer:multiTimer
     forMode:NSDefaultRunLoopMode
     ];
    paused = false;
}

- (void) killTimer {

    [multiTimer invalidate];
    multiTimer = nil;
    paused = true;
}

- (void) multiTimerCallBack {

    // AudioServicesPlaySystemSound (self.soundFileObject);
    // AudioServicesPlaySystemSound (1305);
    
    int i = arc4random_uniform((int)eye.count);
    leftEyeLabel.text = eye[i];
    
    i = arc4random_uniform((int)eye.count);
    rightEyeLabel.text = eye[i];
    
    i = arc4random_uniform((int)mouth.count);
    self.mouthLabel.text = mouth[i];
}


// ------------------------------------------------------
// ACTIONS
// ------------------------------------------------------

// action: single tap
// result: pause

- (IBAction)singleTapAction:(id)sender {

    if(paused)
        [self initTimer];
    else
        [self killTimer];
}

// action: rotate digital crown
// result: adjust display speed

- (void) crownDidRotate:(WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta {

    // surely an easier way to do this with % 

    if (rotationalDelta > 0 && _hz_delta < 50) _hz_delta++;
    if (rotationalDelta < 0 && _hz_delta > 1) _hz_delta--;

    hz = _hz_delta; // adjust to map onto hz range, refer to ios app

    // ** for debug **
    // NSString *name = [NSString stringWithFormat:@"%d", _hz_delta];
    // self.mouthLabel.text = name;
    
    // make hzSlider visible, update value
    
    [hzSlider setHidden:0];
    [hzSlider setValue:hz];
    
    [group setBackgroundColor:[UIColor darkGrayColor]];
    /*
     [rightEyeLabel setTextColor:[UIColor darkGrayColor]];
    [leftEyeLabel setTextColor:[UIColor darkGrayColor]];
    [mouthLabel setTextColor:[UIColor darkGrayColor]];
    */
    
    if(paused)
        [self killTimer];
    else {
        [self killTimer];
        [self initTimer];
    }
}

- (void) crownDidBecomeIdle:(WKCrownSequencer *)crownSequencer {
    // nothing for now
    [NSThread sleepForTimeInterval:0.5f];
    [hzSlider setHidden:1];
    [group setBackgroundColor:[UIColor whiteColor]];
    /*
    [rightEyeLabel setTextColor:[UIColor blackColor]];
    [leftEyeLabel setTextColor:[UIColor blackColor]];
    [mouthLabel setTextColor:[UIColor blackColor]];
     */
    
    // if(paused)
    //    [self initTimer];
}

@end
