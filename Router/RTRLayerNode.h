//
//  RTRLayerNode.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@interface RTRLayerNode : NSObject <RTRNode>

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode;

@end
