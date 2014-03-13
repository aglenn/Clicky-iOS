//
//  skerseMyScene.h
//  Clicky
//

//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface skerseMyScene : SKScene
@property float worldScale;
-(void)addRegion:(NSNotification*)n;
-(void)handleClick:(NSNotification*)n;
@property SKNode *camera;
@end
