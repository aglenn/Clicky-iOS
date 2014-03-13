//
//  skerseServerStreamCommunicator.m
//  Clicky
//
//  Created by Alexander Glenn on 2/19/14.
//  Copyright (c) 2014 Skerse Productions. All rights reserved.
//

#import "skerseServerStreamCommunicator.h"
#import "MessagePack.h"
#import "skerseRegionParseOperation.h"
#import "skerseClickParseOperation.h"
#import "skerseGameInfoParseOperation.h"
#import "skersePlayer.h"

#define SERVER @"clicky.skerse.com"
#define PORT 11000

static skerseServerStreamCommunicator *sharedCommunicator;

@interface skerseServerStreamCommunicator()
@property (strong) NSInputStream *inStream;
@property (strong) NSOutputStream *outStream;
@property NSMutableData *inData;
@property uint32_t currentSize;
@property uint32_t readSize;
@property NSMutableArray *dataToSend;
@property NSOperationQueue *parseOperationQueue;
@property int regionID;
@property uint32_t spaceAvailable;
@end

@implementation skerseServerStreamCommunicator

-(skerseServerStreamCommunicator*)init {
    self = [super init];
    if (self) {
        //stuff
        _regionID = 0;
        _readSize = 0;
        _currentSize = 0;
        _parseOperationQueue = [[NSOperationQueue alloc] init];
        _dataToSend = [[NSMutableArray alloc] init];
        [self openStreams];
    }
    return self;
}

+(skerseServerStreamCommunicator*)sharedCommunicator {
    @synchronized(self) {
        if (!sharedCommunicator) {
            sharedCommunicator = [[skerseServerStreamCommunicator alloc] init];
        }
        return sharedCommunicator;
    }
}

-(void)fetchGameInfo:(uint32_t) gameNumber {
    NSDictionary *dict = @{@"id":@(gameNumber),@"message_name":@"game_info"};
    //NSLog(@"Dict: %@", dict);
    NSData* packed = [dict messagePack];
    
    uint32_t length = packed.length;
    uint32_t BIGlength = CFSwapInt32HostToBig(length);
    
    NSMutableData *d = [[NSMutableData alloc] init];
    [d appendBytes:&BIGlength length:4];
    [d appendData:packed];
    
    [_dataToSend addObject:d];
    [self send];
}

-(void)fetchRegion:(CGRect)rect {
    @synchronized(self) {
        //NSLog(@"Packing data");
        NSDictionary *dict = @{@"id":[NSString stringWithFormat:@"%d",_regionID],@"message_name":@"subscribe_region_nb", @"region":@{@"top_left":@[@((int)rect.origin.x),@((int)rect.origin.y)],@"bottom_right":@[@((int)rect.size.width + (int)rect.origin.x - 1),@((int)rect.size.height + (int)rect.origin.y - 1)]}};
        _regionID++;
        NSLog(@"Dict: %@", dict);
        NSData* packed = [dict messagePack];
        
        uint32_t length = packed.length;
        uint32_t BIGlength = CFSwapInt32HostToBig(length);
        
        NSMutableData *d = [[NSMutableData alloc] init];
        [d appendBytes:&BIGlength length:4];
        [d appendData:packed];
        
        [_dataToSend addObject:d];
        [self send];
        
    }
}

-(void)sendClick:(CGPoint)coordinate {
    @synchronized(self) {
        NSDictionary *dict = @{@"message_name":@"clicks", @"clicks":@[@{@"pixel":@[@((uint8_t)coordinate.x), @((uint8_t)coordinate.y)], @"name":@"iOS Client", @"rgb":@[@([skersePlayer currentPlayer].red), @([skersePlayer currentPlayer].green), @([skersePlayer currentPlayer].blue) ], @"num":@(1)}]};
        NSLog(@"Dict: %@", dict);
        NSData* packed = [dict messagePack];
        
        uint32_t length = packed.length;
        uint32_t BIGlength = CFSwapInt32HostToBig(length);
        
        NSMutableData *d = [[NSMutableData alloc] init];
        [d appendBytes:&BIGlength length:4];
        [d appendData:packed];
        
        [_dataToSend addObject:d];
        [self send];
        dict = nil;
        packed = nil;
    }
}

-(void)send {
    @synchronized(self) {
        if (_spaceAvailable) {
            if (_dataToSend.count > 0) {
                NSData *d = [_dataToSend firstObject];
                [_outStream write:[d bytes] maxLength:[d length]];
                NSLog(@"Sent %u bytes", d.length);
                [_dataToSend removeObjectAtIndex:0];
                _spaceAvailable--;
                d = nil;
            }
        }
    }
}

