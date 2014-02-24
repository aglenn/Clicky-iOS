//
//  RegionParseOperation.m
//  RegionTest
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "RegionParseOperation.h"
#import "Region.h"
#import "skerseRegionManager.h"

@interface RegionParseOperation()
@property NSDictionary *dictionary;
@end

@implementation RegionParseOperation

-(RegionParseOperation*)initWithDictionary:(NSDictionary*)d {
    self = [super init];
    if (self) {
        _dictionary = d;
    }
    return self;
}

-(void)main {
    
    uint32_t rID = [[_dictionary objectForKey:@"id"] unsignedIntValue];
    NSLog(@"Got id: %u", rID);
    Region *r = [[Region alloc] initWithID:rID];
    
    // pull origin and size
    NSDictionary *regionDict = [_dictionary objectForKey:@"region"];
    [r setXOrigin:[((NSArray*)[regionDict objectForKey:@"top_left"])[0] unsignedIntValue]];
    [r setYOrigin:[((NSArray*)[regionDict objectForKey:@"top_left"])[1] unsignedIntValue]];
    [r setXSize:([((NSArray*)[regionDict objectForKey:@"bottom_right"])[0] unsignedIntValue] - r.xOrigin) + 1];
    [r setYSize:([((NSArray*)[regionDict objectForKey:@"bottom_right"])[1] unsignedIntValue] - r.yOrigin) + 1];
    
    NSArray *pixels = [_dictionary objectForKey:@"pixels"];
    NSLog(@"Pixels length: %d", pixels.count);
    [r loadPixels:pixels];
    
    [[skerseRegionManager sharedManager].regions addObject:r];
    
    dispatch_sync(dispatch_get_main_queue(),  ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRegion" object:self userInfo:@{@"Region":r}];
    });
}

@end
