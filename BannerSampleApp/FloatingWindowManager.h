//
//  FloatingWindowManager.h
//  BannerSampleApp
//
//  Created by JiaYining on 10/2/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FloatingWindowManager : NSObject


+(UIView*) FloatingWindow:(UIView*) parentView;

+(UIView*) GlobalFloatingWindow;

@end