-(void)openStreams {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)SERVER, PORT, &readStream, &writeStream);
    
    _inStream  = (__bridge NSInputStream *) readStream;
    _outStream = (__bridge NSOutputStream *) writeStream;
    
    //_inStream = [[NSInputStream alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@", SERVER, PORT]]];
    [_inStream setDelegate:self];
    [_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inStream open];
    
    //_outStream  = [[NSOutputStream alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:%@", SERVER, PORT]] append:NO];
    [_outStream setDelegate:self];
    [_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outStream open];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    //NSLog(@"STREAM EVENT!");
    
    if ([stream isEqual:_inStream]) {
        //NSLog(@"Handling  in event %d", eventCode);
        switch(eventCode) {
            case NSStreamEventHasBytesAvailable:
                if(!_inData) {
                    _inData = [[NSMutableData alloc] init];
                }
                
                uint8_t *buf;
                uint32_t maxRead = 0;
                if (_currentSize == 0) {
                    buf = malloc(4*sizeof(uint8_t));
                    maxRead = 4 - _readSize;
                }
                else {
                    buf = malloc(_currentSize*sizeof(uint8_t));
                    maxRead = _currentSize - _readSize;
                }
                unsigned long len = 0;
                len = [(NSInputStream *)stream read:buf maxLength:maxRead];
                if(len) {
                    // NSLog(@"got %lu bytes", len);
                    _readSize += len;
                    [_inData appendBytes:(const void *)buf length:len];
                    
                    if (maxRead == 4 && _readSize == 4 && _currentSize == 0) {
                        // Read the frame size, and set _currentSize with the value
                        uint32_t size = *(const UInt32 *)[[_inData subdataWithRange:NSMakeRange(0, 4)] bytes];
                        _inData = nil;
                        size = CFSwapInt32BigToHost(size);
                        //NSLog(@"Getting some data of size: %u", size);
                        _currentSize = size;
                        _readSize = 0;
                    }
                    else {
                        if (_readSize == _currentSize) {
                            // unpack that shit
                            //NSLog(@"Parsing %u bytes", _inData.length);
                            NSDictionary *parsed = [[_inData subdataWithRange:NSMakeRange(0, _currentSize)] messagePackParse];
                            
                            //NSLog(@"Result: %@", parsed);
                            NSString *messageName = [parsed objectForKey:@"message_name"];
                            
                            if ([messageName isEqualToString:@"click_update"]) {
                                NSLog(@"Got click: %@", parsed);
                                skerseClickParseOperation *cPO = [[skerseClickParseOperation alloc] initWithDictionary:parsed];
                                [_parseOperationQueue addOperation:cPO];
                            }
                            else if ([messageName isEqualToString:@"region"]) {
                                skerseRegionParseOperation *rPO = [[skerseRegionParseOperation alloc] initWithDictionary:parsed];
                                [_parseOperationQueue addOperation:rPO];
                            }
                            else if ([messageName isEqualToString:@"game_info"]) {
                                skerseGameInfoParseOperation *gIPO = [[skerseGameInfoParseOperation alloc] initWithDictionary:parsed];
                                [_parseOperationQueue addOperation:gIPO];
                            }
                            else {
                                NSLog(@"Got unknown message: %@", messageName);
                            }
                            
                            _readSize = 0;
                            _currentSize = 0;
                            _inData = nil;
                        }
                        else {
                            //NSLog(@"Tried to parse, but I have %u bytes, and I need %u", _readSize, _currentSize);
                        }
                    }
                    
                    
                    
                } else {
                    NSLog(@"no buffer!");
                }
                break;
            case NSStreamEventErrorOccurred:
                NSLog(@"In stream Error: %@", stream.streamError.localizedDescription);
                break;
            case NSStreamEventEndEncountered:
                NSLog(@"In stream End");
                break;
        }
    }
    else {
        NSLog(@"Handling  out event %d", eventCode);
        switch(eventCode) {
            case NSStreamEventHasSpaceAvailable:
                _spaceAvailable++;
                [self send];
                break;
            case NSStreamEventErrorOccurred:
                NSLog(@"Out stream Error: %@", stream.streamError.localizedDescription);
                break;
            case NSStreamEventEndEncountered:
                NSLog(@"Out stream End");
                break;
        }
    }
    
}

@end
