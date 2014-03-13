//
//  skerseGameInfoParseOperation.m
//  Clicky
//
//  Created by Alexander Glenn on 2/24/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseGameInfoParseOperation.h"
#import "skerseGameInfo.h"
@interface skerseGameInfoParseOperation()
@property NSDictionary *dictionary;
@end

@implementation skerseGameInfoParseOperation

-(skerseGameInfoParseOperation*)initWithDictionary:(NSDictionary*)d {
    self = [super init];
    if (self) {
        _dictionary = d;
    }
    return self;
}


/*
 {'id': 1, 'message_name': 'game_info'}
 and get back: {'message_name': 'game_info', 'height': 100, 'power': 10, 'id': 1, 'width': 100}
 
 */

-(void)main {
    
    uint32_t gameID = [[_dictionary objectForKey:@"id"] unsignedIntValue];
    uint32_t height = [[_dictionary objectForKey:@"height"] unsignedIntValue];
    uint32_t width = [[_dictionary objectForKey:@"width"] unsignedIntValue];
    uint8_t power = [[_dictionary objectForKey:@"power"] unsignedIntValue];
    
    [[skerseGameInfo currentGame] setGameID:gameID];
    [[skerseGameInfo currentGame] setPower:power];
    [[skerseGameInfo currentGame] setWidth:width];
    [[skerseGameInfo currentGame] setHeight:height];
    
    dispatch_async(dispatch_get_main_queue(),  ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameInfo" object:self userInfo:nil];
    });
    
    
}
@end
