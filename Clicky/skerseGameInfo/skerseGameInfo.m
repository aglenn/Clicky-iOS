//
//  skerseGameInfo.m
//  Clicky
//
//  Created by Alexander Glenn on 2/24/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseGameInfo.h"

@implementation skerseGameInfo

static skerseGameInfo *currentGame = nil;

-(skerseGameInfo*)initWithID:(uint32_t) gameID power:(uint8_t) power width:(uint32_t) width height:(uint32_t) height {
    self = [super init];
    if (self) {
        _power = power;
        _height = height;
        _width = width;
        _gameID = gameID;
    }
    return self;
}

+(skerseGameInfo*)currentGame {
    @synchronized(self) {
        if (!currentGame) {
            currentGame = [[skerseGameInfo alloc] initWithID:0 power:0 width:0 height:0];
        }
        return currentGame;
    }
}


@end
