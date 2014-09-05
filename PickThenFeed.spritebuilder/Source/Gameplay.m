//
//  Gameplay.m
//  PickThenFeed
//
//  Created by Yuefeng Wu on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "food.h"
#import "animal.h"
#import "star.h"
#import "GameEnd.h"
#import "popMenu.h"
#import <AudioToolbox/AudioServices.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation Gameplay{
    
    CCPhysicsNode *_midPhysicsNode;
    CCPhysicsNode *_startPhysicsNode;
    CCNode *midField;
    CCNode *startField;
    CCNode *endField;
    CCNode *topField;
    CCNode *countDown;
    CCNode *noStar;
    CCNode *playButton;
    CCNode *pauseButton;
    BOOL pauseEnabel;
    int initbadGuyNumber;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highscoreLabel;
    CCLabelTTF *_sosScoreLabel;
    CCSprite *shark;
    CCLabelTTF *goodWords;
 
    int displayedAnimal;
    int displayedfood;
    int displayedPosition;
    int sosScore;
    
    animal *currentAnimal;
    animal *bonusAnimal_1;
    animal *bonusAnimal_2;
    animal *bonusAnimal_3;
    food *currentFood;
    star *currentStar;
    popMenu *popmenu;
    
    CGFloat foodSpeed;
    CGFloat foodMovebyDistance;
    
    CGFloat launchFoodTime;
    CGFloat launchAnimalTime;
    CGFloat launchBonusTime;
    
    NSMutableArray *foodarray;
    NSMutableArray *badGuysarray;
    NSMutableArray *bonusAnimalsarray;
    
    // get the size of user's screen
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    // animals positions
    CGPoint animalPosition1;
    CGPoint animalPosition2;
    CGPoint animalPosition3;
    
    //play a sound effect
    OALSimpleAudio *scoreAudio;
    OALSimpleAudio *bonusAudio;
    OALSimpleAudio *backgroundAudio;
    OALSimpleAudio *gameoverAudio;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    
    // use array to store objects
    foodarray = [NSMutableArray array];
    badGuysarray = [NSMutableArray array];
    bonusAnimalsarray = [NSMutableArray array];
    
    // set initial speed and drop distance for food
    foodSpeed = 40.f;
    foodMovebyDistance = -600.f;
    
    // set initial launch durations
    launchFoodTime = 1.5f;
    launchAnimalTime = 6.f;
    launchBonusTime = 10.f;

    // obtain the size of user's screen
    screenWidth = [[CCDirector sharedDirector] viewSize].width;
    screenHeight = [[CCDirector sharedDirector] viewSize].height;
    
    // init animals positions
    animalPosition1 = ccp(screenWidth + 15, 50);
    animalPosition2 = ccp(screenWidth + 15, 150);
    animalPosition3 = ccp(screenWidth + 15, 227);
    
    //play a sound effect
    scoreAudio = [OALSimpleAudio sharedInstance];
    backgroundAudio = [OALSimpleAudio sharedInstance];
    gameoverAudio = [OALSimpleAudio sharedInstance];
    bonusAudio = [OALSimpleAudio sharedInstance];
    
    // add an observer to observe the highscore change
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"highscore"
                                               options:0
                                               context:NULL];
    // load highscore
    [self updateHighscore];
}

