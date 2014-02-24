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

-(skersePlayer*)init {
    self = [super init];
    if (self) {
        [self setRed:200];
        [self setGreen:184];
        [self setBlue:2];
    }
    return self;
}

+(skersePlayer*)currentPlayer {
    @synchronized(self) {
        if (!currentPlayer) {
            currentPlayer = [[skersePlayer alloc] init];
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
