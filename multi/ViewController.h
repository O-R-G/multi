//
//  ViewController.h
//  multi
//
//  Created by Lily Healey on 11.08.2015.
//  Copyright (c) 2015 O-R-G, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController : UIViewController <MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate>
{
    NSTimer *multiTimer;
    UIFont *multiFont;
    BOOL paused;
    float hz, period;
}

@property (readonly) NSArray *eye;
@property (readonly) NSArray *mouth;
@property (readonly) UIView *lineView;
@property (readonly) SystemSoundID soundFileObject;

@property (strong, nonatomic) IBOutlet UILabel *leftEyeLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightEyeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mouthLabel;
@property (strong, nonatomic) IBOutlet UILabel *hzLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapRecognizer;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressRecognizer;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longLongPressRecognizer;
@property (nonatomic, assign) SystemSoundID customSoundID;

- (IBAction)singleTapAction:(UITapGestureRecognizer *)sender;
- (IBAction)doubleTapAction:(UITapGestureRecognizer *)sender;
- (IBAction)twoFingerTapAction:(UITapGestureRecognizer *)sender;
- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender;
- (IBAction)panAction:(UIPanGestureRecognizer *)sender;
- (IBAction)longlongPressAction:(UILongPressGestureRecognizer *)sender;

@end

