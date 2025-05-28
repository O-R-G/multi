//
//  InterfaceController.h
//  watch WatchKit Extension
//
//  Created by david reinfurt on 11/21/21.
//  Copyright © 2021 O-R-G, Inc. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
// WKCrownDelegate

@interface InterfaceController : WKInterfaceController <WKCrownDelegate> {
        NSTimer *multiTimer;
        // UIFont *multiFont;
        BOOL paused;
        float hz, period;
    }

@property (strong, nonatomic) IBOutlet WKInterfaceGroup *group;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *leftEyeLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *rightEyeLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *mouthLabel;
@property (strong, nonatomic) IBOutlet WKTapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) IBOutlet WKInterfaceSlider *hzSlider;
// Add audio player property
@property (nonatomic, strong) AVAudioPlayer *backgroundMusic;

@property (readonly) NSArray *eye;
@property (readonly) NSArray *mouth;

@property (nonatomic) int hz_slider;

- (IBAction)singleTapAction:(id)sender;


@end
