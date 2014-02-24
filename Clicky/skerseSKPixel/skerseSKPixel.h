//
//  skerseSKPixel.h
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Pixel;

@interface skerseSKPixel : SKSpriteNode
@property Pixel *pixel;

-(skerseSKPixel*)initWithPixel:(Pixel*)pixel position:(CGPoint) position;
-(void)hideLabel;
-(void)showLabel;

@end
