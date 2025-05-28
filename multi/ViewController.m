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
@synthesize soundFileObject;
@synthesize singleTapRecognizer;
@synthesize doubleTapRecognizer;
@synthesize longPressRecognizer;
@synthesize longLongPressRecognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initIosWatch];
    // Set up and start background music
    [self setupBackgroundMusic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)initIosWatch
{
    
    // instance variables
    hz = 10;
    period = 1.0/hz;

    // properties
    eye = [NSArray arrayWithObjects: @",", @".", @"*", @"+", @"-", @"—", @":", @";", @"•", @"°", @"‘", @"’", nil];
    // mouth = [NSArray arrayWithObjects: @"o", @"+", @"-", @"+", @"–", @"/", @"x", @"=", @"~", @"_", @"-", @"_", @"*", nil];
    mouth = [NSArray arrayWithObjects: @"o", @"+", @"-", @"+", @"–", @"/", @"∘", @"=", @"~", @".", @"-", @"×", @"*", nil];

    hzLabel.text = [NSString stringWithFormat: @"%1.2f Hz", hz];

    // set font size based on screen size
    CGFloat fontSize = 20;
    // iphone 4,4s
    if(self.view.bounds.size.height <= 480)
        fontSize = 100;
    // iphone 5,5s,5c,SE
    else if(self.view.bounds.size.height <= 568)
        fontSize = 110;
    // iphone 6,7,8
    else if(self.view.bounds.size.height <= 667)
        fontSize = 120;
    // iphone 6,7,8+
    else if(self.view.bounds.size.height <= 736)
        fontSize = 130;
    // iphone x
    else if(self.view.bounds.size.height <= 812)
        fontSize = 120;
    // ipad
    else
        fontSize = 200;

    multiFont = [UIFont fontWithName:@"Menlo-Bold" size:fontSize];

    // set fonts
    leftEyeLabel.font = multiFont;
    rightEyeLabel.font = multiFont;
    mouthLabel.font = multiFont;

    // Get the main bundle for the app
    CFBundleRef mainBundle = CFBundleGetMainBundle ();
    // Get the URL to the sound file to play.
    // The file in this case is "BD.wav"
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR ("BD"), CFSTR ("wav"), NULL);
    // Create a system sound object representing the sound file
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);

    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [singleTapRecognizer requireGestureRecognizerToFail:longPressRecognizer];
    self.longPressRecognizer.delegate = self;
    self.longLongPressRecognizer.delegate = self;

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
    AudioServicesPlaySystemSound (self.soundFileObject);
    // AudioServicesPlaySystemSound (1305);
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
    NSData* imageData = screenToPNG();
    UIImage* pngImage = [UIImage imageWithData:imageData];
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(pngImage, nil, nil, nil);
    
    // flash the screen
    UIView *flashView = [[UIView alloc] initWithFrame:window.bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.alpha = 1.0f;
    [window addSubview:flashView];
    
    [UIView
        animateWithDuration:0.75f animations:^{
            flashView.alpha = 0.0f;
        }
        completion:^(BOOL finished) {
            [flashView removeFromSuperview];
        }
     ];
    
    // play camera sound
    AudioServicesPlaySystemSound(1108);
}

// send messages
- (void) sendMessage
{
    MFMessageComposeViewController* composer = [[MFMessageComposeViewController alloc] init];
    composer.messageComposeDelegate = self;
    
    if([MFMessageComposeViewController canSendText])
    {
        // These checks basically make sure it's an MMS capable device with iOS7
        if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments])
        {
            NSData* attachment = screenToPNG();
            NSString* uti = (NSString*)kUTTypeMessage;
            [composer addAttachmentData:attachment typeIdentifier:uti filename:@"multi.png"];
        }
        [self presentViewController:composer animated:YES completion:nil];
    }
}

NSData* screenToPNG()
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // take a screenshot
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData* png =  UIImagePNGRepresentation(image);
    
    return png;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
        }
            break;
        case MessageComposeResultFailed:
        {
        }
            break;
        case MessageComposeResultSent:
        {
        }
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ------------------------------------------------------
// GESTURE RECOGNIZER STUFF
// ------------------------------------------------------

// make sure that the longLongPress is recognized after the longPress
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)longPressRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)longLongPressRecognizer {
    return YES;
}

// ------------------------------------------------------
// ACTIONS
// ------------------------------------------------------

// action: single tap
// result: pause
- (IBAction)singleTapAction:(UITapGestureRecognizer *)sender
{
    if(paused)
        [self initTimer];
    else
        [self killTimer];
}

// action: double tap
// result: show / hide hz label
- (IBAction)doubleTapAction:(UITapGestureRecognizer *)sender
{
    self.hzLabel.hidden = !self.hzLabel.hidden;
}

// action: tap with two fingers
// result: send screen as message
- (IBAction)twoFingerTapAction:(UITapGestureRecognizer *)sender
{
    // pause
    if(!paused)
        [self killTimer];
    
    [self sendMessage];
}

// action: tap for 0.5 seconds
// resutl: take screenshots
- (IBAction)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        // pause
        if(!paused)
            [self killTimer];
        [self takeScreenshot];
    }
}

// action: slide one finger up + down screen
// result: change Hz
- (IBAction)panAction:(UIPanGestureRecognizer *)sender
{
    if(!self.hzLabel.hidden)
    {
        lineView.hidden = NO;
        
        float incrementSize = 1000.f;
        CGPoint translation = [sender translationInView:self.view];
        hz -= (translation.y / incrementSize);
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
            lineView.hidden = YES;
    }
}

// action: press for 1.5 seconds
// result: send screen as message
- (IBAction)longlongPressAction:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        // pause
        if(!paused)
            [self killTimer];

        [self sendMessage];
    }
}

// Add this new method to setup background music
- (void)setupBackgroundMusic {
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *audioURL = [bundle URLForResource:@"jingle" withExtension:@"mp3"];
    if (audioURL) {
        NSError *error = nil;
        
        // Initialize audio session for background playback
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            NSLog(@"Error setting audio session category: %@", error.localizedDescription);
        }
        
        // Create audio player
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
        if (error) {
            NSLog(@"Error creating audio player: %@", error.localizedDescription);
            return;
        }
        
        self.backgroundMusic.delegate = (id)self;
        self.backgroundMusic.numberOfLoops = -1; // Infinite looping
        [self.backgroundMusic prepareToPlay];
        [self.backgroundMusic play];
    } else {
        NSLog(@"Background music file not found");
    }
}

- (void)handleDidBecomeActive {
    if (self.backgroundMusic && !self.backgroundMusic.isPlaying) {
        [self.backgroundMusic play];
    }
}

- (void)handleWillResignActive {
    if (self.backgroundMusic && self.backgroundMusic.isPlaying) {
        [self.backgroundMusic pause];
    }
}


@end
