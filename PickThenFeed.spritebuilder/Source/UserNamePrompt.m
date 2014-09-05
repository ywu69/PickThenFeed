//
//  UserNamePrompt.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "UserNamePrompt.h"

@implementation UserNamePrompt{
    CCTextField *_userName;
}

- (void)submit{
    
    if (_userName.string.length >= 2) {
        
        NSUserDefaults *userName = [NSUserDefaults standardUserDefaults];
        [userName setObject:_userName.string forKey:@"userName"];
        [userName synchronize];
        
        [MGWU submitHighScore:self.highScore byPlayer:_userName.string forLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:) onTarget:self.parent];
        [self removeFromParentAndCleanup:YES];
    }
}

- (void)receivedScores:(NSDictionary*)scores
{
    
}
@end
