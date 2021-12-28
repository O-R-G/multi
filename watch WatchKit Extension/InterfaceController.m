//
//  InterfaceController.m
//  watch WatchKit Extension
//
//  Created by david reinfurt on 11/21/21.
//  Copyright © 2021 O-R-G, Inc. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController ()

@property (nonatomic) int num;

@end


@implementation InterfaceController

@synthesize eye;
@synthesize mouth;
@synthesize leftEyeLabel;
@synthesize rightEyeLabel;
@synthesize mouthLabel;
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

- (void)initWatchOS
{

    // instance variables
    hz = 10;
    period = 1.0/hz;

    // properties
    eye = [NSArray arrayWithObjects: @",", @".", @"*", @"+", @"-", @"—", @":", @";", @"•", @"°", @"‘", @"’", nil];
    mouth = [NSArray arrayWithObjects: @"o", @"+", @"-", @"+", @"–", @"/", @"∘", @"=", @"~", @".", @"-", @"×", @"*", nil];
    
    [self initTimer];
}

- (void) initTimer
{
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

- (void) killTimer
{
    [multiTimer invalidate];
    multiTimer = nil;
    paused = true;
}

- (void) multiTimerCallBack
{
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

- (void) crownDidRotate:(WKCrownSequencer *)crownSequencer rotationalDelta:(double)rotationalDelta {

    // surely an easier way to do this with % 

    if (rotationalDelta > 0) _num++;
    if (rotationalDelta < 0) _num--;
    if (_num == 45) _num = 1;
    if (_num == 0) _num = 44;

    // ** not working **
    // hz = _num / 4;
    hz = .25;

    // ** for debug **
    NSString *name = [NSString stringWithFormat:@"%d", _num];
    // self.mouthLabel.text = @"T";;
    self.mouthLabel.text = name;
        
    [self killTimer];
    // [self initTimer];

    // NSString *name = [NSString stringWithFormat:@"sushi_%d", _num];
    // [_sushiImage setImageNamed:name];
    // [_messageLabel setText:@"おすしぐるぐる"];
}

@end



