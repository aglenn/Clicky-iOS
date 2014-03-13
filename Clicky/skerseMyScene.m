//
//  skerseMyScene.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseMyScene.h"
#import "skerseRegionManager.h"
#import "skerseRegion.h"
#import "skersePixel.h"
#import "skerseSKPixel.h"

#import "Constants.h"

@interface skerseMyScene()
@property BOOL labelsVisible;
@property BOOL updating;
@property SKNode *world;
@end

@implementation skerseMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];

        _labelsVisible = YES;
        _updating = NO;
        
        _world = [SKNode node];
        [self addChild:_world];
        
        
        _camera = [SKNode node];
        _camera.name = @"camera";
        [_world addChild:_camera];
    }
    return self;
}

-(void)setWorldScale:(float)worldScale {
    _worldScale = worldScale;
    [_world setScale:worldScale];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (!_updating) {
        if (self.worldScale < .7) {//3.5) {
            if (_labelsVisible) {
                //hide all labels
                
                for (id child in _world.children) {
                    if ([child isKindOfClass:[skerseSKPixel class]]) {
                        [(skerseSKPixel*)child hideLabel];
                    }
                }
                _labelsVisible = NO;
            }
        }
        else {
            if (!_labelsVisible) {
                //show all labels
                
                for (id child in _world.children) {
                    if ([child isKindOfClass:[skerseSKPixel class]]) {
                        [(skerseSKPixel*)child showLabel];
                    }
                }
                _labelsVisible = YES;
            }
        }
    }
}

- (void)didSimulatePhysics
{
    [self centerOnNode: [self childNodeWithName: @"//camera"]];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x, node.parent.position.y - cameraPositionInScene.y);
}


-(void)addRegion:(NSNotification*) n {
    //NSLog(@"Updating the regions");
    @synchronized(self ) {
        _updating = YES;
        uint32_t regionID = [[n.userInfo objectForKey:@"RegionID"] unsignedIntValue];
        skerseRegion *r = [skerseRegionManager sharedManager].regions[regionID];
        for (int i=0; i<r.ySize; i++) {
            NSArray *row = r.pixels[i];
            for (int j=0; j<r.xSize; j++) {
                skersePixel *p = row[j];
                skerseSKPixel *sKP = [[skerseSKPixel alloc] initWithPixel:p position:CGPointMake((r.xOrigin + j), (r.yOrigin + i))];
                [sKP setName:[NSString stringWithFormat:@"(%d,%d)", j, i]];
                [_world addChild:sKP];
                if (self.worldScale < .7) {
                    [sKP hideLabel];
                }
            }
        }
        _updating = NO;
    }
}

-(void)handleClick:(NSNotification*)n {
    
    uint32_t rID = [[n.userInfo objectForKey:@"rID"] unsignedIntValue];
    skersePixel *p = [n.userInfo objectForKey:@"pixel"];
    
    skerseRegion *r = [skerseRegionManager sharedManager].regions[rID];
    
    uint32_t x = [[n.userInfo objectForKey:@"x"] unsignedIntValue] - r.xOrigin;
    uint32_t y = [[n.userInfo objectForKey:@"y"] unsignedIntValue] - r.yOrigin;
    
    NSLog(@"handling click for region %d, (%d,%d)", rID, x, y);
    
    [r.pixels[y] replaceObjectAtIndex:x withObject:p];
    
    skerseSKPixel *pixel = (skerseSKPixel*)[self.world childNodeWithName:[NSString stringWithFormat:@"(%d,%d)", x, y]];
    NSLog(@"tried to get skpixel, it %@", pixel ? @"Exists":@"Doesnt exist");
    [pixel setPixel:p];
}

@end
