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

    self.crownSequencer.delegate = self;
}

- (void)willActivate {
    [self.crownSequencer focus];

    // This method is called when
    // watch view controller is about to be visible to user
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
}

- (void)initWatchOS {

    // instance variables
    hz = 15;

    // properties
    eye = [NSArray arrayWithObjects: @",", @".", @"*", @"+", @"-", @"—", @":", @";", @"•", @"°", @"‘", @"’", nil];
    mouth = [NSArray arrayWithObjects: @"o", @"+", @"-", @"+", @"–", @"/", @"∘", @"=", @"~", @".", @"-", @"×", @"*", nil];
    
    _hz_slider = 25;
    [hzSlider setValue:_hz_slider];

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
    [[NSRunLoop currentRunLoop] addTimer:multiTimer forMode:NSDefaultRunLoopMode];
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

    if(paused) {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeStart];
        [self initTimer];
    } else {
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeStart];
        [self killTimer];
    }
}

// action: rotate digital crown
// result: adjust display speed

// this should be done with a delegate see
// https://dev.to/no2s14/how-to-use-wkcrowndelegate-in-watchos-development-1lj9

- (void) crownDidRotate:(WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta {

   /*
        update dtheta (used to calculate mHz)
        dtheta is the time delta between updates:

        7 segments per digit and 6 digits
        so to draw all digits is 42 updates
        1.0 hz = 1 cycle / second = 1.0 / 42 = 0.0238

        desired range is 0.25 hz - 2.0 hz

            0.1 f < hz < 30.0f      (default = 15.0f)

        _hz_slider is used to update slider in range:

            0 < _hz_slider < 50
    */

    if (rotationalDelta > 0 && _hz_slider < 50) _hz_slider++;
    if (rotationalDelta < 0 && _hz_slider > 1) _hz_slider--;

    hz = 0.1f + (30.0f - 0.1f) * (_hz_slider - 0) / (50 - 0);
    
    [group setBackgroundColor:[UIColor darkGrayColor]];
    [hzSlider setHidden:0];
    [hzSlider setValue:_hz_slider];
    
    if(paused)
        [self killTimer];
    else {
        [self killTimer];
        [self initTimer];
    }
}

- (void) crownDidBecomeIdle:(WKCrownSequencer *)crownSequencer {
    // nothing for now
    [NSThread sleepForTimeInterval:0.1f];
    [hzSlider setHidden:1];
    [group setBackgroundColor:[UIColor whiteColor]];
}

@end
