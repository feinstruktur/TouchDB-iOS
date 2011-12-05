//
//  ToyRev.m
//  ToyCouch
//
//  Created by Jens Alfke on 12/2/11.
//  Copyright (c) 2011 Couchbase, Inc. All rights reserved.
//

#import "ToyRev.h"
#import "Test.h"


@implementation ToyRev

- (id) initWithDocID: (NSString*)docID 
               revID: (NSString*)revID 
             deleted: (BOOL)deleted
{
    self = [super init];
    if (self) {
        Assert(docID && revID);
        _docID = docID.copy;
        _revID = revID.copy;
        _deleted = deleted;
    }
    return self;
}

- (void)dealloc {
    [_docID release];
    [_revID release];
    [_document release];
    [super dealloc];
}

@synthesize docID=_docID, revID=_revID, deleted=_deleted, document=_document;

- (NSString*) description {
    return $sprintf(@"{%@ #%@%@}", _docID, _revID, (_deleted ?@" DEL" :@""));
}

- (BOOL) isEqual:(id)object {
    return [_docID isEqual: [object docID]] && [_revID isEqual: [object revID]];
}

- (NSUInteger) hash {
    return _docID.hash ^ _revID.hash;
}

@end



@implementation ToyRevSet

- (id)init {
    self = [super init];
    if (self) {
        _revs = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_revs release];
    [super dealloc];
}

- (NSString*) description {
    return _revs.description;
}

- (NSUInteger) count {
    return _revs.count;
}

- (void) addRev: (ToyRev*)rev {
    [_revs addObject: rev];
}

- (void) removeRev: (ToyRev*)rev {
    [_revs removeObject: rev];
}

- (ToyRev*) revWithDocID: (NSString*)docID revID: (NSString*)revID {
    ToyRev* example = [[ToyRev alloc] initWithDocID: docID revID: revID deleted: NO];
    ToyRev* result = [_revs member: example];
    [example release];
    return result;
}

- (NSEnumerator*) objectEnumerator {
    return _revs.objectEnumerator;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained [])buffer
                                    count:(NSUInteger)len 
{
    return [_revs countByEnumeratingWithState: state objects: buffer count: len];
}

- (NSArray*) allDocIDs {
    NSMutableArray* docIDs = [NSMutableArray arrayWithCapacity: _revs.count];
    for (ToyRev* rev in _revs)
        [docIDs addObject: rev.docID];
    return docIDs;
}

@end