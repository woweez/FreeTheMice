//
//  ToolShedScreen.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 28/09/2013.
//
//

#import "ToolShedScreen.h"
#import "MenuScreen.h"
#import "cocos2d.h"
#import "FTMUtil.h"
#import "FTMConstants.h"
#import "SWScrollView.h"
#import "SWTableView.h"
#import "ExampleTable.h"
#import "SWMultiColumnTableView.h"
@implementation ToolShedScreen

+(CCScene *) scene {
	
    CCScene *scene = [CCScene node];
    ToolShedScreen *layer = [ToolShedScreen node];
    [scene addChild: layer];
	
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        scaleFactorX = screenSize.width/480;
        scaleFactorY = screenSize.height/320;
        
        CCSprite *shedBg = [CCSprite spriteWithFile: @"shed_bg.png"];
        shedBg.position = ccp(240 *scaleFactorX, 160 *scaleFactorY);
        shedBg.scaleX = 0.5 * scaleFactorX;
        shedBg.scaleY = 0.5 * scaleFactorY;
        [self addChild:shedBg];
        
        CCSprite *currentCheeseBg = [CCSprite spriteWithFile: @"cheese_available.png"];
        currentCheeseBg.position = ccp(160 *scaleFactorX, 300 *scaleFactorY);
        currentCheeseBg.scale = 0.5;
        [self addChild:currentCheeseBg];
        
        CCSprite *mrToolBag = [CCSprite spriteWithFile: @"mr_tool_bag.png"];
        if([FTMUtil sharedInstance].isIphone5){
            mrToolBag.position = ccp(390 *scaleFactorX, 15 *scaleFactorY + mrToolBag.contentSize.height/4);
        }
        else{
            mrToolBag.position = ccp(402 *scaleFactorX, 17 *scaleFactorY + mrToolBag.contentSize.height/4);
        }
        
        mrToolBag.scale = 0.5;
        [self addChild:mrToolBag z:10];
        
        CCSprite *tapPowerupInfo = [CCSprite spriteWithFile: @"tap_powerup_popup.png"];
        if([FTMUtil sharedInstance].isIphone5){
            tapPowerupInfo.position = ccp(405 *scaleFactorX, 38 *scaleFactorY + mrToolBag.contentSize.height/2);
        }
        else{
            tapPowerupInfo.position = ccp(420 *scaleFactorX, 40 *scaleFactorY + mrToolBag.contentSize.height/2);

        }
        tapPowerupInfo.scale = 0.5;
        [self addChild:tapPowerupInfo z:10];
        
        CCMenuItem *buyCheeseItem = [CCMenuItemImage itemWithNormalImage:@"buy_cheese_btn.png" selectedImage:@"buy_cheese_btn.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MenuScreen node]];
//            open up the store here for inApp..
		}];
        [buyCheeseItem setScale:0.5];
        
        CCMenu *buyBtnMenu = [CCMenu menuWithItems:buyCheeseItem, nil];
        buyBtnMenu.position = ccp(226*scaleFactorX, 300 *scaleFactorY);
        [self addChild:buyBtnMenu];
        
    
        CCMenuItem *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"back_button_1.png" selectedImage:@"back_button_2.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MenuScreen scene]];
            
		}];
        [backMenuItem setScale:0.3];
        CCMenu *menu = [CCMenu menuWithItems: backMenuItem,  nil];
        [menu alignItemsVerticallyWithPadding:30.0];
        menu.position=ccp(190 *scaleFactorX, 15 *scaleFactorY);
        [self addChild: menu];

        CCMenuItem *powerUpItem = [CCMenuItemImage itemWithNormalImage:@"powerups_btn.png" selectedImage:@"powerups_btn.png" disabledImage:@"powerups_btn_disable.png"  block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MenuScreen node]];
            // open up the store here for inApp..
		}];
        [powerUpItem setScale:0.5];
        
        CCMenu *powerUpMenu = [CCMenu menuWithItems:powerUpItem, nil];
        powerUpMenu.position = ccp(124*scaleFactorX, 243 *scaleFactorY);
        [self addChild:powerUpMenu z:10];
        
        
        CCMenuItem *costumesItem = [CCMenuItemImage itemWithNormalImage:@"costumes_btn.png" selectedImage:@"costumes_btn.png" disabledImage:@"costumes_btn_disable.png"  block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MenuScreen node]];
            // open up the store here for inApp..
		}];
        
        [costumesItem setScale:0.5];
        CCMenu *costumesMenu = [CCMenu menuWithItems:costumesItem, nil];
        costumesMenu.position = ccp(273*scaleFactorX, 243 *scaleFactorY);
        [self addChild:costumesMenu z:10];
        
        [self addScrollVIew];
//        [self addPowerUpsUi];
        
    }
    return self;
}

-(void) addScrollVIew{
    
    ExampleTable *exampleTable = [[ExampleTable alloc] init];
    
    CGSize tSize = CGSizeMake(288 *scaleFactorX, 195 *scaleFactorY);
    SWMultiColumnTableView *myTable = [SWMultiColumnTableView viewWithDataSource:exampleTable size:tSize];
    myTable.position = ccp(52 *scaleFactorX, 50 *scaleFactorY);
    myTable.delegate = exampleTable; //set if you need touch detection on cells.
    myTable.colCount = 2;
    myTable.verticalFillOrder = SWTableViewFillTopDown;
    myTable.direction = SWScrollViewDirectionVertical;
    [self addChild:myTable];
    [myTable reloadData];
}
//-(void) addPowerUpsUi {
//    [self makePowerUpItem:MAGNIFIER_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:SPECIAL_CHEESE_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:SPEEDUP_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:SLOWDOWN_TIME_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:BARKING_DOG_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:BOOTS_ITEM_ID cost: 100 multiplier: 3];
//    [self makePowerUpItem:MASTER_KEY_ITEM_ID cost: 100 multiplier: 3];
//}

-(void) addNewCostumesUi {
    
}

-(void) hidePowerUpUi{
    
}

-(void) hideNewConstumesUi{
    
}


@end
