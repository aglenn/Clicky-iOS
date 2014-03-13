//
//  skerseRegionManager.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseRegionManager.h"
#import "skerseGameInfo.h"
#import "skerseServerStreamCommunicator.h"

static skerseRegionManager *sharedManager =  nil;

@interface skerseRegionManager()
@property NSMutableArray *regionRequests;
@end

@implementation skerseRegionManager

-(skerseRegionManager*)init {
    self = [super init];
    if (self) {
        _regions = [[NSMutableArray alloc] init];
        _regionRequests = [[NSMutableArray alloc] init];
    }
    return self;
}

+(skerseRegionManager*)sharedManager {
    @synchronized(self) {
        if (!sharedManager) {
            sharedManager = [[skerseRegionManager alloc] init];
        }
        return sharedManager;
    }
}

-(void)beginRegionFetch {
    uint32_t gameWidth = [skerseGameInfo currentGame].width;
    uint32_t gameHeight = [skerseGameInfo currentGame].height;
    
    /*
    for (uint32_t i=0; i<gameWidth; i+=10) {
        for (uint32_t j=0; j<gameHeight; j+=10) {
            uint8_t width = 10;
            uint8_t height = 10;
            
            if (i + width > gameWidth) {
                width = gameWidth - i;
            }
            
            if (j + height > gameHeight) {
                height = gameHeight - j;
            }
            NSValue *v = [NSValue valueWithCGRect:CGRectMake(i, j, width, height)];
            [_regionRequests addObject:v];
        }
    }
     */
    
    NSValue *v = [NSValue valueWithCGRect:CGRectMake(0, 0, gameWidth, gameHeight)];
    [_regionRequests addObject:v];
    
    [self fetchNextRegion];
}

-(void)fetchNextRegion {
    NSValue *v = [_regionRequests firstObject];
    if (v) {
        [_regionRequests removeObjectAtIndex:0];
        skerseServerStreamCommunicator *sssC = [skerseServerStreamCommunicator sharedCommunicator];
        [sssC fetchRegion:v.CGRectValue];
    }
    else {
        NSLog(@"No more regions to fetch");
    }
    
}

-(void)addRegion:(skerseRegion *)region {
    [self.regions addObject:region];
    [self fetchNextRegion];
}

@end
