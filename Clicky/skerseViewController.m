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

@interface skerseViewController()
@property UIPinchGestureRecognizer *pinchGR;
@property UIPanGestureRecognizer *panGR;
@property skerseMyScene *scene;
@end

@implementation skerseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [skerseMyScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFit;
    //[_scene runAction:[SKAction scaleBy:.25 duration:0]];
    
    // Present the scene.
    [skView presentScene:_scene];
    
    [[NSNotificationCenter defaultCenter] addObserver:_scene selector:@selector(updateRegions) name:@"NewRegion" object:nil];
    
    skerseServerStreamCommunicator *sssC = [skerseServerStreamCommunicator sharedCommunicator];
    [sssC fetchRegion:CGRectMake(0, 0, 10, 10)];
    
    _scene.sceneScale = 1;
/*
    _pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched)];
    [_pinchGR setDelegate:self];
    [self.view addGestureRecognizer:_pinchGR];
    _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannned)];
    [_panGR setDelegate:self];
    [self.view addGestureRecognizer:_panGR];
 */
}

-(void)pinched {
    
    float velocity = 1.0;
    if (abs(_pinchGR.velocity) >= 1.0) {
        velocity = abs(_pinchGR.velocity);
    }
    
    float fixedScale = ((_pinchGR.scale - 1)/12 * velocity)+1;

    if ((_scene.sceneScale < 50 || fixedScale < 1.0) && (_scene.sceneScale > 0.1 || fixedScale > 1.0)) {
        [_scene runAction:[SKAction scaleBy:fixedScale duration:0]];
        _scene.sceneScale = _scene.sceneScale*fixedScale;
        
    }
}

-(void)pannned {
    CGPoint translation = [_panGR translationInView:self.view];
    
    SKAction *move = [SKAction moveBy:CGVectorMake(translation.x, -translation.y) duration:0];
    [_scene runAction:move];
    
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
