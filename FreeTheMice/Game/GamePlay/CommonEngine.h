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
    BOOL forwardChe;
    BOOL mouseWinChe;
    BOOL heroTrappedChe;
    CCSpriteFrameCache *cache;
    HudLayer *hudLayer;
    int gameMinutes;
    
    }

-(void)addAnimation:(NSString *) plistName noOfFrames:(int) frames startingFrameName:(NSString *) startFrame;
-(void)showAnimationWithMiceIdAndIndex:(int)miceId andAnimationIndex:(int) animIndex;

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
