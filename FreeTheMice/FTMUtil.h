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
+ (FTMUtil*) sharedInstance;
- (NSString *)getModel;
@end
