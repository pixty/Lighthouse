//
//  LHUpdateBus.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHCommand;

NS_ASSUME_NONNULL_BEGIN


typedef void (^LHCommandHandlerBlock)(__kindof id<LHCommand> command, BOOL animated);
typedef BOOL (^LHSingleShotCommandHandlerBlock)(__kindof id<LHCommand> command, BOOL animated);

typedef void (^LHStateHandlerBlock)(LHNodeState state);


@protocol LHUpdateBus <NSObject>

- (void)addCommandHandler:(LHCommandHandlerBlock)handlerBlock;

- (void)addSingleShotCommandHandler:(LHSingleShotCommandHandlerBlock)handlerBlock;

- (void)addCommandClass:(Class)commandClass handler:(LHCommandHandlerBlock)handlerBlock;


- (void)addStateUpdateHandler:(LHStateHandlerBlock)handlerBlock;

@end


NS_ASSUME_NONNULL_END