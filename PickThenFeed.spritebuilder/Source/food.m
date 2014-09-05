//
//  food.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "food.h"

@implementation food{
    CGFloat foodMovebyDistance;
}

@synthesize currentAction;

-(void)onEnter{
    foodMovebyDistance = -600.f;
    [super onEnter];
    // tell this scene to accept touches
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    //    NSLog(@"touch...........");
    [self stopAction: currentAction];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    // we want to know the location of our touch in this scene
    CGPoint touchLocation = [touch locationInNode:self.parent];
    if (touchLocation.y <= 247) {
        self.position = CGPointMake(touchLocation.x, touchLocation.y + 25);
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    self.currentAction = [CCActionMoveBy actionWithDuration:5.f position:ccp(0, foodMovebyDistance)];
    [self runAction:self.currentAction];
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    self.currentAction = [CCActionMoveBy actionWithDuration:5.f position:ccp(0, foodMovebyDistance)];
    [self runAction:self.currentAction];
}
@end
