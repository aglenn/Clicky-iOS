//
//  skerseServerStreamCommunicator.h
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Findaway World. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface skerseServerStreamCommunicator : NSObject <NSStreamDelegate>

+(skerseServerStreamCommunicator*)sharedCommunicator;

-(void)fetchGameInfo:(uint32_t) gameNumber;
-(void)fetchRegion:(CGRect)rect;
-(void)sendClick:(CGPoint)coordinate;

@end
