//
//  skersePixel.h
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface skersePixel : NSObject

@property (nonatomic) uint8_t red;
@property (nonatomic) uint8_t green;
@property (nonatomic) uint8_t blue;
@property UIColor *color;
@property uint16_t defense;

@end
