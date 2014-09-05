//
//  GameEnd.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEnd.h"
#import "UserNamePrompt.h"
#import "Gameplay.h"

@implementation GameEnd{
    CCScrollView *nameScroll;
    CCLabelTTF *userRank;
}

- (void)didLoadFromCCB{
//    [super onEnter];
    
    NSUserDefaults *usrdef = [NSUserDefaults standardUserDefaults];
    NSString *usrname = [usrdef objectForKey:@"userName"];
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    
    if (usrname && usrname.length > 0)
    {
        //u already have user's name
        //submit
        [MGWU submitHighScore:[highScore intValue] byPlayer:usrname forLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:) onTarget:self];
    }
    else
    {
        //open usernameprompt
        UserNamePrompt *unp = (UserNamePrompt*)[CCBReader load:@"UserNamePrompt"];
        unp.highScore = [highScore intValue];
        [self addChild:unp];
        unp.position = ccp(182,145);
    }
}

- (void)receivedScores:(NSDictionary*)scores
{
    NSArray *topScore = [scores objectForKey:@"all"];
    NSInteger maxCount = (topScore.count > 10) ? 10 : topScore.count;
    NSNumber *yourRank = [[scores objectForKey:@"user"] objectForKey:@"rank"];
    userRank.string = [NSString stringWithFormat:@"%d", [yourRank intValue]];
    
    CGFloat y = 35;
    for (int i=0; i < maxCount; i++)
    {
        CCLabelTTF *label = [CCLabelTTF node];
        label.fontName = @"Sansation-BoldItalic.ttf";
        label.fontSize = 15.f;
        label.string = [NSString stringWithFormat:@"%i.", i+1];
        label.anchorPoint = CGPointMake(0, 0);
        label.position = CGPointMake(70, y);
        label.color = [CCColor colorWithRed:0.f green:0.f blue:0.f];
        label.positionType = CCPositionTypeMake(CCPositionTypePoints.xUnit, CCPositionTypePoints.yUnit, CCPositionReferenceCornerTopLeft);
        [[nameScroll contentNode] addChild:label];
        y+=label.contentSizeInPoints.height + 2;
    }
    
    y = 35;
    for (int i=0; i < maxCount; i++)
    {
        NSString *userName = [[topScore objectAtIndex:i] objectForKey:@"name"];
        
        CCLabelTTF *label = [CCLabelTTF node];
        label.fontName = @"Sansation-BoldItalic.ttf";
        label.fontSize = 15.f;
        label.string = [NSString stringWithFormat:@"%@",userName];
        label.anchorPoint = CGPointMake(0, 0);
        label.position = CGPointMake(130, y);
        label.color = [CCColor colorWithRed:0.f green:0.f blue:0.f];
        label.positionType = CCPositionTypeMake(CCPositionTypePoints.xUnit, CCPositionTypePoints.yUnit, CCPositionReferenceCornerTopLeft);
        [[nameScroll contentNode] addChild:label];
        y+=label.contentSizeInPoints.height + 2;
    }
    
    y = 35;
    for (int i=0; i < maxCount; i++)
    {
        NSNumber *userScore = [[topScore objectAtIndex:i] objectForKey:@"score"];
        
        CCLabelTTF *label = [CCLabelTTF node];
        label.fontName = @"Sansation-BoldItalic.ttf";
        label.fontSize = 15.f;
        label.string = [NSString stringWithFormat:@"%i",[userScore intValue]];
        label.anchorPoint = CGPointMake(0, 0);
        label.position = CGPointMake(210, y);
        label.color = [CCColor colorWithRed:0.f green:0.f blue:0.f];
        label.positionType = CCPositionTypeMake(CCPositionTypePoints.xUnit, CCPositionTypePoints.yUnit, CCPositionReferenceCornerTopLeft);
        [[nameScroll contentNode] addChild:label];
        y+=label.contentSizeInPoints.height + 2;
    }
//        nameScroll.contentNode.contentSizeInPoints = CGSizeMake(nameScroll.contentNode.contentSizeInPoints.width, y);
}

-(void)Retry {
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

-(void)qq{
    //    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"QQ互联测试"];
    //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
}

-(void)facebook{
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    if ([MGWU isFacebookActive]) {
        [MGWU shareWithTitle:@"PickThenFeed" caption:[NSString stringWithFormat:@"I got %li in PickThenFeed, beat me!",(long)highScore] andDescription:@" "];
    }
    else
    {
        [MGWU loginToFacebook];
    }
}

-(void)twitter{
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    if ([MGWU isTwitterActive]) {
        [MGWU postToTwitter:[NSString stringWithFormat:@"I got %li score in PickThenFeed, try to beat me!",(long)highScore]];
    }
}
@end