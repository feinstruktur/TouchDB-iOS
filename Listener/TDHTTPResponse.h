//
//  TDHTTPResponse.h
//  TouchDB
//
//  Created by Jens Alfke on 12/29/11.
//  Copyright (c) 2011 Couchbase, Inc. All rights reserved.
//

#import "HTTPResponse.h"
@class TDHTTPConnection, TDRouter, TDResponse;


@interface TDHTTPResponse : NSObject <HTTPResponse>
{
    TDRouter* _router;
    TDHTTPConnection* _connection;
    TDResponse* _response;
    BOOL _finished;
    BOOL _chunked;
    NSMutableData* _data;       // Data received, waiting to be read by the connection
    UInt64 _dataOffset;         // Offset in response of 1st byte of _data
    UInt64 _offset;             // Offset in response for next readData
}

- (id) initWithRouter: (TDRouter*)router forConnection:(TDHTTPConnection*)connection;

@end
