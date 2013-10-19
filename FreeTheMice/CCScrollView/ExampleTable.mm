//
//  ExampleTableView.m
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Martin Rehder on 06.05.13.
//

#import "ExampleTable.h"
#import "ExampleCell.h"
#import "FTMConstants.h"
#import "SWMultiColumnTableView.h"
@implementation ExampleTable
NSString *const ToolShedUpdateProductPurchasedNotification = @"ToolShedUpdateProductPurchasedNotification";
//provide data to your table
//telling cell size to the table
-(Class)cellClassForTable:(SWTableView *)table {
    return [ExampleCell class];
}

-(CGSize)cellSizeForTable:(SWTableView *)table
{
    return [ExampleCell cellSize];
}

//providing CCNode object for a cell at a given index
-(SWTableViewCell *)table:(SWTableView *)table cellAtIndex:(NSUInteger)idx {
    SWTableViewCell *cell;
    cell = [table dequeueCell];
    scaleFactorX = [CCDirector sharedDirector].winSize.width/480;
    scaleFactorY = [CCDirector sharedDirector].winSize.height/320;
    if (!cell)
    { //there is no recycled cells in the table
        cell = [[ExampleCell new] autorelease]; // create a new one
        cell.anchorPoint = CGPointZero;
        
    }else{
        
        [cell.children removeAllObjects];

    }

    //configure the sprite.. do all kinds of super cool things you can do with cocos2d.
    CCSprite *temp = [CCSprite node];
    GLubyte *buffer = (GLubyte *) malloc(sizeof(GLubyte)*4);
    for (int i=0;i<4;i++) {buffer[i]=128;}
    CGSize size = [ExampleCell cellSize];
    CCTexture2D *tex = [[CCTexture2D alloc] initWithData:buffer pixelFormat:kCCTexture2DPixelFormat_RGBA8888 pixelsWide:1 pixelsHigh:1 contentSize:size];
    [temp setTexture:tex];
    free(buffer);
    
    temp.color = ccc3(random_range(10, 100), random_range(10, 100), random_range(10, 100));
    temp.textureRect = CGRectMake(0, 0, size.width *scaleFactorX, size.height *scaleFactorY);
    temp.opacity = 128;

    temp.anchorPoint = CGPointZero;
    [cell addChild:temp];
    int itemId = ++idx;
    NSString *path = [self getAppropriateImagePathWithItemID:itemId];
    CGPoint pos = [self getAppropriatePosWithItemID:itemId];
    
    CCSprite *powrUpSpr = [CCSprite spriteWithFile:path];
    powrUpSpr.position = pos;
    powrUpSpr.scale = 0.5;
    powrUpSpr.tag = itemId;
    
    [cell addChild:powrUpSpr];
    
    
    CCMenuItem *buyItem = [CCMenuItemImage itemWithNormalImage:@"buy-btn.png" selectedImage:@"buy-btn-press.png" block:^(id sender) {
        
        CCMenuItem *item = (CCMenuItem *)sender;
        int cost = [self getCostWithItemID:item.tag];
        int cheese = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentCheese"];
        if(cheese < cost){
            return;
        }
        cheese -= cost;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:cheese] forKey:@"currentCheese"];
        [defaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:ToolShedUpdateProductPurchasedNotification object:nil userInfo:nil];
    
    }];
    
    [buyItem setScale:0.45];
    buyItem.tag = itemId;
    CCMenu *buyItemMenu = [CCMenu menuWithItems:buyItem, nil];
    buyItemMenu.position = ccp(powrUpSpr.position.x + 87 *scaleFactorX, powrUpSpr.position.y *1.26);
    buyItemMenu.tag = itemId;
    buyItemMenu.contentSize = CGSizeMake(buyItem.contentSize.width/4 *scaleFactorX ,buyItem.contentSize.height/4 *scaleFactorY);
    [cell addChild:buyItemMenu];
    
    CCLabelAtlas *cost = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", [self getCostWithItemID:itemId]] charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'];
    cost.position= ccp(buyItemMenu.position.x -15 *scaleFactorX, buyItemMenu.position.y - 28 *scaleFactorY);
    cost.scale=0.5;
    [cell addChild:cost z:0];
    
//    CCLabelBMFont *name = [CCLabelBMFont labelWithString:@"AAA" fntFile:@"font1.fnt"];
//    name.position= ccp(powrUpSpr.position.x -10 *scaleFactorX, powrUpSpr.position.y - 35 *scaleFactorY);
////    name.scale=0.5;
//    [cell addChild:name z:99999];
    
    
    CCLabelAtlas *multiplier = [CCLabelAtlas labelWithString:@"3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'];
    multiplier.position= ccp(powrUpSpr.position.x + 21*scaleFactorX, powrUpSpr.position.y - 20 *scaleFactorY);
    multiplier.scale=0.5;
    [cell addChild:multiplier z:0];
    
    
    CCSprite *cheeseSpr = [CCSprite spriteWithFile:@"cheese_bite.png"];
    cheeseSpr.position = ccp(cost.position.x + 32*scaleFactorX, powrUpSpr.position.y - 15 *scaleFactorY);;
    cheeseSpr.scale = 0.5;
    cheeseSpr.tag = itemId;
    [cell addChild:cheeseSpr];
    
    return cell;
}
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    //return a number
    return 7;
}

-(CGPoint) getAppropriatePosWithItemID:(int) itemId{
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);//28
            break;
        case BOOTS_ITEM_ID:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);
            break;
        case SPEEDUP_ITEM_ID:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);
            break;
        case MASTER_KEY_ITEM_ID:
            return ccp(30 *scaleFactorX, 35*scaleFactorY );
            break;
        case BARKING_DOG_ITEM_ID:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);
            break;
        default:
            return ccp(30 *scaleFactorX, 35 *scaleFactorY);
            break;
    }
    
}

-(int) getCostWithItemID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return 20;
            break;
        case BOOTS_ITEM_ID:
            return 30;
            break;
        case SPEEDUP_ITEM_ID:
            return 30;
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return 150;
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return 40;
            break;
        case MASTER_KEY_ITEM_ID:
            return 1000;
            break;
        case BARKING_DOG_ITEM_ID:
            return 100;
            break;
        default:
            return 0;
            break;
    }
}


-(NSString *) getAppropriateImagePathWithItemID:(int) itemId{
    
    switch(itemId){
        case MAGNIFIER_ITEM_ID:
            return @"magnifier_glass.png";
            break;
        case BOOTS_ITEM_ID:
            return @"boots.png";
            break;
        case SPEEDUP_ITEM_ID:
            return @"speed_fire_cheese.png";
            break;
        case SPECIAL_CHEESE_ITEM_ID:
            return @"special_cheese_respawn.png";
            break;
        case SLOWDOWN_TIME_ITEM_ID:
            return @"slow_down_time.png";
            break;
        case MASTER_KEY_ITEM_ID:
            return @"master_key.png";
            break;
        case BARKING_DOG_ITEM_ID:
            return @"barking_sound.png";
            break;
        default:
            return @"barking_sound.png";
            break;
    }
}//touch detection here
-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell
{
        NSLog(@"Store item touched at index %d",cell.idx);
    
  
}

-(void)dealloc{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);

    
    [super dealloc];
    
}

@end
