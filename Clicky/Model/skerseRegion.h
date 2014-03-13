//
//  skerseRegion.h
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface skerseRegion : NSObject

@property uint32_t regionID;
@property NSMutableArray *pixels;
@property uint32_t xOrigin;
@property uint32_t yOrigin;
@property uint32_t xSize;
@property uint32_t ySize;

-(skerseRegion*)initWithID:(uint32_t)rID;
-(void)loadPixels:(NSArray*)pixels;
-(void)addDefense:(NSArray*)defense;


@end
