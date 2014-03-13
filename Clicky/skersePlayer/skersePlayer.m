//
//  skersePlayer.m
//  Clicky
//
//  Created by Alexander Glenn on 2/23/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skersePlayer.h"

static skersePlayer *currentPlayer = nil;

@implementation skersePlayer

-(skersePlayer*)initWithRed:(uint8_t)r green:(uint8_t)g blue:(uint8_t)b {
    self = [super init];
    if (self) {
        [self setRed:r];
        [self setGreen:g];
        [self setBlue:b];
    }
    return self;
}

+(skersePlayer*)currentPlayer {
    @synchronized(self) {
        if (!currentPlayer) {
            #if TARGET_IPHONE_SIMULATOR
            currentPlayer = [[skersePlayer alloc] initWithRed:2 green:184 blue:200];
            #else
            currentPlayer = [[skersePlayer alloc] initWithRed:200 green:184 blue:2];
            currentPlayer = [[skersePlayer alloc] initWithRed:255 green:0 blue:0];
            #endif
        }
        return currentPlayer;
    }
}

-(void)setRed:(uint8_t)red {
    _red = red;
    [self setPlayerColor:[UIColor colorWithRed:(float)self.red/(float)255 green:(float)self.green/(float)255 blue:(float)self.blue/(float)255 alpha:1.0]];
}


-(void)setGreen:(uint8_t)green {
    _green = green;
    [self setPlayerColor:[UIColor colorWithRed:(float)self.red/(float)255 green:(float)self.green/(float)255 blue:(float)self.blue/(float)255 alpha:1.0]];
}


-(void)setBlue:(uint8_t)blue {
    _blue = blue;
    [self setPlayerColor:[UIColor colorWithRed:(float)self.red/(float)255 green:(float)self.green/(float)255 blue:(float)self.blue/(float)255 alpha:1.0]];
}

@end
