//
//  skerseViewController.m
//  Clicky
//
//  Created by Alexander Glenn on 2/20/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseViewController.h"
#import "skerseMyScene.h"
#import "skerseServerStreamCommunicator.h"
#import "skerseGameInfo.h"
#import "skerseRegionManager.h"

@interface skerseViewController()
@property UIPinchGestureRecognizer *pinchGR;
@property UIPanGestureRecognizer *panGR;
@property skerseMyScene *scene;
@property uint32_t camX;
@property uint32_t camY;

@end

@implementation skerseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupScene) name:@"GameInfo" object:nil];
    
    skerseServerStreamCommunicator *sssC = [skerseServerStreamCommunicator sharedCommunicator];
    [sssC fetchGameInfo:1];
    

    _pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched)];
    [_pinchGR setDelegate:self];
    [self.view addGestureRecognizer:_pinchGR];

 
    _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannned)];
    [_panGR setDelegate:self];
    [self.view addGestureRecognizer:_panGR];
    
    _camX = 0;
    _camY = 0;
}

-(void)setupScene {
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [skerseMyScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFit;
    //[_scene runAction:[SKAction scaleBy:.25 duration:0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:_scene selector:@selector(addRegion:) name:@"NewRegion" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_scene selector:@selector(handleClick:) name:@"Click" object:nil];
    
    // Present the scene.
    [skView presentScene:_scene];
    
    [[skerseRegionManager sharedManager] beginRegionFetch];
        
    _scene.worldScale = 1;
}

-(void)pinched {
    
    float velocity = 1.0;
    if (abs(_pinchGR.velocity) >= 1.0) {
        velocity = abs(_pinchGR.velocity);
    }
    
    float fixedScale = ((_pinchGR.scale - 1)/12 * velocity)+1;

    if ((_scene.worldScale < 50 || fixedScale < 1.0) && (_scene.worldScale > 0.1 || fixedScale > 1.0)) {
        [_scene setWorldScale:_scene.worldScale*fixedScale];
    }
}

-(void)pannned {
    CGPoint translation = [_panGR translationInView:self.view];
    /*
    NSLog(@"TX: %f TY: %f", translation.x, translation.y);
    float tX = translation.x;
    if (_camX + tX < 0) {
        tX = -_camX;
    }
    
    float tY = translation.y;
    if (_camX + tY > 0) {
        tY = _camY;
    }
    
    NSLog(@"Moving y from %f to %f", _camY, _camY + tY);
    
    if (tX != 0) {
        SKAction *moveX = [SKAction moveBy:CGVectorMake(-tX, 0) duration:0];
        [_scene.camera runAction:moveX];
        _camX = _camX + tX;
    }
    
    if (tY != 0) {
        SKAction *moveY = [SKAction moveBy:CGVectorMake(0, tY) duration:0];
        [_scene.camera runAction:moveY];
        _camY = _camY + tY;
    }
    */
    
    NSLog(@"pos x %f posy %f", _scene.camera.position.x, _scene.camera.position.y);
    // DONT LET POS GO POSITIVE
    
    
    SKAction *move = [SKAction moveBy:CGVectorMake(-translation.x, translation.y) duration:0];
    [_scene.camera runAction:move];
    [_panGR setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
