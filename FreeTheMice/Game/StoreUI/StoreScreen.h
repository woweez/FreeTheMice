//
//  StoreScreen.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 30/09/2013.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "SWScrollView.h"
@interface StoreScreen : CCLayer{
    
    float scaleFactorX;
    float scaleFactorY;
    CCLabelAtlas *totalCheese;
}
+(CCScene *) scene;
- (void)updateStoreAboutPurchased :(NSString *) updateNotification;
@end
