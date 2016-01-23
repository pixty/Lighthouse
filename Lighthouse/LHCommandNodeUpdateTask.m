//
//  LHCommandNodeUpdateTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHCommandNodeUpdateTask.h"
#import "LHCommand.h"
#import "LHCommandRegistry.h"
#import "LHComponents.h"
#import "LHNode.h"
#import "LHTarget.h"
#import "LHGraph.h"

@interface LHCommandNodeUpdateTask ()

@property (nonatomic, strong, readonly) id<LHCommand> command;

@end


@implementation LHCommandNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated command:(id<LHCommand>)command {
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _command = command;
    
    return self;
}

#pragma mark - LHNodeUpdateTask

- (void)updateNodes {
    id<LHTarget> target = [self.components.commandRegistry targetForCommand:self.command];
    
    while (target) {
        NSMapTable *targetsByParent = [self splitTargetIntoTargetsByParent:target];
        
        NSMutableArray<id<LHNode>> *parentsToDeactivate = [NSMutableArray array];
        
        for (id<LHNode> parent in targetsByParent) {
            id<LHTarget> target = [targetsByParent objectForKey:parent];
            
            LHNodeUpdateResult result = [parent updateChildrenState:target];
            
            switch (result) {
                case LHNodeUpdateResultNormal:
                    // we're good
                    break;
                    
                case LHNodeUpdateResultDeactivation:
                    [parentsToDeactivate addObject:parent];
                    break;
                    
                case LHNodeUpdateResultInvalid:
                    NSAssert(NO, @""); // TODO
                    break;
            }
        }
        
        target = parentsToDeactivate.count > 0 ? [LHTarget withInactiveNodes:parentsToDeactivate] : nil;
    }
}

- (BOOL)shouldUpdateDriverForNode:(id<LHNode>)node {
    return YES;
}

#pragma mark - Stuff

- (NSMapTable<id<LHNode>, id<LHTarget>> *)splitTargetIntoTargetsByParent:(id<LHTarget>)jointTarget {
    NSMapTable<id<LHNode>, id<LHTarget>> *targetsByParent = [NSMapTable strongToStrongObjectsMapTable];
    
    for (id<LHNode> activeNode in jointTarget.activeNodes) {
        NSOrderedSet<id<LHNode>> *pathToNode = [self.components.graph pathToNode:activeNode];
        
        [pathToNode enumerateObjectsUsingBlock:^(id<LHNode> node, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                return;
            }
            
            id<LHNode> parent = pathToNode[idx - 1];
            
            id<LHTarget> target = [targetsByParent objectForKey:parent];
            
            if (target) {
                target = [[LHTarget alloc] initWithActiveNodes:[target.activeNodes setByAddingObject:node]
                                                  inactiveNodes:target.inactiveNodes];
            } else {
                target = [LHTarget withActiveNode:node];
            }
            
            [targetsByParent setObject:target forKey:parent];
        }];
    }
    
    for (id<LHNode> inactiveNode in jointTarget.inactiveNodes) {
        NSOrderedSet<id<LHNode>> *pathToNode = [self.components.graph pathToNode:inactiveNode];
        
        id<LHNode> parent = pathToNode[pathToNode.count - 2];
        
        id<LHTarget> target = [targetsByParent objectForKey:parent];
        
        if (target) {
            target = [[LHTarget alloc] initWithActiveNodes:target.activeNodes
                                              inactiveNodes:[target.inactiveNodes setByAddingObject:inactiveNode]];
        } else {
            target = [LHTarget withInactiveNode:inactiveNode];
        }
        
        [targetsByParent setObject:target forKey:parent];
    }
    
    return targetsByParent;
}

@end