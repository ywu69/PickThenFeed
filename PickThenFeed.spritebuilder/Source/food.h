//
//  food.h
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface food : CCSprite

@property (nonatomic, strong) CCActionMoveTo *currentAction;
@property (nonatomic, strong) NSString *foodType;

@end
