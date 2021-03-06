//
//  skersePlayer.h
//  Clicky
//
//  Created by Alexander Glenn on 2/23/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface skersePlayer : NSObject

@property UIColor *playerColor;
@property (nonatomic) uint8_t red;
@property (nonatomic) uint8_t green;
@property (nonatomic) uint8_t blue;

+(skersePlayer*)currentPlayer;

-(skersePlayer*)initWithRed:(uint8_t)r green:(uint8_t)g blue:(uint8_t)b;

-(NSString*)playerID;

@end
