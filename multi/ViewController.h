//
//  ViewController.h
//  multi
//
//  Created by Lily Healey on 11.08.2015.
//  Copyright (c) 2015 O-R-G, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController : UIViewController
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


- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)panAction:(UIPanGestureRecognizer *)sender;
- (IBAction)doubleTapAction:(UITapGestureRecognizer *)sender;
- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender;


@end