-(void)onEnter{
    
    [super onEnter];
    
    self.userInteractionEnabled = YES;
    
    // launch initial food to scene
    [self launchFood];
    
    // launch initial animal to scene
    [self launchAnimal];
    
    // launch badGuys to scene
    initbadGuyNumber = 1;
    while (initbadGuyNumber > 0) {
        [self launchbadGuy];
        initbadGuyNumber--;
    }

    [self schedule:@selector(launchFood) interval:launchFoodTime];
    [self schedule:@selector(launchAnimal) interval:launchAnimalTime];
    [self schedule:@selector(launchBonus) interval:launchBonusTime];
    
    //shark animation
    CCActionMoveTo *moveUp = [CCActionMoveTo actionWithDuration:1.5f position:ccp(shark.position.x, 10)];
    CCActionMoveTo *moveDown = [CCActionMoveTo actionWithDuration:1.5f position:ccp(shark.position.x, -15)];
    CCActionSequence *actionSequence = [CCActionSequence actionWithArray:@[moveUp,moveDown]];
    CCActionRepeatForever *sharkRepeat =[CCActionRepeatForever actionWithAction:actionSequence];
    [shark runAction:sharkRepeat];
    
    //play a background sound effect
    backgroundAudio.bgVolume = 0.9;
    [backgroundAudio playBg:@"happy_adveture.mp3" loop:TRUE];
    
    //add pause button
    pauseButton = [CCBReader load:@"pauseButton"];
    [topField addChild:pauseButton];
    pauseButton.position = ccp(40,20);
    pauseButton.scale = 0.7;
    
    //add play button
    playButton = [CCBReader load:@"playButton"];
    [topField addChild:playButton];
    playButton.position = ccp(40,20);
    playButton.scale = 0.7;
    playButton.visible = NO;
}

-(void)launchFood {
    
    // launch food to scene
    displayedfood = (arc4random() % 3) + 1;
    if (displayedfood == 1) {
        [self launchBanana];
    }
    
    if (displayedfood == 2) {
        [self launchFish];
    }
    
    if (displayedfood == 3) {
        [self launchNut];
    }
}

-(void)launchBanana{
    food *_banana = (food*)[CCBReader load:@"banana"];
    //        // save badGuys in the badGuys Array
    _banana.foodType = @"banana";
    
    [foodarray addObject:_banana];
    
    // ajust the size of banana
    _banana.scale = 1;
    
    _banana.position = ccp(30, 262);
    
    // add the badGuy to the physicsNode of this scene
    [self addChild:_banana];
    
    _banana.currentAction = [CCActionMoveBy actionWithDuration:abs(foodMovebyDistance)/foodSpeed position:ccp(0, foodMovebyDistance)];
    [_banana runAction:_banana.currentAction];
}

-(void)launchFish{
    food *_fish = (food*)[CCBReader load:@"fish"];
    _fish.foodType = @"fish";
    
    [foodarray addObject:_fish];
    // ajust the size of banana
    _fish.scale = 0.4;
    
    _fish.position = ccp(30, 265);
    
    // add the badGuy to the physicsNode of this scene
    [self addChild:_fish];
    
    _fish.currentAction = [CCActionMoveBy actionWithDuration:abs(foodMovebyDistance)/foodSpeed position:ccp(0, foodMovebyDistance)];
    [_fish runAction:_fish.currentAction];
}

-(void)launchNut{
    food *_nut = (food*)[CCBReader load:@"nut"];
    _nut.foodType = @"nut";
    
    [foodarray addObject:_nut];
    
    // ajust the size of banana
    _nut.scale = 0.5;
    
    _nut.position = ccp(30, 265);
    
    // add the badGuy to the physicsNode of this scene
    [self addChild:_nut];
    
    _nut.currentAction = [CCActionMoveBy actionWithDuration:abs(foodMovebyDistance)/foodSpeed position:ccp(0, foodMovebyDistance)];
    [_nut runAction:_nut.currentAction];
}

-(void)launchAnimal {
    [currentAnimal removeFromParent];
    // launch food to scene
    displayedAnimal = (arc4random() % 3) + 1;
    if (displayedAnimal == 1) {
        [self launchMonkey];
    }
    
    if (displayedAnimal == 2) {
        [self launchPenguin];
    }
    
    if (displayedAnimal == 3) {
        [self launchSquirrel];
    }
    
    // use random number to decide int position of animals
    displayedPosition = (arc4random() % 3) + 1;
    if (displayedPosition == 1) {
        currentAnimal.position = animalPosition1;
        
    }
    if (displayedPosition == 2) {
        currentAnimal.position = animalPosition2;
        
    }
    if (displayedPosition == 3) {
        currentAnimal.position = animalPosition3;
        
    }
    
    // add the badGuy to the physicsNode of this scene
    [self addChild:currentAnimal];
    
    // moving animation
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:launchAnimalTime/2 position:ccpSub(currentAnimal.position, ccp(55, 0))];
    CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:launchAnimalTime/2 position:ccpAdd(currentAnimal.position, ccp(30, 0))];
    CCActionSequence *actionSequence = [CCActionSequence actionWithArray:@[moveLeft,moveRight]];
    [currentAnimal runAction:actionSequence];
}

