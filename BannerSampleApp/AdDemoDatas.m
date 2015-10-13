//
//  AdDemoDatas.m
//  BannerSampleApp
//
//  Created by JiaYining on 10/2/15.
//  Copyright © 2015 Vungle. All rights reserved.
//

#import "AdDemoDatas.h"

static NSDictionary* sAdDemoDatas = nil;

@implementation AdDemoDatas


+(NSArray*) datas
{
    if (sAdDemoDatas == nil)
    {
        [AdDemoDatas loadDemoData];
    }
        
    return [sAdDemoDatas objectForKey:@"AdDemoDatas"];
}

+(void) loadDemoData
{
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"AdDemoData" ofType:@"json" inDirectory:@""];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile];
    NSError* err = nil;
    sAdDemoDatas = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    assert(sAdDemoDatas);
}

@end
