//
//  popMenu.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "popMenu.h"

@implementation popMenu

-(void)menu{
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"MainScene"]];
}

-(void)retry{
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

-(void)help{
    CCScene *instructionScene = [CCBReader loadAsScene:@"instructionScene"];
    [[CCDirector sharedDirector] replaceScene:instructionScene];
}
@end
