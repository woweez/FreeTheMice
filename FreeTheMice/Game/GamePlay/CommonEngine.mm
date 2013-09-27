//
//  CommonEngine.mm
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/23/13.
//
//

#import "CommonEngine.h"
#import "AppDelegate.h"
#import "LevelScreen.h"
#import "FTMConstants.h"
#import "DB.h"
#import "HudLayer.h"

@implementation CommonEngine

-(id) init
{
    if( (self=[super init])) {
        
    }
    return self;
}

-(void) showAnimationWithMiceIdAndIndex:(int)catId andAnimationIndex:(int)animIndex{
    
    switch (catId) {
        case FTM_MAMA_MICE_ID:
            [self showTrappingAnimationForMama:animIndex];
            break;
        case FTM_STRONG_MICE_ID:
            [self showTrappingAnimationForStrong:animIndex];
            break;
        case FTM_GIRL_MICE_ID:
            [self showTrappingAnimationForGirl:animIndex];
            break;
            
        default:
            break;
    }
}

-(void) showTrappingAnimationForMama: (int) animIndex{
    switch (animIndex) {
        case MAMA_FLAME_ANIM:
            [self playMamaFlameHitAnimation];
            break;
        case MAMA_KNIFE_ANIM:
            [self playMamaKniveHitAnimation];
            break;
        case MAMA_SHOCK_ANIM:
            [self playMamaShockHitAnimation];
            break;
        case MAMA_WATER_ANIM:
            [self playMamaWaterHitAnimation];
            break;
            
            
        default:
            break;
    }
}
-(void) showTrappingAnimationForGirl: (int) animIndex{
    switch (animIndex) {
        case GIRL_FLAME_ANIM:
            
            break;
        case GIRL_KNIFE_ANIM:
            [self playGirlKniveHitAnimation];
            break;
        case GIRL_SHOCK_ANIM:
            [self playGirlShockHitAnimation];
            break;
        case GIRL_WATER_ANIM:
            [self playGirlWaterHitAnimation];
            break;
        default:
            break;
    }
}
-(void) showTrappingAnimationForStrong: (int) animIndex{
    switch (animIndex) {
        case STRONG_FLAME_ANIM:
            
            break;
        case STRONG_KNIFE_ANIM:
            [self playStrongKniveHitAnimation];
            break;
        case STRONG_SHOCK_ANIM:
            [self playStrongShockHitAnimation];
            break;
        case STRONG_WATER_ANIM:
            [self playStrongWaterHitAnimation];
            break;
        default:
            break;
    }
}
-(void) playMamaKniveHitAnimation{
    
    [self addAnimation:MAMA_KNIFE_ANIM_PATH andNoOfFrames:23 andStartingFrameName:MAMA_KNIFE_ANIM_FRAME_PATH];
}
-(void)playStrongKniveHitAnimation{
    [self addAnimation:STRONG_KNIFE_ANIM_PATH andNoOfFrames:23 andStartingFrameName:STRONG_KNIFE_ANIM_FRAME_PATH];
}

-(void)playGirlKniveHitAnimation{
    [self addAnimation:GIRL_KNIFE_ANIM_PATH andNoOfFrames:23 andStartingFrameName:GIRL_KNIFE_ANIM_FRAME_PATH];
}


-(void)playMamaWaterHitAnimation{
    [self addAnimation:MAMA_WATER_ANIM_PATH andNoOfFrames:14 andStartingFrameName:MAMA_WATER_ANIM_FRAME_PATH];
}

-(void)playStrongWaterHitAnimation{
    [self addAnimation:STRONG_WATER_ANIM_PATH andNoOfFrames:14 andStartingFrameName:STRONG_WATER_ANIM_FRAME_PATH];
}

-(void)playGirlWaterHitAnimation{
    [self addAnimation:GIRL_WATER_ANIM_PATH andNoOfFrames:14 andStartingFrameName:GIRL_WATER_ANIM_FRAME_PATH];
}


-(void)playMamaShockHitAnimation{
    [self addAnimation:MAMA_SHOCK_ANIM_PATH andNoOfFrames:15 andStartingFrameName:MAMA_SHOCK_ANIM_FRAME_PATH];
}

-(void)playStrongShockHitAnimation{
    [self addAnimation:STRONG_SHOCK_ANIM_PATH andNoOfFrames:15 andStartingFrameName:STRONG_SHOCK_ANIM_FRAME_PATH];
}

-(void)playGirlShockHitAnimation{
    [self addAnimation:GIRL_SHOCK_ANIM_PATH andNoOfFrames:15 andStartingFrameName:GIRL_SHOCK_ANIM_FRAME_PATH];
}


-(void)playMamaMistHitAnimation{
    
}

-(void)playStrongMistHitAnimation{
    
}

-(void)playGirlMistHitAnimation{
    
}

-(void)playMamaFlameHitAnimation{
    [self addAnimation:MAMA_FLAME_ANIM_PATH andNoOfFrames:29 andStartingFrameName:MAMA_FLAME_ANIM_FRAME_PATH];
}

-(void)playStrongFlameHitAnimation{
    [self addAnimation:STRONG_FLAME_ANIM_PATH andNoOfFrames:29 andStartingFrameName:STRONG_FLAME_ANIM_FRAME_PATH];
}

-(void)playGirlFlameHitAnimation{
    [self addAnimation:GIRL_FLAME_ANIM_PATH andNoOfFrames:29 andStartingFrameName:GIRL_FLAME_ANIM_FRAME_PATH];
}


-(void) addAnimation:(NSString *)plistName andNoOfFrames:(int)frames andStartingFrameName:(NSString *)startFrame{

    [cache addSpriteFramesWithFile:[plistName stringByAppendingString:DOT_PLIST]];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[plistName stringByAppendingString:DOT_PNG]];
    [self addChild:spriteSheet z:10];
    
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= frames; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:[startFrame stringByAppendingString:DOT_PNG_WITH_INDEX],i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *knockedOutAnimation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.03f];
    
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:[startFrame stringByAppendingString:DOT_PNG_WITH_INDEX], 0]];
    if(!forwardChe){
        sprite.position = ccp(heroSprite.position.x+heroSprite.contentSize.width/4, heroSprite.position.y -heroSprite.contentSize.height/3);
    }else{
        sprite.position = ccp(heroSprite.position.x-heroSprite.contentSize.width/4, heroSprite.position.y -heroSprite.contentSize.height/3);
    }
    sprite.scale=0.5;
    [spriteSheet addChild:sprite];
    
    CCAnimate *actionOne = [CCAnimate actionWithAnimation:knockedOutAnimation];
    [sprite runAction:[CCRepeatForever actionWithAction:actionOne ]];

}

-(void)progressBarFunc{
    gameMinutes+=1;
    int bValue = 120 - (gameMinutes/60);
    if(bValue>=0){
        if((gameMinutes%60)==0){
            int lMin=0;
            int lSec=0;
            lMin=(bValue>60?1:0);
            lSec=(bValue>60?bValue-60:bValue);
            if(!mouseWinChe){
                [hudLayer updateTimeRemaining:lMin andTimeInSec:lSec];
                if(lMin == 0 && lSec == 0){
                    [hudLayer showRetryOptionMenu];
                    self.isTouchEnabled = NO;
                }
            }
        }
    }
}

@end