-(void)launchMonkey{
    currentAnimal = (animal*)[CCBReader load:@"monkey"];
    // save badGuys in the badGuys Array
    currentAnimal.animalType = @"monkey";
    
    // ajust the size of banana
    currentAnimal.scale = 0.8;
}

-(void)launchPenguin{
    currentAnimal = (animal*)[CCBReader load:@"penguin"];
    
    currentAnimal.animalType = @"penguin";
    
    // ajust the size of banana
    currentAnimal.scale = 3;
}

-(void)launchSquirrel{
    currentAnimal = (animal*)[CCBReader load:@"squirrel"];
    
    currentAnimal.animalType = @"squirrel";
    
    // ajust the size of banana
    currentAnimal.scale = 0.9;
}

// launch badGuy to screen
- (void)launchbadGuy {
    
    // generate a random coordinate to launch the badGuy
    CGFloat randomX = arc4random_uniform(midField.contentSize.width*screenWidth/2 - 20) + midField.position.x +10;
    CGFloat randomY = arc4random_uniform(midField.contentSize.height - 40) + 10;
    // loads the badGuy.ccb we have set up in Spritebuilder
    CCNode* badGuy = [CCBReader load:@"badGuy"];
    
    // save badGuys in the badGuys Array
    [badGuysarray addObject:badGuy];
    
    // ajust the size of badGuy
    badGuy.scale = 0.3;
    
    // position the badGuy at the random position
    badGuy.position = ccp(randomX, randomY);
    
    // add the badGuy to the physicsNode of this scene
    [_startPhysicsNode addChild:badGuy];
    
    // manually create & apply a force to launch the badGuy
    CGPoint launchDirection = ccp(randomX, randomY);
    CGPoint force = ccpMult(launchDirection, 300);
    [badGuy.physicsBody applyForce:force];
}

// launch bonus to screen
-(void)launchBonus{
    // generate a random coordinate to launch the bonus
    CGFloat randomX = arc4random_uniform(midField.contentSize.width*screenWidth - 25) + midField.position.x +20;
//    CGFloat randomY = arc4random_uniform(midField.contentSize.height - 40) + 20;
    CGFloat randomY = 270;
    
    // loads the star.ccb we have set up in Spritebuilder
    currentStar = (star*)[CCBReader load:@"star"];
    
//    // save badGuys in the badGuys Array
//    [starsarray addObject:currentStar];
    
    // ajust the size of badGuy
    currentStar.scale = 0.4;
    
    // position the badGuy at the random position
    currentStar.position = ccp(randomX, randomY);
    
    // add the badGuy to the physicsNode of this scene
    [self addChild:currentStar];
    
    // star will move down
    CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:3.f position:ccp(currentStar.position.x,-5)];
    [currentStar runAction:moveTo];
}

