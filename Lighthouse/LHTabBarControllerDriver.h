//
//  LHTabBarControllerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"
#import <UIKit/UIKit.h>

@class LHTabNode;
@class LHDriverTools;
@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHTabBarControllerDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly) UITabBarController *data;

- (instancetype)initWithNode:(LHTabNode *)node tools:(LHDriverTools *)tools;

- (instancetype)init NS_UNAVAILABLE;

- (void)bindDescendantNode:(id<LHNode>)descendantNode toTabBarItem:(UITabBarItem *)tabBarItem;

@end


NS_ASSUME_NONNULL_END