//
//  GlobalFloatingWindowManager.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/2/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "FloatingWindowManager.h"

static UIView* sFloatingWindow = nil;
@implementation FloatingWindowManager

+(UIView*) GlobalFloatingWindow
{
    if (sFloatingWindow == nil)
    {
        sFloatingWindow = [FloatingWindowManager FloatingWindow:[UIApplication sharedApplication].delegate.window];
    }
    
    return sFloatingWindow;
}

+(UIView*) FloatingWindow:(UIView*) parentView
{
    CGRect rtBounds = parentView.bounds;
    UIView* floatingView = [[UIView alloc] initWithFrame:CGRectMake(rtBounds.size.width-200, rtBounds.size.height-200, 200, 200)] ;
    
    floatingView.layer.zPosition = NSIntegerMax;
    floatingView.hidden = YES;
    floatingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [parentView addSubview:floatingView];
    
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[floatingView(200)]-3-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(floatingView)]];
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[floatingView(200)]-3-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(floatingView)]];
    
    return floatingView;
}

@end
