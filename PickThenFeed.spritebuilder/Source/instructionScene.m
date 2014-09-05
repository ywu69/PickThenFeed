//
//  instructionScene.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "instructionScene.h"

@implementation instructionScene

- (void)Back {
    
    CCScene *MainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:MainScene];
}
@end
