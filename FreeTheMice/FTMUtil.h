//
//  FTMUtil.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/23/13.
//
//

#import <Foundation/Foundation.h>

@interface FTMUtil : NSObject
{
}

@property (readwrite) int mouseClicked;
@property (readwrite) BOOL isIphone5;
@property (readwrite) BOOL isSlowDownTimer;
@property (readwrite) BOOL isRespawnMice;

+ (FTMUtil*) sharedInstance;
- (NSString *)getModel;
@end
