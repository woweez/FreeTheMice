//
//  MyOwnScroller.m
//  FreeTheMice
//
//  Created by Muhammad Kamran on 9/28/13.
//
//

#import "MyOwnScroller.h"
#import "cocos2d.h"
#import "SWScrollView.h"
#import "AboutScreen.h"
@implementation MyOwnScroller 
    

+(CCScene *)scene{
    CCScene *node = [CCScene node];
    
    MyOwnScroller *layer = [MyOwnScroller node];
    [node addChild:layer];
    return node;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        
//        CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(100, 100, 100, 255)];
		SWScrollView *scrollView = [SWScrollView viewWithViewSize:CGSizeMake(200.0f, 200.0f)];
//		contents   = [NSMutableArray new];
		
		CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:ccc4(105, 100, 255, 255)];
		CCSprite *sprite = [CCSprite spriteWithFile:@"big_window.png"];
        //setting positions, CCLayer’s anchorPoint is ccp(0.0f, 0.0f), screen origin.
        sprite.position = ccp(0.0f, 0.0f);
        scrollView.position   = ccp(240.0f, 160.0f);
        scrollView.contentOffset = ccp(0.0f, 0.0f);
//        scrollView.isDragging = YES;
//        scrollView.bounces = YES;
        scrollView.direction = SWScrollViewDirectionVertical;
        scrollView.contentSize = sprite.contentSize;
//        [scrollView addChild:sprite];
        
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"arrow.png" selectedImage:@"arrow_press.png" block:^(id sender) {
           [[CCDirector sharedDirector] replaceScene:[AboutScreen scene]];
		}];
        [aboutMenuItem setScale:0.5];
        CCMenu *aboutBtnMenu = [CCMenu menuWithItems:aboutMenuItem, nil];
        aboutBtnMenu.position = ccp(10, 26);
        [scrollView addChild:aboutBtnMenu z:10];
        
        [self addChild:scrollView z:9999999];
        
//		scrollView.maxZoomScale  = 2.0f;
//		scrollView.minZoomScale  = 0.5f;
//		scrollView.contentSize   = CGSizeMake(1000.0f, 1000.0f);
//        scrollView.position =ccp(240, 160);
//        scrollView.visible = YES;// You need to set contentSize to enable scrolling
//		layer.contentSize		 = scrollView.contentSize;
//		
//		[scrollView addChild:layer];

		[self addChild:backgroundLayer];

        
        
        
        
//        colorLayer = [CCLayerColor layerWithColor:ccc4(100, 200, 60, 255)];
//        CGSize size;
//        size.width = 250;
//        size.height = 150;
//        colorLayer.contentSize = size;
//        CCNode * node = [CCNode node];
//        node.contentSize = size;
//        CCSprite *sprite = [CCSprite spriteWithFile:@"big_window.png"];
//        sprite.contentSize = size;
//        [node addChild:sprite];
//        [colorLayer addChild:node];
//        colorLayer.position = ccp(240, 160);
//        
//        UITableView * energyTable_ = [[UITableView alloc] initWithFrame:CGRectMake(240, 160, 100, 101)];
////		[energyTable_ setBackgroundColor:[UIColor clearColor]];
////		[energyTable_ setFrame:CGRectMake(2, 50, 500, 581)];
//		[energyTable_ setBackgroundColor:[UIColor greenColor]];
//		
////		[energyTable_ setDelegate:self];
////		[energyTable_ setDataSource:self];
////        
//        
//		[[[CCDirector sharedDirector] view] addSubview:energyTable_];
//		[energyTable_ setShowsVerticalScrollIndicator:YES];
////		[energyTable_ setBackgroundColor:[UIColor clearColor]]; // black Color
//		
//		[energyTable_ setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        [self addChild:colorLayer];
    }
    return self;
}

@end
