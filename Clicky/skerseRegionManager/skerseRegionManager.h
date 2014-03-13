//
//  skerseRegionManager.h
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class skerseRegion;

@interface skerseRegionManager : NSObject

@property (readonly) NSMutableArray *regions;

+(skerseRegionManager*)sharedManager;
//-(skerseRegion*)regionForID:(uint32_t)regionID;
-(void)beginRegionFetch;
-(void)addRegion:(skerseRegion*) region;

@end
