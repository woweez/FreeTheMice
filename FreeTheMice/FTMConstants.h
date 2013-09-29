//
//  FTMConstants.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 24/09/2013.
//
//
//get ptm ratio
#define isIPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
//#define PTM_RATIO (isIPad ? 64 : 32)
#define DEVICESCALE (isIPad ? 2 : 1)

//convenience measurements
#define SCREEN [[CCDirector sharedDirector] winSize]
#define CURTIME CACurrentMediaTime()

//convenience functions
#define random_range(low,high) (arc4random()%(high-low+1))+low
#define frandom (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low


#ifndef FreeTheMice_FTMConstants_h
#define FreeTheMice_FTMConstants_h

#define FTM_MAMA_MICE_ID     1
#define FTM_STRONG_MICE_ID   2
#define FTM_GIRL_MICE_ID     3

#define DOT_PLIST               @".plist"
#define DOT_PNG                 @".png"
#define DOT_PNG_WITH_INDEX      @"%d.png"

#define MAGNIFIER_ITEM_ID       1
#define SLOWDOWN_TIME_ITEM_ID   2
#define BOOTS_ITEM_ID           3
#define SPEEDUP_ITEM_ID         4
#define SPECIAL_CHEESE_ITEM_ID  5
#define MASTER_KEY_ITEM_ID      6
#define BARKING_DOG_ITEM_ID     7
//                                  THESE ARE MAMA MOUSE SETTINGS.


#define MAMA_SHOCK_ANIM     1
#define MAMA_WATER_ANIM     2
#define MAMA_FLAME_ANIM     3
#define MAMA_KNIFE_ANIM     4

//              NO COSTUME
#define MAMA_KNIFE_ANIM_PATH                    @"mama_knives_animation"
#define MAMA_KNIFE_ANIM_FRAME_PATH              @"mm_knives_hit_"
#define MAMA_WATER_ANIM_PATH                    @"mama_water_animation"
#define MAMA_WATER_ANIM_FRAME_PATH              @"mm_water_"
#define MAMA_FLAME_ANIM_PATH                    @"mama_flame_animation"
#define MAMA_FLAME_ANIM_FRAME_PATH              @"mm_flame_"
#define MAMA_SHOCK_ANIM_PATH                    @"mama_shock_animation"
#define MAMA_SHOCK_ANIM_FRAME_PATH              @"mm_shock_"

//                                 THESE ARE STRONG/MUSSLE MOUSE SETTINGS.


#define STRONG_SHOCK_ANIM     1
#define STRONG_WATER_ANIM     2
#define STRONG_FLAME_ANIM     3
#define STRONG_KNIFE_ANIM     4

//              NO COSTUME
#define STRONG_KNIFE_ANIM_PATH                  @"strong0_knife_anim"
#define STRONG_KNIFE_ANIM_FRAME_PATH            @"sm0_knives_hit_"
#define STRONG_WATER_ANIM_PATH                  @"strong0_water_anim"
#define STRONG_WATER_ANIM_FRAME_PATH            @"sm0_water_"
#define STRONG_FLAME_ANIM_PATH                  @"strong0_flame0_anim"
#define STRONG_FLAME_ANIM_FRAME_PATH            @"sm0_flame_"
#define STRONG_SHOCK_ANIM_PATH                  @"strong0_shock_anim"
#define STRONG_SHOCK_ANIM_FRAME_PATH            @"sm0_shock_"

//                                  THESE ARE GIRL MOUSE SETTINGS.


#define GIRL_SHOCK_ANIM     1
#define GIRL_WATER_ANIM     2
#define GIRL_FLAME_ANIM     3
#define GIRL_KNIFE_ANIM     4

//              NO COSTUME
#define GIRL_KNIFE_ANIM_PATH                    @"girl0_knife_anim"
#define GIRL_KNIFE_ANIM_FRAME_PATH              @"gm0_knives_hit_"
#define GIRL_WATER_ANIM_PATH                    @"girl0_water_anim"
#define GIRL_WATER_ANIM_FRAME_PATH              @"gm0_water_"
#define GIRL_FLAME_ANIM_PATH                    @"girl0_flame_anim"
#define GIRL_FLAME_ANIM_FRAME_PATH              @"gm0_flame_"
#define GIRL_SHOCK_ANIM_PATH                    @"girl0_shock_anim"
#define GIRL_SHOCK_ANIM_FRAME_PATH              @"gm0_shock_"

#endif
