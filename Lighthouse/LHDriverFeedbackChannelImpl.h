//
//  LHDriverFeedbackChannelImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverFeedbackChannel.h"

@class LHComponents;
@class LHTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverFeedbackChannelImpl : NSObject <LHDriverFeedbackChannel>

- (instancetype)initWithNode:(id<LHNode>)node
                  components:(LHComponents *)components
                 updateQueue:(LHTaskQueue *)updateQueue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END