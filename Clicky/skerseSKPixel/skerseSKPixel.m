//
//  skerseSKPixel.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseSKPixel.h"
#import "skersePixel.h"
#import "Constants.h"
#import "skersePlayer.h"
#import "skerseServerStreamCommunicator.h"
#import "skerseGameInfo.h"

@interface skerseSKPixel()
@property CGPoint coordinate;
@end


@implementation skerseSKPixel

@synthesize pixel = _pixel;

-(skerseSKPixel*)initWithPixel:(skersePixel*)pixel position:(CGPoint) position {
    self = [super initWithColor:pixel.color size:CGSizeMake(PSIZE, PSIZE)];
    if (self) {
        _pixel = pixel;
        _coordinate = position;
        self.position = CGPointMake(position.x * PSIZE + PSIZE/2, position.y * PSIZE + PSIZE/2);
        [self setUserInteractionEnabled:YES];

        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        
        if (self.pixel.red + self.pixel.green + self.pixel.blue > 382) {
            label.fontColor = [UIColor blackColor];
        }
        else {
            label.fontColor = [UIColor whiteColor];
        }
        
        label.fontSize = 25;
        label.text = [NSString stringWithFormat:@"%u", self.pixel.defense];
        
        [self addChild:label];
        
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self.parent];

    if (CGRectContainsPoint([self calculateAccumulatedFrame], touchPoint)) {        
        for (int i = 0; i < [skerseGameInfo currentGame].power; i++) {
            [self wasClickedByPlayer:[skersePlayer currentPlayer]];
        }
        [[skerseServerStreamCommunicator sharedCommunicator] sendClick:_coordinate];
    }
}

-(void)wasClickedByPlayer:(skersePlayer*)player {
    if ([self.pixel.color isEqual:player.playerColor]) { // upping our own defense
        //NSLog(@"upping defense");
        [self.pixel setDefense:self.pixel.defense + 1];
        [self updateLabel];
    }
    else { // fighting
        
        if (self.pixel.defense == 0) {
            //NSLog(@"Converting them to us");
            
            if (self.pixel.red > player.red) {
                [self.pixel setRed:self.pixel.red - 1];
            }
            else if (self.pixel.red < player.red) {
                [self.pixel setRed:self.pixel.red + 1];
            }
            
            if (self.pixel.green > player.green) {
                [self.pixel setGreen:self.pixel.green - 1];
            }
            else if (self.pixel.green < player.green) {
                [self.pixel setGreen:self.pixel.green + 1];
            }
            
            if (self.pixel.blue > player.blue) {
                [self.pixel setBlue:self.pixel.blue - 1];
            }
            else if (self.pixel.blue < player.blue) {
                [self.pixel setBlue:self.pixel.blue + 1];
            }
            
            //NSLog(@"New RGB: (%u,%u,%u)", self.pixel.red, self.pixel.green, self.pixel.blue);
            
            [self setColor:self.pixel.color];
            [self updateLabel];
        }
        else {
            //NSLog(@"lowering defense");
            [self.pixel setDefense:self.pixel.defense - 1];
            [self updateLabel];
        }
    }
    [self setColor:self.pixel.color];
}

-(void)hideLabel {
    [self.children.firstObject setHidden:TRUE];
}

-(void)showLabel {
    [self.children.firstObject setHidden:FALSE];
}

-(void)updateLabel {
    SKLabelNode *label = self.children.firstObject;
    [label setText:[NSString stringWithFormat:@"%u", self.pixel.defense]];
    if (self.pixel.red + self.pixel.green + self.pixel.blue > 382) {
        label.fontColor = [UIColor blackColor];
    }
    else {
        label.fontColor = [UIColor whiteColor];
    }
}

-(skersePixel*)pixel {
    return _pixel;
}

-(void)setPixel:(skersePixel *)pixel {
    _pixel = pixel;
    [self setColor:self.pixel.color];
    [self updateLabel];
}

@end
