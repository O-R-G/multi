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

@synthesize eye;
@synthesize mouth;
@synthesize LeftEyeLabel;
@synthesize mouthLabel;


- (void)awakeWithContext:(id)context {
    // Configure interface objects here.
    [self initWatchOS];
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
    LeftEyeLabel.text = eye[i];
    
    /*
    i = arc4random_uniform((int)eye.count);
    self.rightEyeLabel.text = eye[i];
     */
    
    i = arc4random_uniform((int)mouth.count);
    self.mouthLabel.text = mouth[i];

}



@end



