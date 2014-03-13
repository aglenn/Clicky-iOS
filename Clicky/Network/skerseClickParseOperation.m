//
//  skerseClickParseOperation.m
//  Clicky
//
//  Created by Alexander Glenn on 2/24/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseClickParseOperation.h"
#import "skersePixel.h"

@interface skerseClickParseOperation()
@property NSDictionary *dictionary;
@end

@implementation skerseClickParseOperation

-(skerseClickParseOperation*)initWithDictionary:(NSDictionary*)d {
    self = [super init];
    if (self) {
        _dictionary = d;
    }
    return self;
}

-(void)main {
    NSLog(@"Click update: %@", _dictionary);
    for (NSDictionary *click in [_dictionary objectForKey:@"clicks"]) {
        
        skersePixel *p = [[skersePixel alloc] init];
        
        [p setDefense:[[click objectForKey:@"defense"] unsignedIntValue]];
        
        NSLog(@"Got pixel with defense: %u", p.defense);
        
        NSArray *rgb = [click objectForKey:@"rgb"];
        [p setRed:[rgb[0] unsignedIntValue]];
        [p setGreen:[rgb[1] unsignedIntValue]];
        [p setBlue:[rgb[2] unsignedIntValue]];
        
        
        NSArray *pixel = [click objectForKey:@"pixel"];
        uint32_t rID = [[click objectForKey:@"id"] unsignedIntValue];
        
        dispatch_async(dispatch_get_main_queue(),  ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Click" object:self userInfo:@{@"rID":@(rID), @"x":@([pixel[0] unsignedIntValue]),@"y":@([pixel[1] unsignedIntValue]),@"pixel":p}];
        });
    }
    
    
    
}

@end
