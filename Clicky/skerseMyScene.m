//
//  skerseMyScene.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseMyScene.h"
#import "skerseRegionManager.h"
#import "Region.h"
#import "Pixel.h"
#import "skerseSKPixel.h"

#import "Constants.h"

@interface skerseMyScene()
@property BOOL labelsVisible;
@property BOOL updating;
@end

@implementation skerseMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        
        myLabel.color = [UIColor whiteColor];
        myLabel.text = @"Clicky";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        _labelsVisible = YES;
        _updating = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    /*
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
    */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (!_updating) {
        if (self.sceneScale < 3.5) {
            if (_labelsVisible) {
                //hide all labels
                
                for (id child in self.children) {
                    if ([[child class] isEqual:SKLabelNode.class]) {
                        [(SKLabelNode*)child setHidden:YES];
                    }
                }
                _labelsVisible = NO;
            }
        }
        else {
            if (!_labelsVisible) {
                //show all labels
                
                for (id child in self.children) {
                    if ([[child class] isEqual:SKLabelNode.class]) {
                        [(SKLabelNode*)child setHidden:NO];
                    }
                }
                _labelsVisible = YES;
            }
        }
    }
}

-(void)updateRegions {
    NSLog(@"Updating the regions");
    @synchronized(self ) {
        _updating = YES;
        [self removeAllChildren];
        for (int rg=0;rg<[skerseRegionManager sharedManager].regions.count;rg++) {
            Region *r = [skerseRegionManager sharedManager].regions[rg];
            for (int i=0; i<r.ySize; i++) {
                NSArray *row = r.pixels[i];
                for (int j=0; j<r.xSize; j++) {
                    Pixel *p = row[j];
                    skerseSKPixel *sKP = [[skerseSKPixel alloc] initWithPixel:p position:CGPointMake((r.xOrigin + j), (r.yOrigin + i))];
                    [self addChild:sKP];
                    SKLabelNode *label = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
                    [label setText:[NSString stringWithFormat:@"%u", p.defense]];
                    [label setPosition:CGPointMake((r.xOrigin + j)*PSIZE + PSIZE/2, (r.yOrigin + i)*PSIZE +2)];
                    [label setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
                    [label setFontSize:5];
                    [label setFontColor:[UIColor whiteColor]];
                    
                    if (self.sceneScale < 3.5) {
                        [label setHidden:YES];
                        _labelsVisible = NO;
                    }
                    
                    [self addChild:label];
                }
            }
        }
        _updating = NO;
    }
}

@end
