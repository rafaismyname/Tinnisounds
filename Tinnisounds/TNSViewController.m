//
//  TNSViewController.m
//  Tinnisounds
//
//  Created by Rafael Amorim on 06/03/14.
//  Copyright (c) 2014 Rafael Amorim. All rights reserved.
//

#import "TNSViewController.h"

@interface TNSViewController ()
@property (strong, nonatomic) IBOutlet UIPageControl *colorPage;
 @property (nonatomic, strong) AVAudioPlayer *audioPlayer; // The audio player itself
 @property (nonatomic) int playingNow; // The current sound index playng
 @property (nonatomic) int currentBackground; // The current backgorund index playng
@end

@implementation TNSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Adding Listeners to swipe
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Adding first-responders to view
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Releasing first-responders to view
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

// Events handling for iPhone's audio control
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl && self.playingNow >= 3000) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self.audioPlayer play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self.audioPlayer pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            if(self.audioPlayer.playing)
                [self.audioPlayer pause];
            else
                [self.audioPlayer play];
        }
    }
}


// Change the background when swiping, loop through colors array
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        int futureIndex = self.currentBackground - 1;
        if(futureIndex < 0){
            futureIndex = [[self getBackgroundColors] count] - 1;
        }
        [self setBackground:futureIndex];
        NSLog(@"Left Swipe");
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        int futureIndex = self.currentBackground + 1;
        if(futureIndex > ([[self getBackgroundColors] count] - 1)){
            futureIndex = 0;
        }
        [self setBackground:futureIndex];
        NSLog(@"Right Swipe");
    }
    
}

// Set The background with a smooth animation
- (void)setBackground:(int)backgroundIndex{
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setBackgroundColor:[self.getBackgroundColors objectAtIndex: backgroundIndex]];
    }];
    self.currentBackground = backgroundIndex;
    self.colorPage.currentPage = backgroundIndex;
    NSLog(@"Background color is now set to %i", backgroundIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Init a sound by the UIButton tag, we use this tag as an index of a dictionary of sounds
- (IBAction)didTapSound:(UIButton *)sender {
    [self playSound:sender.tag];
}

// Display an about message when tap the app title
- (IBAction)didTapTitle:(UIButton *)sender {
    NSString *aboutMessage = @"Sounds: freesound.org\nIcons: flaticon.com\nApp Dev: rafaismy.name";
    UIAlertView *about = [[UIAlertView alloc] initWithTitle:@"About"
                                                    message:aboutMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"Roger That! :)"
                                          otherButtonTitles:nil];
    [about show];
    NSLog(@"About message show");
}


// The sounds dictionary
- (NSDictionary *)getSounds{
    return @{@3000: @"Thunderstorm_with_heavy_Rain", @3001: @"cafe_brazil_walla", @3002: @"whiteNoise", @3003: @"henne_beach", @3004: @"fireplace", @3005: @"antony_creek"};
}

// The background colors dictionary
- (NSArray *)getBackgroundColors{
    UIColor *green = [UIColor colorWithRed:0/255.0f green:212/255.0f blue:150/255.0f alpha:1.0f];
    UIColor *blue = [UIColor colorWithRed:0/255.0f green:196/255.0f blue:214/255.0f alpha:1.0f];
    UIColor *darkBlue = [UIColor colorWithRed:0/255.0f green:137/255.0f blue:133/255.0f alpha:1.0f];
    UIColor * yellow = [UIColor colorWithRed:243/255.0f green:194/255.0f blue:66/255.0f alpha:1.0f];
    UIColor *orange = [UIColor colorWithRed:222/255.0f green:109/255.0f blue:39/255.0f alpha:1.0f];
    UIColor *white = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    return @[green, blue, darkBlue, yellow, orange, white];
}

// The sound controls of the app
- (void)playSound:(int)soundIndex{
    NSString *sound = [self.getSounds objectForKey:[NSNumber numberWithInt:soundIndex]];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [self.audioPlayer setNumberOfLoops:-1];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    [self.audioPlayer prepareToPlay];
    
    if (self.playingNow >= 3000)
    {
        self.audioPlayer.currentTime = 0;
        [self toggleSoundButton:self.playingNow];
        if(soundIndex == self.playingNow){
            [self.audioPlayer stop];
            self.playingNow = -1;
            NSLog(@"Stopped sound index %i", soundIndex);
        }else{
            [self.audioPlayer play];
            [self toggleSoundButton:soundIndex];
            self.playingNow = soundIndex;
            NSLog(@"Playng sound index %i", soundIndex);
        }
        
    }
    else
    {
        [self.audioPlayer play];
        [self toggleSoundButton:soundIndex];
        self.playingNow = soundIndex;
        NSLog(@"Playng sound index %i", soundIndex);
    }
}


// Toggle sound buttons states (on/off)
- (void)toggleSoundButton:(int)btnTag{
    UIButton *soundButton = (UIButton *)[self.view viewWithTag:btnTag];
    if (soundButton.isSelected)
        [soundButton setSelected:NO];
    else
        [soundButton setSelected:YES];
}

#pragma mark iAd Delegate Methods
// Method is called when the iAd is loaded.
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 1.
    // We do this because we are going to have it set to 0 to start and setting it to 1 will cause the iAd to fade into view.
    [banner setAlpha:1];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}

// Method is called when the iAd fails to load.
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    // Creates animation.
    [UIView beginAnimations:nil context:nil];
    
    // Sets the duration of the animation to 1.
    [UIView setAnimationDuration:1];
    
    // Sets the alpha to 0.
    // We do this because we are going to have it set to 1 to start and setting it to 0 will cause the iAd to fade out of view.
    [banner setAlpha:0];
    
    //  Performs animation.
    [UIView commitAnimations];
    
}
@end
