//
//  banana.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "banana.h"

@implementation banana

@synthesize currentAction;


-(id)init
{
    self = [super init];
    if (self)
    {
        self.foodType = 1;
    }
    return self;
}

-(void)onEnter{
    
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
    self.position = touchLocation;
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    self.currentAction = [CCActionMoveTo actionWithDuration:5.f position:ccp(self.position.x, -5)];
    [self runAction:self.currentAction];
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    self.currentAction = [CCActionMoveTo actionWithDuration:5.f position:ccp(self.position.x, -5)];
    [self runAction:self.currentAction];
}

- (void)update:(CCTime)delta{
    if (self.position.y < -3) {
        [self removeFromParent];
    }
}

@end
