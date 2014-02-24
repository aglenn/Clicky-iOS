//
//  Region.m
//  RegionTest
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "Region.h"
#import "Pixel.h"

@implementation Region

-(Region*)init {
    self = [super init];
    if (self) {
        _pixels = [[NSMutableArray alloc] init];
    }
    return self;
}

-(Region*)initWithID:(uint32_t)rID {
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
            NSDictionary *pixel = pixels[i*self.xSize + j];
            Pixel *p = [[Pixel alloc] init];
            [p setDefense:0];

            [p setRed:[pixels[pIndex] unsignedIntValue]];
            [p setGreen:[pixels[pIndex + 1] unsignedIntValue]];
            [p setBlue:[pixels[pIndex + 2] unsignedIntValue]];
            
            [row addObject:p];
            
            pIndex += 3;
        }
        [_pixels addObject:row];
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
