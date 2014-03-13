//
//  Pixel.m
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skersePixel.h"

@implementation skersePixel

-(void)setRed:(uint8_t)red {
    _red = red;
    [self setColor:[UIColor colorWithRed:(float)self.red/(float)255 green:(float)self.green/(float)255 blue:(float)self.blue/(float)255 alpha:1.0]];
}


-(void)setGreen:(uint8_t)green {
    _green = green;
    [self setColor:[UIColor colorWithRed:(float)self.red/(float)255 green:(float)self.green/(float)255 blue:(float)self.blue/(float)255 alpha:1.0]];
}


-(void)setBlue:(uint8_t)blue {
    _blue = blue;
    [self setColor:[UIColor colorWithRed:(float)self.red/(float)255 green:(float)self.green/(float)255 blue:(float)self.blue/(float)255 alpha:1.0]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:@(_red) forKey:@"red"];
    [coder encodeObject:@(_green) forKey:@"green"];
    [coder encodeObject:@(_blue) forKey:@"blue"];
    [coder encodeObject:_color forKey:@"color"];
    [coder encodeObject:@(_defense) forKey:@"defense"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _red = [[coder decodeObjectForKey:@"red"] unsignedIntegerValue];
        _green = [[coder decodeObjectForKey:@"green"] unsignedIntegerValue];
        _blue = [[coder decodeObjectForKey:@"blue"] unsignedIntegerValue];
        _color = [coder decodeObjectForKey:@"color"];
        _defense = [[coder decodeObjectForKey:@"defense"] unsignedIntegerValue];
    }
    return self;
}

@end
