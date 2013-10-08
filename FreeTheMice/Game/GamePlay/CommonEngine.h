//
// CommonEngine.mm
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/23/13.
//
//


#import <GameKit/GameKit.h>


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "AppDelegate.h"
#import "HudLayer.h"

@interface CommonEngine : CCLayer {
    
    CCSprite *heroRunSprite;
    CCSprite *heroSprite;
    CCSpriteBatchNode *spriteSheet;
    CCSprite *trappingAnimationSprite;
    BOOL forwardChe;
    BOOL mouseWinChe;
    BOOL isScheduledTime;
    BOOL heroTrappedChe;
    BOOL landingChe;
    BOOL runningChe;
    BOOL heroJumpLocationChe;
    BOOL firstRunningChe;
    BOOL safetyJumpChe;
    BOOL heroJumpRunningChe;
    BOOL jumpingChe;
    int miceTrapAnimationType;
    int currentAnim;
    CCSpriteFrameCache *cache;
    HudLayer *hudLayer;
    CGFloat platformX,platformY;
    int elapsedSeconds;
    
    }

-(void)addAnimation:(NSString *) plistName noOfFrames:(int) frames startingFrameName:(NSString *) startFrame;
-(void)updateAnimationOnCurrentType:(int)frameToLoad animationType:(NSString *)type;
-(void)showAnimationWithMiceIdAndIndex:(int)miceId andAnimationIndex:(int) animIndex;
-(CCSprite *) getTrappingAnimatedSprite;
-(void)progressBarFunc;


//-(void)playMamaKniveHitAnimation;
//-(void)playStrongKniveHitAnimation;
//-(void)playGirlKniveHitAnimation;
//
//-(void)playMamaWaterHitAnimation;
//-(void)playStrongWaterHitAnimation;
//-(void)playGirlWaterHitAnimation;
//
//-(void)playMamaShockHitAnimation;
//-(void)playStrongShockHitAnimation;
//-(void)playGirlShockHitAnimation;
//
//-(void)playMamaMistHitAnimation;
//-(void)playStrongMistHitAnimation;
//-(void)playGirlMistHitAnimation;

@end
