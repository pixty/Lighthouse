//
//  LHDriverProvider.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;
@protocol LHDriver;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriverProvider <NSObject>

- (nullable id<LHDriver>)driverForNode:(id<LHNode>)node;

@end


NS_ASSUME_NONNULL_END