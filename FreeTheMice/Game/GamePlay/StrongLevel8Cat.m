//
//  StrongLevel8Cat.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 10/16/13.
//
//

#import "StrongLevel8Cat.h"

@implementation StrongLevel8Cat

- (id)init
{
    self = [super init];
    if (self) {
        catYPos = 595;
        moveXend = 810;
        moveXstart = 780;
    }
    return self;
}


-(void) runCurrentSequence{
    
    catSprite.position = ccp(moveXstart, catYPos);
    catSprite.flipX = 0;
    CCMoveTo *rightMove = [self getMoveRightAction:CGPointMake(moveXstart, catYPos) endPoint:CGPointMake(moveXend, catYPos)];
    CCMoveTo *leftMove = [self getMoveRightAction:CGPointMake(moveXend, catYPos) endPoint:CGPointMake(moveXstart, catYPos)];
    CCCallFuncN *flip1 = [CCCallFuncN actionWithTarget:self selector:@selector(flipLeft:)];

    CCAnimate *startJump = [self getStartJumpAction];
    CCSpawn *firstJump = [self getFirstJumpAction:CGPointMake(710, 605)];
    CCSpawn *secondJump = [self getSecongJumpAction:CGPointMake(670, 520)];
    CCMoveTo *rightMove1 = [self getMoveRightAction:CGPointMake(670, 520) endPoint:CGPointMake(720, 520)];
    
    
    CCSpawn *firstJump1 = [self getFirstJumpAction:CGPointMake(860, 500)];
    CCSpawn *secondJump1 = [self getSecongJumpAction:CGPointMake(910, 430)];
    CCMoveTo *rightMove2 = [self getMoveRightAction:CGPointMake(910, 430) endPoint:CGPointMake(960, 430)];
    CCMoveTo *leftMove1 = [self getMoveLeftAction:CGPointMake(960, 430) endPoint:CGPointMake(910, 430)];
    
    
    CCSpawn *firstJump2 = [self getFirstJumpAction:CGPointMake(800, 440)];
    CCSpawn *secondJump2 = [self getSecongJumpAction:CGPointMake(670, 280)];
    CCMoveTo *leftMove2 = [self getMoveRightAction:CGPointMake(670, 280) endPoint:CGPointMake(575, 280)];
    CCMoveTo *rightMove3 = [self getMoveLeftAction:CGPointMake(575, 280) endPoint:CGPointMake(670, 280)];
    
    CCSpawn *firstJump3 = [self getFirstJumpAction:CGPointMake(780, 440)];
    CCSpawn *secondJump3 = [self getSecongJumpAction:CGPointMake(910, 430)];
    
    CCSpawn *firstJump4 = [self getFirstJumpAction:CGPointMake(800, 530)];
    CCSpawn *secondJump4 = [self getSecongJumpAction:CGPointMake(720, 520)];
    CCMoveTo *leftMove3 = [self getMoveRightAction:CGPointMake(720, 520) endPoint:CGPointMake(670, 520)];
    
    CCSpawn *firstJump5 = [self getFirstJumpAction:CGPointMake(760, 600)];
    CCSpawn *secondJump5 = [self getSecongJumpAction:CGPointMake(780, 595)];
    
    CCCallFuncN *flip2 = [CCCallFuncN actionWithTarget:self selector:@selector(flipRight:)];
    CCAnimate *turn = [self getTurningAction];
    CCCallFuncN *afterMoveLeftOrRight = [CCCallFuncN actionWithTarget:self selector:@selector(afterLeft:)];
    
    CCSequence *sequence = [CCSequence actions:
                            rightMove, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove, afterMoveLeftOrRight,
                            startJump,firstJump,secondJump,
                            turn, flip2,
                            rightMove1, afterMoveLeftOrRight,
                            startJump,firstJump1,secondJump1,
                            flip2,rightMove2, afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove1,afterMoveLeftOrRight,
                            startJump,firstJump2,secondJump2,
                            flip1, leftMove2, afterMoveLeftOrRight,
                            turn, flip2,
                            rightMove3,afterMoveLeftOrRight,
                            startJump,firstJump3,secondJump3,
                            flip2,rightMove2,afterMoveLeftOrRight,
                            turn,flip1,
                            leftMove1, afterMoveLeftOrRight,
                            startJump,firstJump4,secondJump4,
                            flip1, leftMove3,afterMoveLeftOrRight,
                            turn,flip2, afterMoveLeftOrRight,
                            startJump, firstJump5,secondJump5,
                            flip2,   nil];
    
    sequence.tag = 15;
    [catSprite runAction:[CCRepeatForever actionWithAction: sequence]];
    [self applyRunningAnimation];
}

@end
