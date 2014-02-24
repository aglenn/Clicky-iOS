//
//  skerseSKPixel.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseSKPixel.h"
#import "Pixel.h"
#import "Constants.h"

@implementation skerseSKPixel

-(skerseSKPixel*)initWithPixel:(Pixel*)pixel position:(CGPoint) position {
    self = [super initWithColor:pixel.color size:CGSizeMake(PSIZE, PSIZE)];
    if (self) {
        _pixel = pixel;
        self.position = CGPointMake(position.x * PSIZE + PSIZE/2, position.y * PSIZE + PSIZE/2);
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];
    
    if (CGRectContainsPoint(self.frame, touchPoint)) {
        NSLog(@"TOuched");
    }
}

@end
