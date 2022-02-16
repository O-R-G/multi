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

    // would be better to use a proper delegate hmm ...
    // WKCrownSequencer *sequencer = self.crownSequencer;
    // [sequencer focus];
    // [sequencer isHapticFeedbackEnabled: TRUE];
    // sequencer.delegate = self;
    // https://stackoverflow.com/questions/9861538/assigning-to-iddelegate-from-incompatible-type-viewcontroller-const-strong
    // need to declare delegate in .h
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

    if(paused) {
        [self initTimer];
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeStart];
    } else {
        [self killTimer];
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeStart];
    }
}

// action: rotate digital crown
// result: adjust display speed

// this should be done with a delegate see
// https://dev.to/no2s14/how-to-use-wkcrowndelegate-in-watchos-development-1lj9

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