- (void)update:(CCTime)delta{

    //remove food when they out of screen
    NSMutableArray *tempfoodarray = [NSMutableArray array];
    for (food* food in foodarray) {
        if (food.position.y < -3) {
            [food removeFromParent];
            [tempfoodarray addObject:food];
        }
    }
    for (food* food in tempfoodarray) {
        [foodarray removeObject:food];
    }
    
    // check collision between food and badGuy
    for (CCSprite* badGuy in badGuysarray) {
        for (food* food in foodarray) {
            if(CGRectContainsPoint([badGuy boundingBox], food.position)){
                [food removeFromParent];
                [self lose];
            }
        }
    }
    
    // check collision between food and shark
        for (food* food in foodarray) {
            if(CGRectContainsPoint([shark boundingBox], food.position)){
                [food removeFromParent];
//                [scoreAudio playEffect:@"bite.mp3"];
                [self lose];
            }
        }
    
    // check collision between food and animal
    NSMutableArray *tempfoodRemovearray = [NSMutableArray array];
    for (food* food in foodarray) {
        if (CGRectIntersectsRect(food.boundingBox, currentAnimal.boundingBox)) {
            if ([food.foodType isEqualToString:@"banana"] && [currentAnimal.animalType isEqualToString:@"monkey"]) {
                self.score++;
                //play a sound effect
                [scoreAudio playEffect:@"bite.mp3"];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                //remove food when they collide with animal
                [food removeFromParent];
                [tempfoodRemovearray addObject:food];
                break;
            }
            if ([food.foodType isEqualToString:@"fish"] && [currentAnimal.animalType isEqualToString:@"penguin"]) {
                self.score++;
                
                //play a sound effect
                [scoreAudio playEffect:@"bite.mp3"];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                //remove food when they collide with animal
                [food removeFromParent];
                [tempfoodRemovearray addObject:food];
                break;
            }
            if ([food.foodType isEqualToString:@"nut"] && [currentAnimal.animalType isEqualToString:@"squirrel"]) {
                self.score++;
                
                //play a sound effect
                [scoreAudio playEffect:@"bite.mp3"];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

                //remove food when they collide with animal
                [food removeFromParent];
                [tempfoodRemovearray addObject:food];
                break;
            }
            else {
                //remove food when they collide with animal
                [food removeFromParent];
                [tempfoodRemovearray addObject:food];
                [self lose];
                return;
            }
        }
    }
    for (food* food in tempfoodRemovearray) {
        [foodarray removeObject:food];
    }
    
    // check collision between food and bonus
    for (food* food in foodarray) {
        if (CGRectIntersectsRect(food.boundingBox, currentStar.boundingBox)) {
            sosScore++;
            [bonusAudio playEffect:@"starAudio.mp3"];
            _sosScoreLabel.string = [NSString stringWithFormat:@"%d", sosScore];
            [currentStar removeFromParent];
            currentStar = nil;
        }
    }
    
    // check collision between food and bonusAnimals
    NSMutableArray *tempbonusFoodRemovearray = [NSMutableArray array];
    for (animal* animal in bonusAnimalsarray) {
    for (food* food in foodarray) {
        if (CGRectIntersectsRect(food.boundingBox, animal.boundingBox)) {
            if ([food.foodType isEqualToString:@"banana"] && [animal.animalType isEqualToString:@"monkey"]) {
                self.score++;
                //play a sound effect
                [scoreAudio playEffect:@"bite.mp3"];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                //remove food when they collide with animal
                [food removeFromParent];
                [tempbonusFoodRemovearray addObject:food];
                break;
            }
            if ([food.foodType isEqualToString:@"fish"] && [animal.animalType isEqualToString:@"penguin"]) {
                self.score++;
                
                //play a sound effect
                [scoreAudio playEffect:@"bite.mp3"];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                //remove food when they collide with animal
                [food removeFromParent];
                [tempbonusFoodRemovearray addObject:food];
                break;
            }
            if ([food.foodType isEqualToString:@"nut"] && [animal.animalType isEqualToString:@"squirrel"]) {
                self.score++;
                
                //play a sound effect
                [scoreAudio playEffect:@"bite.mp3"];
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                //remove food when they collide with animal
                [food removeFromParent];
                [tempbonusFoodRemovearray addObject:food];
                break;
            }
            else {
                //remove food when they collide with animal
                [food removeFromParent];
                [tempbonusFoodRemovearray addObject:food];
                [self lose];
                return;
            }
        }
    }
    }
    for (food* food in tempbonusFoodRemovearray) {
        [foodarray removeObject:food];
    }
}

-(void)launchBonusAnimals{
    bonusAnimal_1 = (animal*)[CCBReader load:@"monkey"];
    bonusAnimal_1.animalType = @"monkey";
    bonusAnimal_1.scale = 0.8;
    bonusAnimal_1.position = ccpSub(animalPosition1, ccp(50, 0));
    [self addChild:bonusAnimal_1];
    [bonusAnimalsarray addObject:bonusAnimal_1];

    bonusAnimal_2 = (animal*)[CCBReader load:@"penguin"];
    bonusAnimal_2.animalType = @"penguin";
    bonusAnimal_2.scale = 3;
    bonusAnimal_2.position = ccpSub(animalPosition2, ccp(50, 0));;
    [self addChild:bonusAnimal_2];
    [bonusAnimalsarray addObject:bonusAnimal_2];
    
    bonusAnimal_3 = (animal*)[CCBReader load:@"squirrel"];
    bonusAnimal_3.animalType = @"squirrel";
    bonusAnimal_3.scale = 0.9;
    bonusAnimal_3.position = ccpSub(animalPosition3, ccp(50, 0));;
    [self addChild:bonusAnimal_3];
    [bonusAnimalsarray addObject:bonusAnimal_3];
}

