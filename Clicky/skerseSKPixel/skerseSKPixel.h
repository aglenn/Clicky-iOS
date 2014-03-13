//
//  skerseSKPixel.h
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class skersePixel;
@class skersePlayer;

@interface skerseSKPixel : SKSpriteNode
@property skersePixel *pixel;

-(skerseSKPixel*)initWithPixel:(skersePixel*)pixel position:(CGPoint) position;
-(void)hideLabel;
-(void)showLabel;

-(void)wasClickedByPlayer:(skersePlayer*)player;

@end
