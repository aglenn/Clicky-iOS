//
//  Clicky_Tests.m
//  Clicky Tests
//
//  Created by Alexander Glenn on 3/12/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "skerseRegion.h"

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

@end
