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
#import "FTMUtil.h"

@implementation CommonEngine

-(id) init
{
    if( (self=[super init])) {
        [FTMUtil sharedInstance].isSlowDownTimer = NO;
        [FTMUtil sharedInstance].isRespawnMice = NO;
    }
    return self;
}

-(void) showAnimationWithMiceIdAndIndex:(int)miceId andAnimationIndex:(int)animIndex{
    
    switch (miceId) {
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

-(CCSprite *) getTrappingAnimatedSprite{
    return trappingAnimationSprite;
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
            [self playGirlFlameHitAnimation];
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
            [self playGirlFlameHitAnimation];
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
    
    [self addAnimation:MAMA_KNIFE_ANIM_PATH noOfFrames:23 startingFrameName:MAMA_KNIFE_ANIM_FRAME_PATH];
}
-(void)playStrongKniveHitAnimation{
    [self addAnimation:STRONG_KNIFE_ANIM_PATH noOfFrames:23 startingFrameName:STRONG_KNIFE_ANIM_FRAME_PATH];
}

-(void)playGirlKniveHitAnimation{
    [self addAnimation:GIRL_KNIFE_ANIM_PATH noOfFrames:23 startingFrameName:GIRL_KNIFE_ANIM_FRAME_PATH];
}


-(void)playMamaWaterHitAnimation{
    [self addAnimation:MAMA_WATER_ANIM_PATH noOfFrames:14 startingFrameName:MAMA_WATER_ANIM_FRAME_PATH];
}

-(void)playStrongWaterHitAnimation{
    [self addAnimation:STRONG_WATER_ANIM_PATH noOfFrames:14 startingFrameName:STRONG_WATER_ANIM_FRAME_PATH];
}

-(void)playGirlWaterHitAnimation{
    [self addAnimation:GIRL_WATER_ANIM_PATH noOfFrames:14 startingFrameName:GIRL_WATER_ANIM_FRAME_PATH];
}


-(void)playMamaShockHitAnimation{
    [self addAnimation:MAMA_SHOCK_ANIM_PATH noOfFrames:15 startingFrameName:MAMA_SHOCK_ANIM_FRAME_PATH];
}

-(void)playStrongShockHitAnimation{
    [self addAnimation:STRONG_SHOCK_ANIM_PATH noOfFrames:15 startingFrameName:STRONG_SHOCK_ANIM_FRAME_PATH];
}

-(void)playGirlShockHitAnimation{
    [self addAnimation:GIRL_SHOCK_ANIM_PATH noOfFrames:15 startingFrameName:GIRL_SHOCK_ANIM_FRAME_PATH];
}


-(void)playMamaMistHitAnimation{
    
}

-(void)playStrongMistHitAnimation{
    
}

-(void)playGirlMistHitAnimation{
    
}

-(void)playMamaFlameHitAnimation{
    [self addAnimation:MAMA_FLAME_ANIM_PATH noOfFrames:29 startingFrameName:MAMA_FLAME_ANIM_FRAME_PATH];
}

-(void)playStrongFlameHitAnimation{
    [self addAnimation:STRONG_FLAME_ANIM_PATH noOfFrames:29 startingFrameName:STRONG_FLAME_ANIM_FRAME_PATH];
}

-(void)playGirlFlameHitAnimation{
    [self addAnimation:GIRL_FLAME_ANIM_PATH noOfFrames:29 startingFrameName:GIRL_FLAME_ANIM_FRAME_PATH];
}


-(void) addAnimation:(NSString *)plistName noOfFrames:(int)frames startingFrameName:(NSString *)startFrame{

    [cache addSpriteFramesWithFile:[plistName stringByAppendingString:DOT_PLIST]];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:[plistName stringByAppendingString:DOT_PNG]];
    [self addChild:spriteSheet z:10];
    
    NSMutableArray *animationFramesArr = [NSMutableArray array];
    for(int i = 0; i <= frames; i++) {
        CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:[startFrame stringByAppendingString:DOT_PNG_WITH_INDEX],i]];
        [animationFramesArr addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animationFramesArr delay:0.03f];
    
    trappingAnimationSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:[startFrame stringByAppendingString:DOT_PNG_WITH_INDEX], 0]];
    if(!forwardChe){
        trappingAnimationSprite.position = ccp(heroSprite.position.x+heroSprite.contentSize.width/4, heroSprite.position.y -heroSprite.contentSize.height/3);
    }else{
        trappingAnimationSprite.position = ccp(heroSprite.position.x-heroSprite.contentSize.width/4, heroSprite.position.y -heroSprite.contentSize.height/3);
    }
    trappingAnimationSprite.scale=0.5;
    [spriteSheet addChild:trappingAnimationSprite];
    
    CCAnimate *actionOne = [CCAnimate actionWithAnimation:animation];
    [trappingAnimationSprite runAction:[CCRepeatForever actionWithAction:actionOne ]];

}

-(void)progressBarFunc{
    if(isScheduledTime){
        return;
    }
    isScheduledTime = YES;
    [self schedule:@selector(startTheHudLayerTimer) interval:1];
}

-(void) startTheHudLayerTimer{
    elapsedSeconds += 1;
    
    if ([FTMUtil sharedInstance].isSlowDownTimer) {
        [self unschedule:@selector(startTheHudLayerTimer)];
        [FTMUtil sharedInstance].isSlowDownTimer = NO;
        [self schedule:@selector(startTheHudLayerTimer) interval:2];
        
    }
    
    int totalTimeInSec = 120;
    int oneMinInSec = 60;
    int remainigTimeInSec = totalTimeInSec - elapsedSeconds;
    int mins = remainigTimeInSec > oneMinInSec? 1:0;
    int seconnds = remainigTimeInSec>oneMinInSec?remainigTimeInSec-oneMinInSec:remainigTimeInSec;
    
    if(!mouseWinChe){
           [hudLayer updateTimeRemaining:mins andTimeInSec:seconnds];
        }
    if(remainigTimeInSec <= 0){
        [self stopTheHudLayerTimer];
    }
}

-(void) stopTheHudLayerTimer{
    
    [self unschedule:@selector(startTheHudLayerTimer)];
    // do after timer stuff here...
}



@end
