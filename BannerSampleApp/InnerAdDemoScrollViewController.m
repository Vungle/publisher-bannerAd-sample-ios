//
//  InnerAdDemoScrollView.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/7/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "InnerAdDemoScrollViewController.h"
#import "AdDemoDatas.h"
#import <VungleSDK/VungleSDK.h>
#import "FloatingWindowManager.h"

@interface InnerAdDemoScrollViewController()<VungleSDKDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adViewHeight;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) BOOL alreadyPlayed;

@end

@implementation InnerAdDemoScrollViewController

-(void) viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.adViewHeight.constant = 0;
    self.scrollView.delegate = self;
    [super viewDidLoad];
    
    [self setupSubViews];
    [self setupVungleAd];
}

-(void) setupVungleAd
{
    [VungleSDK sharedSDK].bannerView = self.adView;
    [VungleSDK sharedSDK].muted = YES;
    [[VungleSDK sharedSDK] setDelegate:self];
    [[VungleSDK sharedSDK] setScreenTopOffset:self.navigationController.navigationBar.bounds.size.height];
    [VungleSDK sharedSDK].floatingView = [FloatingWindowManager FloatingWindow:self.view];
    [self playAd];

}


-(void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.isMovingFromParentViewController)
    {
        [VungleSDK sharedSDK].bannerView = nil;
        [[VungleSDK sharedSDK] setDelegate: nil];
        [[VungleSDK sharedSDK] exitPlayAd];
    }
    [super viewDidDisappear:animated];
}


-(void) playAd
{
    if ([[VungleSDK sharedSDK] isAdPlayable] && !_alreadyPlayed)
    {
        _alreadyPlayed = YES;
        NSError* error;
        [[VungleSDK sharedSDK] playAd:self error:&error];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[VungleSDK sharedSDK] scrollViewDidScroll:scrollView];
}

-(void) setupSubViews
{
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    UIView* previousView = self.adView;
    float viewHeight = 0;
    for (NSDictionary* data in [AdDemoDatas datas])
    {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: [data objectForKey:@"imagePath"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:imageView];
        
        
        
        
        NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f];
        [constraints addObject:widthConstraint];
        
        NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:300.f];
        //[imageView.heightAnchor constraintEqualToConstant:300];
        [constraints addObject:heightConstraint];

        
        NSLayoutConstraint* topConstraint = [NSLayoutConstraint
                                                    constraintWithItem:imageView
                                                    attribute:NSLayoutAttributeTop
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:previousView
                                                    attribute: NSLayoutAttributeBottom
                                                    multiplier:1
                                                    constant:20.f];
        [constraints addObject:topConstraint];
        
        previousView = imageView;
        viewHeight += 320;
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
        self.contentViewHeight.constant = viewHeight;
}


#pragma mark VungleSDK delegates

- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary *)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet
{
    self.adViewHeight.constant = 0;
}

-(void) vungleSDKwillShowAd
{
    self.adViewHeight.constant = 300;
}

- (void)vungleSDKAdPlayableChanged:(BOOL)isAdPlayable
{
    if (isAdPlayable)
    {
        [self playAd];
    }
}

@end
