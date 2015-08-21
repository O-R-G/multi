//
//  ViewController.m
//  multi
//
//  Created by Lily Healey on 11.08.2015.
//  Copyright (c) 2015 O-R-G, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize eye;
@synthesize mouth;
@synthesize lineView;
@synthesize leftEyeLabel;
@synthesize rightEyeLabel;
@synthesize mouthLabel;
@synthesize hzLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // instance variables
    multiFont = [UIFont fontWithName:@"Wattis-Regular" size:48];
    hz = 10;
    period = 1.0/hz;
    
    // properties
    eye = [NSArray arrayWithObjects: @",", @".", @"*", @"+", @"-", @"—", @":", @";", @"•", @"°", @"‘", @"’", nil];
    mouth = [NSArray arrayWithObjects: @"o", @"+", @"-", @"+", @"–", @"/", @"x", @"=", @"~", @"_", @"-", @"_", @"*", nil];
    hzLabel.text = [NSString stringWithFormat: @"%1.2f Hz", hz];
    
    // set fonts
    leftEyeLabel.font = multiFont;
    rightEyeLabel.font = multiFont;
    mouthLabel.font = multiFont;
    CGFloat w = self.view.bounds.size.width;
    CGFloat lineWidth = 50;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(w-lineWidth, 0, lineWidth, 2)];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.hidden = YES;
    [self.view addSubview:lineView];
    
    [self initTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
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
    int i = arc4random_uniform((int)eye.count);
    self.leftEyeLabel.text = eye[i];
    i = arc4random_uniform((int)eye.count);
    self.rightEyeLabel.text = eye[i];
    i = arc4random_uniform((int)mouth.count);
    self.mouthLabel.text = mouth[i];
}

- (void) takeScreenshot
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // take a screenshot
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData* imageData =  UIImagePNGRepresentation(image);
    UIImage* pngImage = [UIImage imageWithData:imageData];
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil);
    
    // flash the screen
    UIView *flashView = [[UIView alloc] initWithFrame:window.bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.alpha = 1.0f;
    [window addSubview:flashView];
    
    [UIView animateWithDuration:0.5f animations:^{
        flashView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender
{
    if(paused)
        [self initTimer];
    else
        [self killTimer];
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender
{
    hzLabel.hidden = NO;
    lineView.hidden = NO;
    
    float incrementSize = 1000.f;
    CGPoint translation = [sender translationInView:self.view];
    CGPoint location = [sender locationInView:self.view];
    CGRect frame = lineView.frame;
    frame.origin = CGPointMake(lineView.frame.origin.x, location.y);
    lineView.frame = frame;
    hz += (translation.y / incrementSize);
    if(hz < 0.1f)
        hz = 0.1f;
    if(hz > 30.f)
        hz = 30.f;
    hzLabel.text = [NSString stringWithFormat:@"%1.2f Hz", hz];
    period = 1.f/hz;
    
    if(paused)
        [self initTimer];
    else
    {
        [self killTimer];
        [self initTimer];
    }
    
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        hzLabel.hidden = YES;
        lineView.hidden = YES;
    }
}

- (IBAction)doubleTapAction:(UITapGestureRecognizer *)sender
{
    [self takeScreenshot];
}

- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
        [self takeScreenshot];
}

@end