- (void)SOS{
    if (!pauseEnabel) {
        [noStar removeFromParent];
        [countDown removeFromParent];
        if (sosScore > 0) {
            // clean previous stuff
            for (animal* animal in bonusAnimalsarray) {
                [animal removeFromParent];
            }
            [bonusAnimalsarray removeAllObjects];
            
            //launch bonusAnimals
            [self schedule:@selector(launchAnimal) interval:launchAnimalTime].paused = YES;
            [currentAnimal removeFromParent];
            [self launchBonusAnimals];
            [self scheduleOnce:@selector(recoverToNoramlModel) delay:10.f];
            
            // add a countDown
            countDown = [CCBReader load:@"countDown"];
            [self addChild:countDown];
            countDown.position = ccp(0.5*screenWidth, 250);
            countDown.scale = 0.5;
            // update score
            sosScore --;
            _sosScoreLabel.string = [NSString stringWithFormat:@"%d", sosScore];
        }
        else if (sosScore == 0){
            // print a warning label
            noStar = [CCBReader load:@"noStar"];
            [self addChild:noStar];
            noStar.position = ccp(0.5*screenWidth, 250);
            [self scheduleOnce:@selector(removeNoStar) delay:.8f];
        }
    }
}

-(void)removeNoStar{
    [noStar removeFromParent];
}

-(void)recoverToNoramlModel{
    [self launchAnimal];
    [self schedule:@selector(launchAnimal) interval:launchAnimalTime].paused = NO;
    [countDown removeFromParent];
    for (animal* animal in bonusAnimalsarray) {
        [animal removeFromParent];
    }
    [bonusAnimalsarray removeAllObjects];
}

