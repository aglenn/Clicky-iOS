//
//  RegionParseOperation.m
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseRegionParseOperation.h"
#import "skerseRegion.h"
#import "skerseRegionManager.h"

@interface skerseRegionParseOperation()
@property NSDictionary *dictionary;
@end

@implementation skerseRegionParseOperation

-(skerseRegionParseOperation*)initWithDictionary:(NSDictionary*)d {
    self = [super init];
    if (self) {
        _dictionary = d;
    }
    return self;
}

-(void)main {
    
    uint32_t rID = [[_dictionary objectForKey:@"id"] unsignedIntValue];
    //NSLog(@"Got id: %u", rID);
    skerseRegion *r = [[skerseRegion alloc] initWithID:rID];
    
    // pull origin and size
    NSDictionary *regionDict = [_dictionary objectForKey:@"region"];
    [r setXOrigin:[((NSArray*)[regionDict objectForKey:@"top_left"])[0] unsignedIntValue]];
    [r setYOrigin:[((NSArray*)[regionDict objectForKey:@"top_left"])[1] unsignedIntValue]];
    [r setXSize:([((NSArray*)[regionDict objectForKey:@"bottom_right"])[0] unsignedIntValue] - r.xOrigin) + 1];
    [r setYSize:([((NSArray*)[regionDict objectForKey:@"bottom_right"])[1] unsignedIntValue] - r.yOrigin) + 1];
    
    NSArray *pixels = [_dictionary objectForKey:@"pixels"];
    [r loadPixels:pixels];
    NSArray *defenses = [_dictionary objectForKey:@"defense"];
    [r addDefense:defenses];
    
    [[skerseRegionManager sharedManager] addRegion:r];
    
    dispatch_async(dispatch_get_main_queue(),  ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewRegion" object:self userInfo:@{@"RegionID":@(rID)}];
    });
    _dictionary = nil;
    regionDict = nil;
}

@end
