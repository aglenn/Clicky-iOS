//
//  skerseRegionManager.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseRegionManager.h"

static skerseRegionManager *sharedManager =  nil;

@implementation skerseRegionManager

-(skerseRegionManager*)init {
    self = [super init];
    if (self) {
        _regions = [[NSMutableArray alloc] init];
    }
    return self;
}

+(skerseRegionManager*)sharedManager {
    if (!sharedManager) {
        sharedManager = [[skerseRegionManager alloc] init];
    }
    return sharedManager;
}

@end