// update score and increase difficulty
-(void)setScore:(int)score{
    _score = score;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    
    // update highScore
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    if (_score > highScore) {
        // new highscore!
        highScore = _score;
        [[NSUserDefaults standardUserDefaults] setInteger:highScore forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    goodWords.string = @"";
    if (_score == 1) {
        goodWords.string = @"First  Try !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
    }
    if (_score == 3) {
        goodWords.string = @"Good  Job !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
        [self launchbadGuy];
//        // manually create & apply a force to every badGuy
//        for (CCNode *badGuy in badGuysarray) {
//            CGFloat randomX = arc4random_uniform(midField.contentSize.width/2 - 10) + midField.positionInPoints.x +10;
//            CGFloat randomY = arc4random_uniform(midField.contentSize.height - 40) + 10;
//            CGPoint launchDirection = ccp(randomX, randomY);
//            CGPoint force = ccpMult(launchDirection, 300);
//            [badGuy.physicsBody applyForce:force];
//            [badGuy.physicsBody applyForce:ccp(20000,20000)];
//        }
    }
    if (_score == 6) {
        goodWords.string = @"Fighting !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
    }
    if (_score == 10) {
        goodWords.string = @"Great  Job !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
        [self launchbadGuy];
    }
    if (_score == 15) {
        goodWords.string = @"So  Good !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
    }
    if (_score == 20) {
        goodWords.string = @"Unbelievable !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
        // manually create & apply a force to every badGuy
        for (CCNode *badGuy in badGuysarray) {
            [badGuy.physicsBody applyForce:ccp(20000,20000)];
        }
//        foodSpeed = 70;
    }
    if (_score == 30) {
        goodWords.string = @"Excellent  Player !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
        [self launchbadGuy];
//        // manually create & apply a force to every badGuy
//        for (CCNode *badGuy in badGuysarray) {
//            CGFloat randomX = arc4random_uniform(midField.contentSize.width/2 - 10) + midField.positionInPoints.x +10;
//            CGFloat randomY = arc4random_uniform(midField.contentSize.height - 40) + 10;
//            CGPoint launchDirection = ccp(randomX, randomY);
//            CGPoint force = ccpMult(launchDirection, 300);
//            [badGuy.physicsBody applyForce:force];
//        }
    }
    if (_score == 50) {
        goodWords.string = @"You  Must  Be  Kidding !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
//        foodSpeed = 80;
        // manually create & apply a force to every badGuy
        for (CCNode *badGuy in badGuysarray) {
            [badGuy.physicsBody applyForce:ccp(20000,20000)];
        }
    }
    if (_score == 100) {
        goodWords.string = @"You  Are  The  Best !";
        [self scheduleOnce:@selector(clearWords) delay:1.5];
        [self launchbadGuy];
//        // manually create & apply a force to every badGuy
//        for (CCNode *badGuy in badGuysarray) {
//            CGFloat randomX = arc4random_uniform(midField.contentSize.width/2 - 10) + midField.positionInPoints.x +10;
//            CGFloat randomY = arc4random_uniform(midField.contentSize.height - 40) + 10;
//            CGPoint launchDirection = ccp(randomX, randomY);
//            CGPoint force = ccpMult(launchDirection, 300);
//            [badGuy.physicsBody applyForce:force];
//            }
        }
        if (_score == 150) {
            goodWords.string = @"Are  You  Crazy ?";
            [self scheduleOnce:@selector(clearWords) delay:1.5];
            [self launchbadGuy];
            // manually create & apply a force to every badGuy
            for (CCNode *badGuy in badGuysarray) {
                [badGuy.physicsBody applyForce:ccp(20000,20000)];
            }
        }
        if (_score == 200) {
            goodWords.string = @"Are  You  From  Star ?";
            [self scheduleOnce:@selector(clearWords) delay:1.5];
            [self launchbadGuy];
            // manually create & apply a force to every badGuy
            for (CCNode *badGuy in badGuysarray) {
                [badGuy.physicsBody applyForce:ccp(20000,20000)];
            }
        }
}

-(void)clearWords{
    goodWords.string = @"";
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
      if ([keyPath isEqualToString:@"highscore"]) {
        [self updateHighscore];
      }
}

// removeObserver when they are not in used
- (void)dealloc {
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"highscore"];
}

- (void)updateHighscore {
    NSInteger newHighscore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
    if (newHighscore) {
        _highscoreLabel.string = [NSString stringWithFormat:@"%ld", (long)newHighscore];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    // we want to know the location of our touch in this scene
    CGPoint touchLocation = [touch locationInNode:topField];
    if (CGRectContainsPoint(pauseButton.boundingBox, touchLocation)) {
        if (!playButton.visible) {
            self.paused = YES;
            for (food* food in foodarray) {
                food.userInteractionEnabled = NO;
            }
            backgroundAudio.paused = YES;
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            pauseEnabel = YES;
            playButton.visible = YES;
            pauseEnabel = YES;
            
            //add popMenu
            popmenu = (popMenu *)[CCBReader load:@"popMenu"];
            popmenu.positionType = CCPositionTypeNormalized;
            popmenu.position = ccp(0.5, 0.5);
            popmenu.zOrder = INT_MAX;
            [self addChild:popmenu];
            return;
        }
        if (playButton.visible) {
            self.paused = NO;
            for (food* food in foodarray) {
                food.userInteractionEnabled = YES;
            }
            backgroundAudio.paused = NO;
            playButton.visible = NO;
            pauseEnabel = NO;
            //remove popMenu
            [popmenu removeFromParent];
            return;
        }
    }
}

-(void)lose {
    for (food* food in foodarray) {
        food.userInteractionEnabled = NO;
    }
    self.paused = YES;
    //play a gameOver sound effect
    [scoreAudio playEffect:@"gameover.wav"];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [backgroundAudio stopBg];
    GameEnd *gameEndPopover = (GameEnd *)[CCBReader load:@"GameEnd"];
    gameEndPopover.positionType = CCPositionTypeNormalized;
    gameEndPopover.position = ccp(0.45, 0.498);
    gameEndPopover.zOrder = INT_MAX;
    [self addChild:gameEndPopover];
}
@end