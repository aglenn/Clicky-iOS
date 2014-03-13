//
//  skerseRegion.m
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseRegion.h"
#import "skersePixel.h"

@implementation skerseRegion

-(skerseRegion*)init {
    self = [super init];
    if (self) {
        _pixels = [[NSMutableArray alloc] init];
    }
    return self;
}

-(skerseRegion*)initWithID:(uint32_t)rID {
    self = [super init];
    if (self) {
        _regionID = rID;
        _pixels = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadPixels:(NSArray*)pixels {
    int pIndex = 0;
    for (int i=0; i<self.ySize; i++) {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<self.xSize; j++) {
            if (pIndex+2 <= pixels.count-1) {
                NSDictionary *pixel = pixels[i*self.xSize + j];
                skersePixel *p = [[skersePixel alloc] init];
                [p setDefense:0];
                
                [p setRed:[pixels[pIndex] unsignedIntValue]];
                [p setGreen:[pixels[pIndex + 1] unsignedIntValue]];
                [p setBlue:[pixels[pIndex + 2] unsignedIntValue]];
                
                [row addObject:p];
                
                pIndex += 3;
            }
        }
        [_pixels addObject:row];
    }
    
}

-(void)addDefense:(NSArray*)defense {
    // Get defense
    for (NSArray *d in defense) {
        uint32_t x = [d[0] unsignedIntValue];
        uint32_t y = [d[1] unsignedIntValue];
        uint16_t def =[d[2] unsignedIntValue];
        
        skersePixel *p = ((NSArray*)self.pixels[y - self.yOrigin])[x - self.xOrigin];
        [p setDefense:def];
    }
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:@(_regionID) forKey:@"regionID"];
    [coder encodeObject:_pixels forKey:@"pixels"];
    [coder encodeObject:@(_xOrigin) forKey:@"xOrigin"];
    [coder encodeObject:@(_yOrigin) forKey:@"yOrigin"];
    [coder encodeObject:@(_xSize) forKey:@"xSize"];
    [coder encodeObject:@(_ySize) forKey:@"ySize"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _regionID = [[coder decodeObjectForKey:@"regionID"] unsignedIntegerValue];
        _pixels = [coder decodeObjectForKey:@"pixels"];
        _xOrigin = [[coder decodeObjectForKey:@"xOrigin"] unsignedIntegerValue];
        _yOrigin = [[coder decodeObjectForKey:@"yOrigin"] unsignedIntegerValue];
        _xSize = [[coder decodeObjectForKey:@"xSize"] unsignedIntegerValue];
        _ySize = [[coder decodeObjectForKey:@"ySize"] unsignedIntegerValue];
    }
    return self;
}

@end
