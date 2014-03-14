//
//  Clicky_Tests.m
//  Clicky Tests
//
//  Created by Alexander Glenn on 3/12/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "skerseRegion.h"
#import "skersePixel.h"
#import "skerseServerStreamCommunicator.h"
#import "SenTestingKitAsync.h"
#import "skersePlayer.h"

@interface Clicky_Tests : SenTestCase

@end

@implementation Clicky_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Region Tests

-(void)testRegionInit {
    uint32_t rID = 5;
    skerseRegion *r = [[skerseRegion alloc] initWithID:rID];
    STAssertNotNil(r, @"The region was nil");
    STAssertEquals(r.regionID, rID, @"The region id was not initialized");
}

-(void)testRegionLoadPixels {
    NSArray *pixels = @[@26, @102, @12, @58, @65, @201, @255, @102, @98, @96, @74, @111];
    uint32_t rID = 5;
    skerseRegion *r = [[skerseRegion alloc] initWithID:rID];
    [r setYSize:2];
    [r setXSize:2];
    [r loadPixels:pixels];
    uint32_t count = 0;
    for (uint32_t y=0; y<r.pixels.count; y++) {
        NSArray *row = r.pixels[y];
        for (uint32_t x=0; x<row.count; x++) {
            count++;
        }
    }
    STAssertEquals(count, pixels.count/3, @"The pixels were not loaded correctly");
}

-(void)testRegionLoadPixelsBadInput {
    NSArray *pixels = @[@26, @102, @12, @58, @65, @201, @255, @102, @98, @96];
    uint32_t rID = 5;
    skerseRegion *r = [[skerseRegion alloc] initWithID:rID];
    [r setYSize:2];
    [r setXSize:2];
    [r loadPixels:pixels];
    uint32_t count = 0;
    for (uint32_t y=0; y<r.pixels.count; y++) {
        NSArray *row = r.pixels[y];
        for (uint32_t x=0; x<row.count; x++) {
            count++;
        }
    }
    STAssertEquals(count, pixels.count/3, @"The pixels were not loaded correctly");
}

-(void)testPixel {
    skersePixel *p = [[skersePixel alloc] init];
    
    uint16_t defense = 5;
    
    [p setDefense:defense];

    [p setRed:54];
    [p setGreen:65];
    [p setBlue:3];
    
    STAssertEquals(defense, p.defense, @"The defense of the pixel should be 5");
    STAssertNotNil(p.color, @"The color should have been created");
}

-(void)testGameFetch {
    skerseServerStreamCommunicator *sssC = [skerseServerStreamCommunicator sharedCommunicator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameFetched) name:@"GameInfo" object:nil];
    [sssC fetchGameInfo:1];
    STFailAfter(10, @"Hopefully it works after 10 secs");
}

-(void)gameFetched {
    STSuccess();
}

-(void)testRegionFetch {
    skerseServerStreamCommunicator *sssC = [skerseServerStreamCommunicator sharedCommunicator];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionFetched) name:@"NewRegion" object:nil];
    [sssC fetchRegion:CGRectMake(0, 0, 10, 10)];
    STFailAfter(10, @"Hopefully it works after 10 secs");
}

-(void)regionFetched {
    STSuccess();
}

-(void)testPlayer {
    skersePlayer *p = [[skersePlayer alloc] initWithRed:3 green:115 blue:65];
    skersePlayer *p2 = [skersePlayer currentPlayer];
    
    [p setRed:115];
    [p setGreen:6];
    [p setBlue:34];
    
    STAssertNotNil(p, @"Player should not me nil");
    STAssertNotNil(p2, @"Player should not me nil");
}

@end
