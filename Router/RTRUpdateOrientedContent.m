//
//  RTRUpdateOrientedContent.m
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRUpdateOrientedContent.h"
#import "RTRCommand.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRUpdateHandlerImpl.h"

@interface RTRUpdateOrientedContent ()

@property (nonatomic, readonly) NSMapTable *dataInitBlocksByCommandClass;

@property (nonatomic, readonly) RTRUpdateHandlerImpl *updateHandler;

@end


@implementation RTRUpdateOrientedContent

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRNodeContentDataInitBlock)block {
    [self.dataInitBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRNodeContent

@synthesize data = _data;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)context {
    id<RTRCommand> command = context.command;
    
    if (!_data) {
        RTRNodeContentDataInitBlock block = [self.dataInitBlocksByCommandClass objectForKey:[command class]];
        
        if (!block) {
            block = self.defaultDataInitBlock;
        }
        
        if (block) {
            _data = block(command, self.updateHandler);
        }
        
        NSAssert(_data != nil, @""); // TODO
    } else {
        [self.updateHandler handleCommand:command animated:context.animated];
    }
}

- (void)stateDidChange:(RTRNodeState)state {
    [self.updateHandler handleStateUpdate:state];
}

#pragma mark - Lazy stuff

@synthesize dataInitBlocksByCommandClass = _dataInitBlocksByCommandClass;
@synthesize updateHandler = _updateHandler;

- (NSMapTable *)dataInitBlocksByCommandClass {
    if (!_dataInitBlocksByCommandClass) {
        _dataInitBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _dataInitBlocksByCommandClass;
}

- (RTRUpdateHandlerImpl *)updateHandler {
    if (!_updateHandler) {
        _updateHandler = [[RTRUpdateHandlerImpl alloc] init];
    }
    return _updateHandler;
}

@end