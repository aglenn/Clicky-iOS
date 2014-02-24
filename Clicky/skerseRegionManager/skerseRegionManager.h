//
//  skerseRegionManager.h
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Region;

@interface skerseRegionManager : NSObject

@property NSMutableArray *regions;

+(skerseRegionManager*)sharedManager;
-(Region*)regionForID:(uint32_t)regionID;

@end
