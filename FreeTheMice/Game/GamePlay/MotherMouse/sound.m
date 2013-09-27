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

@implementation sound
-(void)initSound{
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"squeak.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"chime.caf"];
}
-(void)cheeseCollectedSound{
//    [[SimpleAudioEngine sharedEngine] playEffect:@"squeak.caf"];
//    [[SimpleAudioEngine sharedEngine] playEffect:@"chime.caf"];

}

-(void) dealloc {
	[super dealloc];
}
@end
