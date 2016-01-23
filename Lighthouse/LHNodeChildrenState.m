//
//  LHNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNodeChildrenState.h"

@implementation LHNodeChildrenState

@synthesize initializedChildren = _initializedChildren;
@synthesize activeChildren = _activeChildren;

- (instancetype)init {
    return [self initWithInitializedChildren:nil activeChildrenIndexSet:nil];
}

- (instancetype)initWithInitializedChildren:(NSOrderedSet<id<LHNode>> *)initializedChildren
                     activeChildrenIndexSet:(NSIndexSet *)activeChildrenIndexSet {
    self = [super init];
    if (!self) return nil;
    
    _initializedChildren = [initializedChildren copy] ?: [NSOrderedSet orderedSet];
    
    if (activeChildrenIndexSet) {
        _activeChildren = [NSSet setWithArray:[_initializedChildren objectsAtIndexes:activeChildrenIndexSet]];
    } else {
        _activeChildren = [NSSet set];
    }
    
    return self;
}

@end