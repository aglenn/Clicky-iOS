//
//  skerseGameInfo.h
//  Clicky
//
//  Created by Alexander Glenn on 2/24/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface skerseGameInfo : NSObject
@property uint32_t gameID;
@property uint8_t power;
@property uint32_t width;
@property uint32_t height;

+(skerseGameInfo*)currentGame;

@end
