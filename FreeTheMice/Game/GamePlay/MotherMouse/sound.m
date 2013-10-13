//
//  sound.m
//  Racing
//
//  Created by karthik gopal on 28/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "sound.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"
#import "FTMConstants.h"
@implementation sound
-(void)initSound{
    
    [[SimpleAudioEngine sharedEngine] preloadEffect: BLOCKS_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BOXES_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BULD_SWAYING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_1];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_2];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_ACTIVATE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: BUTTON_DEACTIVATE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CAT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_1];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_2];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_3];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CHEESE_ALL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: CORRECT_SWITCH];
    [[SimpleAudioEngine sharedEngine] preloadEffect: DOOR_CLOSE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: ELECTRICITY];
    [[SimpleAudioEngine sharedEngine] preloadEffect: EXTINGUISH_POT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: FLOODING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: FREEZING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: FRIDGE_MOTOR_LOOP];
    [[SimpleAudioEngine sharedEngine] preloadEffect: HOT_POT_SMOKE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: ICE_CUBES_APPEAR];
    [[SimpleAudioEngine sharedEngine] preloadEffect: ICE_CUBES_FALL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: KNIFE_TRAY];
    [[SimpleAudioEngine sharedEngine] preloadEffect: LAMP_HIT_AWAY];
    [[SimpleAudioEngine sharedEngine] preloadEffect: MILK_CARTOON];
    [[SimpleAudioEngine sharedEngine] preloadEffect: PLATES_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: POT_HITTING_GROUND];
    [[SimpleAudioEngine sharedEngine] preloadEffect: PUSHING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: SHELF_MOVING];
    [[SimpleAudioEngine sharedEngine] preloadEffect: SPIL_MILK];
    [[SimpleAudioEngine sharedEngine] preloadEffect: STOVE_NORMAL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: STOVE_VIOLANT];
    [[SimpleAudioEngine sharedEngine] preloadEffect: TIMER];
    [[SimpleAudioEngine sharedEngine] preloadEffect: TIMER_ALL];
    [[SimpleAudioEngine sharedEngine] preloadEffect: TRAY_OPEN_CLOSE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: VENT_MIST];
    [[SimpleAudioEngine sharedEngine] preloadEffect: WATER_FALLING_FROM_VASE];
    [[SimpleAudioEngine sharedEngine] preloadEffect: WATER_SINK_SPLASH];

}
-(void)cheeseCollectedSound{
//    [[SimpleAudioEngine sharedEngine] playEffect:@"squeak.caf"];
//    [[SimpleAudioEngine sharedEngine] playEffect:@"chime.caf"];

}

-(void) dealloc {
	[super dealloc];
}
@end
