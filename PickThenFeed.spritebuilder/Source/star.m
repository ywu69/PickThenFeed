//
//  star.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "star.h"

@implementation star

- (void)update:(CCTime)delta{

    //remove star when they out of screen
        if (self.position.y < -3) {
            [self removeFromParent];
    }
}
@end
