//
//  LHDriverChannelImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverChannelImpl.h"
#import "LHComponents.h"
#import "LHTaskQueue.h"
#import "LHDriverFeedbackUpdateTask.h"

@interface LHDriverChannelImpl ()

@property (nonatomic, strong, readonly) id<LHNode> node;
@property (nonatomic, strong, readonly) LHComponents *components;
@property (nonatomic, strong, readonly) id<LHTaskQueue> updateQueue;

@property (nonatomic, strong) LHDriverFeedbackUpdateTask *currentTask;

@end


@implementation LHDriverChannelImpl

#pragma mark - Init

- (instancetype)initWithNode:(id<LHNode>)node components:(LHComponents *)components updateQueue:(id<LHTaskQueue>)updateQueue {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _components = components;
    _updateQueue = updateQueue;
    
    return self;
}

#pragma mark - LHDriverChannel

- (void)startNodeUpdateWithBlock:(LHDriverChannelUpdateBlock)updateBlock {
    NSParameterAssert(updateBlock != nil);

    if (self.currentTask) {
        [self.currentTask cancel];
        [self finishNodeUpdate];
    }
    
    self.currentTask = [[LHDriverFeedbackUpdateTask alloc] initWithComponents:self.components
                                                                      animated:YES
                                                                    sourceNode:self.node
                                                               nodeUpdateBlock:^{
                                                                   updateBlock(self.node);
                                                               }];
    
    [self.updateQueue runTask:self.currentTask];
}

- (void)startUrgentNodeUpdateWithBlock:(LHDriverChannelUpdateBlock)updateBlock {
    NSParameterAssert(updateBlock != nil);

    LHDriverFeedbackUpdateTask *task = [[LHDriverFeedbackUpdateTask alloc] initWithComponents:self.components
                                                                                     animated:YES
                                                                                   sourceNode:self.node
                                                                              nodeUpdateBlock:^{
                                                                                  updateBlock(self.node);
                                                                              }];

    [self.updateQueue runUrgentTask:task];

    if (self.currentTask) {
        [self.currentTask cancel];
        [self finishNodeUpdate];
    }

    self.currentTask = task;
}

- (void)finishNodeUpdate {
    [self.currentTask sourceDriverUpdateDidFinish];
    
    self.currentTask = nil;
}

@end
