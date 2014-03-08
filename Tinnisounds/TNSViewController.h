//
//  TNSViewController.h
//  Tinnisounds
//
//  Created by Rafael Amorim on 06/03/14.
//  Copyright (c) 2014 Rafael Amorim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>

@interface TNSViewController : UIViewController <ADBannerViewDelegate>
- (IBAction)didTapSound:(UIButton *)sender;
- (IBAction)didTapTitle:(UIButton *)sender;
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe;
- (NSDictionary *)getSounds;
- (NSArray *)getBackgroundColors;
- (void)setBackground:(int)backgroundIndex;
- (void)playSound:(int)soundIndex;
@end
