//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "StrongMouseEngine11.h"
#import "LevelScreen.h"
#import "LevelCompleteScreen.h"
#import "FTMConstants.h"
#import "FTMUtil.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
    kTagParentNode = 1,
};

StrongMouseEngineMenu11 *sLayer11;

@implementation StrongMouseEngineMenu11


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation StrongMouseEngine11

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    sLayer11=[StrongMouseEngineMenu11 node];
    [scene addChild:sLayer11 z:1];
    
    StrongMouseEngine11 *layer = [StrongMouseEngine11 node];
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    if( (self=[super init])) {
        
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"2",@"4",@"6",@"8",@"10",@"0",@"11",@"13",@"15",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",   @"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"20",@"80",@"80",@"80",@"40",@"80",nil];
        winSize = [CCDirector sharedDirector].winSize;
        gameFunc=[[StrongGameFunc alloc] init];
        soundEffect=[[sound alloc] init];
        trigo=[[Trigo alloc] init];
        [self initValue];
        gameFunc.gameLevel=motherLevel;
        
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        b2Vec2 gravity;
        gravity.Set(0, -5.0f);
        world = new b2World(gravity);
        world->SetContinuousPhysics(true);
        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
        world->SetDebugDraw(m_debugDraw);
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        m_debugDraw->SetFlags(flags);
        
        _contactListener = new MyContactListener();
        world->SetContactListener(_contactListener);
        
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"bridge_background.tmx"];
        self.background = [_tileMap layerNamed:@"bridge_background"];
        [self addChild:_tileMap z:-1 tag:1];
        
        /* NSString *tmxStr=[NSString stringWithFormat:@"level%d.tmx",motherLevel];
         NSString *layerNameStr=[NSString stringWithFormat:@"level%d",motherLevel];
         self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:tmxStr];
         self.background = [_tileMap layerNamed:layerNameStr];
         [self addChild:_tileMap z:-1 tag:1];*/
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"strong0_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"strong0_default.png"];
        [self addChild:spriteSheet z:10];
        
        [self addStrongMouseRunningSprite];
        [self addStrongMousePushingSprite];
        
        mouseDragSprite=[CCSprite spriteWithFile:@"mouse_drag.png"];
        mouseDragSprite.position=ccp(platformX+2,platformY+3);
        mouseDragSprite.scale=0.6;
        mouseDragSprite.visible=NO;
        mouseDragSprite.anchorPoint=ccp(0.99f, 0.9f);
        [self addChild:mouseDragSprite z:9];
        
        [self heroAnimationFunc:0 animationType:@"stand"];
        heroSprite.visible=NO;
        
        [self HeroDrawing];
        
        CCMenuItem *item1=[CCMenuItemImage itemWithNormalImage:@"play_screen_button_menu_1.png" selectedImage:@"play_screen_button_menu_2.png" target:self selector:@selector(clickMenuButton)];
        item1.position=ccp(0,0);
        
        menu=[CCMenu menuWithItems:item1, nil];
        menu.position=ccp(52,302);
        menu.visible = NO;
        [sLayer11 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [sLayer11 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [sLayer11 addChild: menu2 z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [sLayer11 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [sLayer11 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.position=ccp(250,292);
        lifeMinutesAtlas.visible = NO;
        [sLayer11 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        cheeseCollectedAtlas.visible = NO;
        [sLayer11 addChild:cheeseCollectedAtlas z:10];
        [cheeseCollectedAtlas setString:[NSString stringWithFormat:@"%d/%d",0,[cheeseSetValue[motherLevel-1] intValue]]];
        
        for(int i=0;i<cheeseCount;i++){
            cheeseCollectedChe[i]=YES;
            cheeseSprite2[i]=[CCSprite spriteWithFile:@"cheeseGlow.png"];
            cheeseSprite2[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self addChild:cheeseSprite2[i] z:9];
            
            cheeseSprite[i]=[CCSprite spriteWithFile:@"Cheese.png"];
            cheeseSprite[i].position=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i];
            [self addChild:cheeseSprite[i] z:9];
        }
        
        
        
        CCLabelAtlas *bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,154);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,154);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,154);
        [self addChild:bridgeAtlas z:0];
        
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(-25,52);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(349,52);
        [self addChild:bridgeAtlas z:0];
        bridgeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fridge_platform.png" itemWidth:395 itemHeight:49 startCharMap:'0'] retain];
        bridgeAtlas.position=ccp(724,52);
        [self addChild:bridgeAtlas z:0];
        
        
        CCSprite *bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform4.png"];
        bridgeSprite.position=ccp(820,433);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(890,595);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(66,473);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform.png"];
        bridgeSprite.position=ccp(240,570);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform2.png"];
        bridgeSprite.position=ccp(-72,570);
        [self addChild:bridgeSprite z:0];
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform3.png"];
        bridgeSprite.position=ccp(5,350);
        [self addChild:bridgeSprite z:0];
        
        
        bridgeSprite=[CCSprite spriteWithFile:@"fridge_platform3.png"];
        bridgeSprite.position=ccp(150,380);
        [self addChild:bridgeSprite z:0];
        
        CCSprite *objectSprite=[CCSprite spriteWithFile:@"bridge_object8.png"];
        objectSprite.position=ccp(90,508);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object6.png"];
        objectSprite.position=ccp(840,468);
        objectSprite.scale=0.8;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"object1.png"];
        objectSprite.position=ccp(590,398);
        objectSprite.opacity=170;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"object10.png"];
        objectSprite.position=ccp(410,378);
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"object10.png"];
        objectSprite.position=ccp(80,278);
        objectSprite.opacity=200;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object4.png"];
        objectSprite.position=ccp(130,98);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object3.png"];
        objectSprite.position=ccp(450,82);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        objectSprite=[CCSprite spriteWithFile:@"bridge_object1.png"];
        objectSprite.position=ccp(750,108);
        objectSprite.scale=0.7;
        [self addChild:objectSprite z:0];
        
        iceBlastAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"ice_blast.png" itemWidth:100 itemHeight:50 startCharMap:'0'] retain];
        iceBlastAtlas.position=ccp(-270,200);
        [self addChild:iceBlastAtlas z:9];
        
        for(int i=0;i<4;i++){
            iceQubeSprite[i]=[CCSprite spriteWithFile:@"ice_qube.png"];
            iceQubeSprite[i].position=ccp(-107,525);
            iceQubeSprite[i].rotation=arc4random() % 360 + 1;
            [self addChild:iceQubeSprite[i] z:1];
        }
        
        for(int i=0;i<2;i++){
            for(int j=0;j<2;j++){
                combinationFreezeSprite[i][j]=[CCSprite spriteWithFile:@"ice_smoke.png"];
                combinationFreezeSprite[i][j].position=ccp(-107,525);
                combinationFreezeSprite[i][j].rotation=arc4random() % 360 + 1;
                [self addChild:combinationFreezeSprite[i][j] z:1];
            }
        }
        
        
        CCSprite *freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(110,610);
        freezeWindowSprite.scaleX=0.8;
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(185,610);
        freezeWindowSprite.scaleX=0.8;
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(250,610);
        freezeWindowSprite.scaleX=0.8;
        [self addChild:freezeWindowSprite z:0];
        
        freezeWindowSprite=[CCSprite spriteWithFile:@"freeze_window.png"];
        freezeWindowSprite.position=ccp(315,610);
        freezeWindowSprite.scaleX=0.8;
        [self addChild:freezeWindowSprite z:0];
        
        CCSprite *iceBoxSprite=[CCSprite spriteWithFile:@"bridge_ice_box2.png"];
        iceBoxSprite.position=ccp(243,242);
        [self addChild:iceBoxSprite z:0];
        
        iceBoxSprite=[CCSprite spriteWithFile:@"bridge_ice_box.png"];
        iceBoxSprite.position=ccp(623,233);
        [self addChild:iceBoxSprite z:0];
        
        CCLabelAtlas *iceBoxAtlas = [[CCLabelAtlas labelWithString:@"1" charMapFile:@"bridge_ice_box2.png" itemWidth:232 itemHeight:90 startCharMap:'0'] retain];
        iceBoxAtlas.position=ccp(126,150);
        iceBoxAtlas.opacity=100;
        [self addChild:iceBoxAtlas z:10];
        
        iceBoxAtlas = [[CCLabelAtlas labelWithString:@"1" charMapFile:@"bridge_ice_box.png" itemWidth:279 itemHeight:90 startCharMap:'0'] retain];
        iceBoxAtlas.position=ccp(483,140);
        iceBoxAtlas.opacity=100;
        [self addChild:iceBoxAtlas z:10];
        
        movePlatformSprite=[CCSprite spriteWithFile:@"ice_platform.png"];
        movePlatformSprite.position=ccp(120,472);
        [self addChild:movePlatformSprite z:9];
        
        honeyPotSprite=[CCSprite spriteWithFile:@"honey_pot.png"];
        honeyPotSprite.position=ccp(90,390);
        honeyPotSprite.scale=0.8;
        [self addChild:honeyPotSprite z:9];
        
        electricSprite=[CCSprite spriteWithFile:@"electric.png"];
        electricSprite.position=ccp(890,360);
        electricSprite.scale=0.7;
        [self addChild:electricSprite z:9];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"bridge_hole.png"];
        holeSprite.position=ccp(973,558);
        [self addChild:holeSprite z:0];
        
        CCSprite *pushButtonSprite=[CCSprite spriteWithFile:@"push_button.png"];
        pushButtonSprite.position=ccp(43,337);
        pushButtonSprite.scaleY=0.35;
        pushButtonSprite.scaleX=0.55;
        [self addChild:pushButtonSprite z:1];
        
        for(int i=0;i<20;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];
        dotSprite.position=ccp(115,360);
        dotSprite.scale=0.2;
        [self addChild:dotSprite z:10];
        [self addHudLayerToTheScene];
        [self starCheeseSpriteInitilized];
        [self scheduleUpdate];
    }
    return self;
}
-(void) addHudLayerToTheScene{
    hudLayer = [[HudLayer alloc] init];
    hudLayer.tag = 11;
    [sLayer11 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    lvlCompleteLayer.tag = 11;
    [sLayer11 addChild: lvlCompleteLayer z:2000];
}
-(void)initValue{
    //Cheese Count Important
//    DB *db = [DB new];
    motherLevel = 11;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    platformX=750;//[gameFunc getPlatformPosition:motherLevel].x;
    platformY=250;//[gameFunc getPlatformPosition:motherLevel].y;
    
    platformX=[gameFunc getPlatformPosition:motherLevel].x;
    platformY=[gameFunc getPlatformPosition:motherLevel].y;
    
    screenHeroPosX=platformX;
    screenHeroPosY=platformY;
    
    jumpingChe=NO;
    heroStandChe=NO;
    heroStandAnimationCount=51;
    heroJumpingAnimationCount=0;
    dragChe=NO;
    forwardChe=NO;
    heroJumpingAnimationArrValue=0;
    landingChe=NO;
    runningChe=YES;
    heroJumpLocationChe=NO;
    heroForwardX=56;
    firstRunningChe=YES;
    mouseWinChe=NO;
    safetyJumpChe=NO;
    cheeseCollectedScore=0;
    jumpRunDiff=0;
    heroJumpRunningChe=NO;
    topHittingCount=0;
    heroTrappedChe=NO;
    autoJumpValue2=0;
    
    gameFunc.flowerFallChe=YES;
    combinationValue=1;
    
}

-(void) draw {
    /*	[super draw];
     ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
     kmGLPushMatrix();
     world->DrawDebugData();
     kmGLPopMatrix();*/
}
-(void)HeroDrawing{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(platformX/32.0,platformY/32.0);
    heroBody = world->CreateBody(&bodyDef);
    b2CircleShape shape;
    shape.m_radius = 0.53f;
    b2FixtureDef fd;
    fd.shape = &shape;
    fd.density = 1.0f;
    heroBody->CreateFixture(&fd);
    
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(platformX/32.0,(platformY/32.0)-0.5);
    b2Body *bottomBody = world->CreateBody(&bodyDef);
    b2PolygonShape dynamicBox;
    b2FixtureDef lFict;
    dynamicBox.SetAsBox(0.6f, 0.02f, b2Vec2(0.0f, 0.0f), 0.0f);
    lFict.shape = &dynamicBox;
    bottomBody->CreateFixture(&lFict);
}

-(void) update: (ccTime) dt {
    
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    world->Step(dt, velocityIterations, positionIterations);
    if(!gameFunc.trappedChe)
        [self heroJumpingFunc];
    [self heroAnimationFrameFunc];
    [self heroLandingFunc];
    [self heroRunFunc];
    [self heroWinFunc];
    
    [self level01];
    [self progressBarFunc];
    [self cheeseCollisionFunc];
    [self heroJumpingRunning];
    [self heroTrappedFunc];
    [self iceQubeAnimation];
    [self iceCubeCollision];
    [self switchFunc];
    
    gameFunc.runChe=runningChe;
    [gameFunc render];
    
    [self level05];
    
}

-(void)iceCubeCollision{
    
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?43:0);
    for(int i=0;i<4;i++){
        if(hx-iValue>iceQubeSprite[i].position.x-70 &&hx-iValue<iceQubeSprite[i].position.x-30 &&hy > iceQubeSprite[i].position.y-30 &&hy<iceQubeSprite[i].position.y+20 &&!gameFunc.trappedChe){
            gameFunc.trappedChe=YES;
            trappedTypeValue=1;
            
        }
    }
    
    //Combination Collision
    for(int i=0;i<2;i++){
        for(int j=0;j<2;j++){
            CGFloat xx=combinationFreezeSprite[i][j].position.x;
            CGFloat yy=combinationFreezeSprite[i][j].position.y;
            
            if(hx-iValue>xx-60 &&hx-iValue<xx+20 &&hy > yy-30 &&hy<yy+20 &&!gameFunc.trappedChe){
                gameFunc.trappedChe=YES;
                trappedTypeValue=2;
            }
        }
    }
    
    if(hx-iValue>electricSprite.position.x-120 &&hx-iValue<electricSprite.position.x+60 &&hy > electricSprite.position.y-30 &&hy<electricSprite.position.y+20 &&!gameFunc.trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }
    
    if(heroStandChe){
        if(hx-iValue>=270 &&hx-iValue<310&&hy==569){
            if(combinationFreezeCount[0]==0)
                combinationValue=1;
        }else if(hx-iValue>=205 &&hx-iValue<245&&hy==569){
            if(combinationFreezeCount[0]==0)
                combinationValue=2;
        }else if(hx-iValue>=140 &&hx-iValue<180&&hy==569){
            if(combinationFreezeCount[0]==0)
                combinationValue=3;
        }else if(hx-iValue>=65 &&hx-iValue<105&&hy==569){
            if(combinationFreezeCount[0]==0)
                combinationValue=4;
        }
    }
    
    
    if(combinationValue==1){
        combCheckValue[0]=250;
        combCheckValue[1]=110;
    }else if(combinationValue ==2){
        combCheckValue[0]=185;
        combCheckValue[1]=315;
    }else if(combinationValue ==3){
        combCheckValue[0]=110;
        combCheckValue[1]=250;
    }else if(combinationValue ==4){
        combCheckValue[0]=185;
        combCheckValue[1]=315;
    }
    
    for(int i=0;i<2;i++){
        for(int j=0;j<2;j++){
            if(combinationFreezeCount[i]!=0){
                int xx=0;
                int yy=0;
                
                if(combinationFreezeCount[i]<100){
                    xx=[trigo circlex:1 a:-(combinationFreezeCount[i]-250)]+combCheckValue[i]+(j*8)-5;
                    yy=[trigo circley:-20 a:-(combinationFreezeCount[i]-250)]+590;
                    
                    combinationFreezeSprite[i][j].position=ccp(xx,yy);
                    combinationFreezeSprite[i][j].scale=(combinationFreezeCount[i]/40.0)+0.1;
                    combinationFreezeSprite[i][j].opacity=(250-(combinationFreezeCount[i]*2.5));
                }
            }
        }
        combinationFreezeCount[i]+=3.0;
        if(combinationFreezeCount[i]>=100)
            combinationFreezeCount[i]=0;
    }
}


-(void)iceQubeAnimation{
    for(int i=0;i<4;i++){
        CGFloat xx=0;
        CGFloat yy=0;
        if(iceQubeCount[i]!=0){
            if(iceQubeCount[i]<230){
                iceQubeCount[i]+=1.2;
                xx=[trigo circlex:iceQubeCount[i] a:270]+480;
                yy=[trigo circley:iceQubeCount[i] a:270]+420;
            }else {
                iceQubeCount[i]+=1.2;
                xx=[trigo circlex:iceQubeCount[i] a:359]+198;
                yy=[trigo circley:iceQubeCount[i] a:359]+133;
            }
        }
        if(iceQubeCount[i]>=380){
            iceBlastAnimationCount=1;
            iceBlastAtlas.position=ccp(xx-125,yy+34);
            iceQubeCount[i]=0;
            iceQubeSprite[i].rotation=arc4random() % 360 + 1;
        }
        iceQubeSprite[i].position=ccp(xx-70,yy+45);
        
    }
    if(iceQubeReleaseCount==0){
        for(int i=0;i<4;i++){
            if(iceQubeCount[i]==0){
                iceQubeCount[i]=1;
                break;
            }
        }
    }
    
    iceQubeReleaseCount+=1;
    if(iceQubeReleaseCount>30){
        iceQubeReleaseCount=0;
    }
    
    
    if(iceBlastAnimationCount>=1){
        iceBlastAnimationCount+=3;
        if(iceBlastAnimationCount>=90){
            iceBlastAnimationCount=90;
            iceBlastAtlas.position=ccp(-200,100);
        }
        [iceBlastAtlas setString:[NSString stringWithFormat:@"%d",iceBlastAnimationCount/10]];
    }
    
    
    electricCount+=1;
    if(electricCount<150){
        electricSprite.position=ccp(850,360-electricCount);
        if(electricCount%4==0){
            if(electricSprite.flipY==0){
                electricSprite.flipY=1;
                electricSprite.scaleY=((arc4random() % 50)/50.0)+0.2;
                electricSprite.color=ccc3((arc4random() % 250)+1,(arc4random() % 250)+1,(arc4random() % 250)+1);
            }else{
                electricSprite.flipY=0;
                electricSprite.color=ccc3((arc4random() % 250)+1,(arc4random() % 250)+1,(arc4random() % 250)+1);
                electricSprite.scaleY=((arc4random() % 50)/50.0)+0.2;
                electricSprite.scaleX=((arc4random() % 20)/100.0)+0.5;
            }
        }
    }else{
        electricSprite.position=ccp(-300,360);
    }
    
    electricCount=(electricCount>350?0:electricCount);
}


-(void)switchFunc{
    
    if(!screenMoveChe&&gameFunc.honeyPotCount<=-20&&screenMovementFindValue==0){
        screenMoveChe=YES;
        screenMovementFindValue=1;
        screenShowX=233;
        screenShowY=platformY;
        screenShowX2=233;
        screenShowY2=platformY;
        
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
        heroPushSprite.visible=NO;
        gameFunc.pushChe=NO;
    }
    
    if(screenMoveChe){
        if(screenMovementFindValue==1){
            if(gameFunc.honeyPotCount2>=30){
                if(gameFunc.moveCount2==0)
                    gameFunc.moveCount2=0.1;
                screenShowX+=1;
                if(screenShowX>600)
                    screenMovementFindValue=2;
            }
        }else if(screenMovementFindValue == 2){
            screenShowX-=5;
            if(screenShowX<screenShowX2){
                screenShowX=screenShowX2;
                screenMovementFindValue=5;
                screenMoveChe=NO;
                screenHeroPosX=233;
                screenHeroPosY=platformY;
                screenShowX=233;
                screenShowY=platformY;
            }
        }
        CGPoint copyHeroPosition = ccp(screenShowX, screenShowY);
        [self setViewpointCenter:copyHeroPosition];
        
    }
}
-(void)level05{
    
    if(gameFunc.movePlatformChe){
        
        platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
        if(!forwardChe)
            heroSprite.position=ccp(platformX,platformY);
        else
            heroSprite.position=ccp(platformX+heroForwardX,platformY);
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        [self setViewpointCenter:copyHeroPosition];
        
        if(heroJumpLocationChe)
            [self HeroLiningDraw:0];
    }
    
    movePlatformSprite.position=ccp(320+gameFunc.moveCount2,472);
    honeyPotSprite.position=ccp(90+gameFunc.honeyPotCount,390-gameFunc.honeyPotCount2);
}
-(void)level01{
    if(firstRunningChe){
        if(platformX>[heroRunningStopArr[motherLevel-1] intValue]){
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
            firstRunningChe=NO;
            screenShowX=233;
            screenShowY=platformY;
            screenShowX2=233;
            screenShowY2=platformY;
        }
    }
    
    int fValue=(!forwardChe?0:30);
    if(heroSprite.position.x>=920+fValue && heroSprite.position.y>450 && heroSprite.position.y<=550&&!mouseWinChe&&!gameFunc.trappedChe){
        if(runningChe||heroStandChe){
            mouseWinChe=YES;
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
        }
    }else if(gameFunc.trappedChe){
        heroTrappedChe=YES;
        heroSprite.visible=NO;
        heroStandChe=NO;
        heroRunSprite.visible=NO;
    }
    if(gameFunc.trappedChe){
        if(heroTrappedChe&&heroTrappedCount>=100&&heroTrappedMove==0){
            menu2.visible=YES;
            mouseTrappedBackground.visible=YES;
        }
    }
    
    
}

-(void)starCheeseSpriteInitilized{
//    for(int i=0;i<5;i++){
//        starSprite[i] = [CCSprite spriteWithSpriteFrameName:@"star2.png"];
//        starSprite[i].scale=0.4;
//        starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8);
//        [spriteSheet addChild:starSprite[i] z:10];
//        
//        NSMutableArray *animFrames3 = [NSMutableArray array];
//        for(int j = 0; j <5; j++) {
//            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"star%d.png",j+1]];
//            [animFrames3 addObject:frame];
//        }
//        CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.2f];
//        [starSprite[i] runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
//    }
}
-(void)cheeseCollisionFunc{
    CGFloat heroX=heroSprite.position.x;
    CGFloat heroY=heroSprite.position.y;
    
    for(int i=0;i<cheeseCount;i++){
        
        if(cheeseCollectedChe[i]){
            cheeseStarAnimatedCount[i]+=1;
            if(cheeseStarAnimatedCount[i]>=60){
                cheeseStarAnimatedCount[i]=0;
                int x=(arc4random() % 5);
                cheeseX2=[cheeseArrX[x] intValue];
                cheeseY2=[cheeseArrY[x] intValue];
                
//                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2);
            }
            
            int mValue=0;
            int mValue2=0;
            
            cheeseAnimationCount+=2;
            cheeseAnimationCount=(cheeseAnimationCount>=500?0:cheeseAnimationCount);
            CGFloat localCheeseAnimationCount=0;
            localCheeseAnimationCount=(cheeseAnimationCount<=250?cheeseAnimationCount:250-(cheeseAnimationCount-250));
            cheeseSprite2[i].opacity=localCheeseAnimationCount/4;
            
            CGFloat cheeseX=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x;
            CGFloat cheeseY=[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y;
            BOOL ch2=YES;
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
//                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2&&ch2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
//                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }
        }else{
//            starSprite[i].visible=NO;
        }
    }
}

-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if(trappedTypeValue == 1 || trappedTypeValue == 2||trappedTypeValue == 3)
                heroTrappedMove = 1;
            
            mouseDragSprite.visible=NO;
            
            heroTrappedSprite = [CCSprite spriteWithFile:@"sm_mist_0.png"];
            if(!forwardChe)
                heroTrappedSprite.position = ccp(platformX, platformY+5);
            else
                heroTrappedSprite.position = ccp(platformX+heroForwardX, platformY+5);
            
            if (trappedTypeValue == 3) {
                [self showAnimationWithMiceIdAndIndex:FTM_STRONG_MICE_ID andAnimationIndex:STRONG_SHOCK_ANIM];
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroSprite.position.x, 185)];
                [heroTrappedSprite runAction:move];
            }
            else{
                int posY = 0;
                if(trappedTypeValue == 1){posY = 185;}
                else if(trappedTypeValue == 2){posY = 570;}
                heroTrappedSprite.scale=0.5;
                heroTrappedSprite.position = ccp(heroSprite.position.x, heroSprite.position.y);
                [self addChild:heroTrappedSprite z:1000];
                
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroSprite.position.x, posY)];
                [heroTrappedSprite runAction:move];
            }

           
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue==1)
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            else if(trappedTypeValue==2|| trappedTypeValue == 3)
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            
//            heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1 || trappedTypeValue == 3){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=185)
                    heroTrappedMove=0;
            }else if(trappedTypeValue == 2){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=570)
                    heroTrappedMove=0;
            }
        }
    }
    
}
-(void)heroWinFunc{
    if(mouseWinChe){
        heroWinCount+=1;
        if (heroWinCount <2) {
            DB *db = [DB new];
            int currentLvl = [[db getSettingsFor:@"strongCurrLvl"] intValue];
            if(currentLvl <= motherLevel){
                [db setSettingsFor:@"CurrentLevel" withValue:[NSString stringWithFormat:@"%d", motherLevel+1]];
                [db setSettingsFor:@"strongCurrLvl" withValue:[NSString stringWithFormat:@"%d", motherLevel+1]];
            }
            [db release];
        }

        if(heroWinCount==15){
            heroWinSprite = [CCSprite spriteWithSpriteFrameName:@"strong_win1.png"];
            heroWinSprite.scale = STRONG_SCALE;
            if(!forwardChe)
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            else
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            [spriteSheet addChild:heroWinSprite];
            
            NSMutableArray *animFrames2 = [NSMutableArray array];
            for(int i = 0; i <27; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"strong_win%d.png",i+1]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.05f];
            [heroWinSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            heroSprite.visible=NO;
            if(runningChe){
                heroRunSprite.visible=NO;
                heroSprite.visible=NO;
                runningChe=NO;
            }else if(heroStandChe){
                heroSprite.visible=NO;
                heroStandChe=NO;
            }
        }
        
         if(heroWinCount == 100){
            [self addLevelCompleteLayerToTheScene];
        }
    }
}
-(void)heroJumpingRunning{
    if(heroJumpRunningChe){
        jumpRunDiff2+=2;
        if(jumpRunDiff2>40-gameFunc.jumpDiff){
            gameFunc.jumpDiffChe=NO;
            heroJumpRunningChe=NO;
            jumpRunDiff=0;
            jumpRunDiff2=0;
            heroStandChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
        }
    }
}
-(void)heroRunFunc{
    if(runningChe&&!gameFunc.trappedChe){
        
        if(gameFunc.movePlatformChe){
            if(!forwardChe){
                gameFunc.movePlatformX+=(gameFunc.moveCount<=220?2.8:3.4);
                platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }else{
                gameFunc.movePlatformX-=(gameFunc.moveCount<=220?3.4:2.8);
                platformX=gameFunc.movePlatformX-gameFunc.landMoveCount+gameFunc.moveCount2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }
        }else{
            if(!forwardChe){
                platformX+=3.2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
                heroSprite.rotation=0;
                heroRunSprite.rotation=0;
            }else{
                platformX-=3.2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
                heroSprite.rotation=0;
                heroRunSprite.rotation=0;
            }
        }
        
        if(gameFunc.autoJumpChe){
            if(!gameFunc.domChe){
                jumpPower = 6;
                jumpAngle=(forwardChe?120:20);
                jumpingChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }else{
                if(!gameFunc.domeSideChe&&!forwardChe)
                    forwardChe=(forwardChe?NO:YES);
                else if(gameFunc.domeSideChe&&forwardChe)
                    forwardChe=(forwardChe?NO:YES);
                
                jumpPower = 6;
                jumpAngle=(forwardChe?120:20);
                jumpingChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
                gameFunc.domChe=NO;
            }
        }
        
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        heroRunSprite.position=ccp(platformX,platformY+2);
        [self setViewpointCenter:copyHeroPosition];
        [self heroUpdateForwardPosFunc];
        if(gameFunc.pushChe){
            if(!forwardChe)
                heroPushSprite.position=ccp(heroSprite.position.x+10,heroSprite.position.y);
            else
                heroPushSprite.position=ccp(heroSprite.position.x-10,heroSprite.position.y);
            
            heroRunSprite.visible=NO;
            heroPushSprite.visible=YES;
        }
    }
}
-(void)heroAnimationFrameFunc{
    if(heroStandChe){
        [self heroAnimationFunc:heroStandAnimationCount/40 animationType:@"stand"];
        heroStandAnimationCount+=1;
        if(heroStandAnimationCount>=80){
            heroStandAnimationCount=0;
        }
    }
}

-(void)heroAnimationFunc:(int)fValue animationType:(NSString *)type{
    [self updateAnimationOnCurrentType:fValue animationType:type];
    [self heroUpdateForwardPosFunc];
}
-(void)heroUpdateForwardPosFunc{
    
    if(!forwardChe){
        heroSprite.flipX=0;
        heroRunSprite.flipX=0;
        heroPushSprite.flipX=0;
        heroSprite.position=ccp(platformX,platformY);
        heroRunSprite.position=ccp(platformX,platformY+2);
        heroPushSprite.position=ccp(platformX,platformY+2);
    }else{
        heroSprite.flipX=1;
        heroRunSprite.flipX=1;
        heroPushSprite.flipX=1;
        heroSprite.position=ccp(platformX+heroForwardX,platformY);
        heroRunSprite.position=ccp(platformX+heroForwardX,platformY+2);
        heroPushSprite.position=ccp(platformX+heroForwardX,platformY+2);
    }
}
-(void)heroJumpingFunc{
    if(jumpingChe){
        if(heroJumpingAnimationArrValue<=5){
            if(heroJumpingAnimationCount==[heroJumpIntervalValue[heroJumpingAnimationArrValue] intValue]){
                if(safetyJumpChe&&heroJumpingAnimationArrValue==3){
                    if(!gameFunc.topHittingCollisionChe)
                        forwardChe=(forwardChe?NO:YES);
                    else
                        forwardChe=(forwardChe?YES:NO);
                    [self heroUpdateForwardPosFunc];
                }
                [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
                if(heroJumpingAnimationArrValue<=5){
                    heroJumpingAnimationArrValue+=1;
                    heroJumpingAnimationArrValue=(heroJumpingAnimationArrValue>=6?6:heroJumpingAnimationArrValue);
                }
            }
            if(heroJumpingAnimationCount<=10)
                heroJumpingAnimationCount+=1;//(gameFunc.autoJumpChe?5:1);
            
            
        }else{
            CGFloat angle=jumpAngle;
            
            
            if(!safetyJumpChe && !gameFunc.autoJumpChe&&!gameFunc.autoJumpChe2&&!gameFunc.minimumJumpingChe&&!gameFunc.topHittingCollisionChe){
                jumpPower = activeVect.Length();
                forwardChe=(angle<90.0?NO:YES);
                [self heroUpdateForwardPosFunc];
            }
            if(gameFunc.minimumJumpingChe)
                jumpPower=1;
            
            jumpPower=(jumpPower>17.5?17.5:jumpPower);
            b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
            impulse *= (jumpPower/2.2);
            
            heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
            
            b2Vec2 velocity = heroBody->GetLinearVelocity();
            impulse *= -1;
            heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
            velocity = b2Vec2(-velocity.x, velocity.y);
            
            b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:saveDottedPathCount*60 andAngle:angle];
            
            point = b2Vec2(-point.x, point.y);
            
            CGFloat xx=platformX+point.x;
            CGFloat yy=platformY+point.y;
            
            if(safetyJumpChe){
                /*  if(motherLevel==2)
                 yy=yy-8;
                 else if(motherLevel==3)
                 yy=yy-12;*/
                
            }
            
            if(gameFunc.autoJumpChe2&&autoJumpValue2==0){
                autoJumpValue2=1;
                [self endJumping:xx yValue:yy+8];
            }else if(gameFunc.autoJumpChe2 && autoJumpValue2>=1){
                autoJumpValue2+=1;
                if(autoJumpValue2>=40){
                    gameFunc.autoJumpChe2=NO;
                    autoJumpValue2=0;
                }
            }
            [gameFunc jumpingRender:xx yPosition:yy fChe:forwardChe];
            
            if(gameFunc.reverseJump){
                xx=gameFunc.xPosition;
                gameFunc.reverseJump=NO;
                safetyJumpChe=YES;
                [self endJumping:gameFunc.xPosition yValue:gameFunc.yPosition];
            }else if(gameFunc.landingChe){
                yy=gameFunc.yPosition;
                gameFunc.landingChe=NO;
                if(safetyJumpChe){
                    safetyJumpChe=NO;
                    gameFunc.topHittingCollisionChe=NO;
                }
                [self endJumping:gameFunc.xPosition yValue:gameFunc.yPosition];
            }
            
            if(xx>950){
                xx=950;
                safetyJumpChe=YES;
                [self endJumping:xx yValue:yy];
            }else if(xx<(firstRunningChe?-100:3)){
                xx=3;
                safetyJumpChe=YES;
                [self endJumping:xx yValue:yy];
            }else if(yy<[gameFunc getPlatformPosition:motherLevel].y){
                yy=[gameFunc getPlatformPosition:motherLevel].y;
                if(safetyJumpChe){
                    safetyJumpChe=NO;
                    gameFunc.topHittingCollisionChe=NO;
                }
                [self endJumping:xx yValue:yy];
            }
            
            if(backHeroJumpingY>=yy&&heroJumpingAnimationArrValue==6)
                [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
            
            backHeroJumpingY=yy;
            if(!forwardChe)
                heroSprite.position=ccp(xx,yy);
            else
                heroSprite.position=ccp(xx+heroForwardX,yy);
            
            CGPoint copyHeroPosition = ccp(xx, yy);
            [self setViewpointCenter:copyHeroPosition];
            saveDottedPathCount+=1;
        }
    }
}
-(void)endJumping:(CGFloat)xx yValue:(CGFloat)yy{
    platformX=xx;
    platformY=yy;
    saveDottedPathCount=0;
    jumpingChe=NO;
    landingChe=YES;
    heroJumpingAnimationArrValue=7;
    [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
    
    if(gameFunc.topHittingCollisionChe&&topHittingCount==0){
        topHittingCount=1;
        jumpAngle=(forwardChe?160:20);
        heroJumpingAnimationCount=18;
        jumpPower = 4;
        if(gameFunc.objectJumpChe){
            gameFunc.objectJumpChe=NO;
            jumpPower=7;
        }
        jumpingChe=YES;
        landingChe=NO;
        heroJumpingAnimationArrValue=6;
        [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
    }else{
        heroJumpingAnimationCount=11;
        topHittingCount=0;
        gameFunc.topHittingCollisionChe=NO;
    }
    
    
}
-(void)heroLandingFunc{
    if(landingChe){
        if(heroJumpingAnimationCount==[heroJumpIntervalValue[heroJumpingAnimationArrValue] intValue]){
            [self heroAnimationFunc:heroJumpingAnimationArrValue animationType:@"jump"];
            heroJumpingAnimationArrValue+=1;
            heroJumpingAnimationArrValue=(heroJumpingAnimationArrValue>=9?9:heroJumpingAnimationArrValue);
            if(safetyJumpChe&&heroJumpingAnimationArrValue==8){
                if(!gameFunc.topHittingCollisionChe){
                    BOOL localForwardChe=forwardChe;
                    localForwardChe=(localForwardChe?NO:YES);
                    jumpAngle=(localForwardChe?160:20);
                }else{
                    jumpAngle=(forwardChe?160:20);
                }
                heroJumpingAnimationCount=19;
                jumpPower = 4;
                if(gameFunc.objectJumpChe){
                    gameFunc.objectJumpChe=NO;
                    jumpPower=7;
                }
                heroJumpingAnimationArrValue=3;
                jumpingChe=YES;
            }
        }
        heroJumpingAnimationCount+=1;
        if(heroJumpingAnimationCount>18){
            if(!safetyJumpChe){
                heroStandChe=YES;
                heroJumpingAnimationArrValue=0;
                if(gameFunc.jumpDiff<=40&&gameFunc.jumpDiffChe&&!heroJumpRunningChe){
                    heroJumpRunningChe=YES;
                    jumpRunDiff=gameFunc.jumpDiff;
                    heroStandChe=NO;
                    runningChe=YES;
                    heroSprite.visible=NO;
                    heroRunSprite.visible=YES;
                }
            }
            if(gameFunc.autoJumpChe)
                gameFunc.autoJumpChe=NO;
            
            if(autoJumpValue2==1&&gameFunc.autoJumpChe2){
                jumpPower = (gameFunc.autoJumpSpeedValue==1?8:5);
                gameFunc.autoJumpSpeedValue=0;
                jumpAngle=(forwardChe?140:20);
                jumpingChe=YES;
                runningChe=NO;
                heroStandChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }else if(autoJumpValue2 == 2&&gameFunc.autoJumpChe2){
                gameFunc.autoJumpChe2=NO;
                
            }
            
            landingChe=NO;
            heroJumpingAnimationCount=0;
        }
    }
}

-(void)HeroLiningDraw:(int)cPath{
    
    CGFloat angle=jumpAngle;
    
    if(!safetyJumpChe){
        jumpPower = activeVect.Length();
        forwardChe=(angle<90.0?NO:YES);
        [self heroUpdateForwardPosFunc];
    }
    
    jumpPower=(jumpPower>16.5?16.5:jumpPower);
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= (jumpPower/2.2)-0.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    for (int i = 0; i < 20&&!safetyJumpChe; i=i+1) {
        b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:i*170 andAngle:angle];
        point = b2Vec2(-point.x, point.y);
        
        int lValue=(!forwardChe?65:27);
        CGFloat xx=platformX+point.x+lValue-20;
        CGFloat yy=platformY+point.y+12;
        
        heroPimpleSprite[i].position=ccp(xx,yy);
    }
    
    if(!forwardChe)
        mouseDragSprite.position=ccp(platformX - DRAG_SPRITE_OFFSET_X,platformY-DRAG_SPRITE_OFFSET_Y);
    else
        mouseDragSprite.position=ccp(platformX + DRAG_SPRITE_OFFSET_X/2 +heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
    
    mouseDragSprite.rotation=(180-angle)-170;
    mouseDragSprite.scale=0.3+(jumpPower/40.0);
    
    
}

-(b2Vec2) getTrajectoryPoint:(b2Vec2) startingPosition andStartVelocity:(b2Vec2) startingVelocity andSteps: (float)n andAngle:(CGFloat)a {
    
    float t = 1 / 60.0f;
    float lhPtmRatio = 32.0f;
    b2Vec2 gravity2;
    gravity2.Set(0, -10.0f);
    b2Vec2 gravity = gravity2;
    b2Vec2 stepVelocity = t * startingVelocity;
    b2Vec2 gravityForCocos2dWorld = b2Vec2(gravity.x/lhPtmRatio, gravity.y/lhPtmRatio);
    b2Vec2 stepGravity = t * t * gravityForCocos2dWorld;
    
    return startingPosition + n * stepVelocity + 0.5f * (n*n+n) * stepGravity;
}
-(void)setViewpointCenter:(CGPoint) position {
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    if(x<=winSize.width/2)
        screenHeroPosX=position.x;
    else if(x>=_tileMap.mapSize.width-winSize.width/2)
        screenHeroPosX=(position.x-x)+winSize.width/2;
    if(y<=winSize.height/2)
        screenHeroPosY=position.y;
    else if(y>=_tileMap.mapSize.height-winSize.height/2)
        screenHeroPosY=(position.y-y)+winSize.height/2;
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
    
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint prevLocation = [myTouch previousLocationInView: [myTouch view]];
    prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
    
    if(!mouseWinChe&&!heroTrappedChe&&!screenMoveChe){
        
        int forwadeValue=(!forwardChe?0:heroForwardX);
        if(location.x>=screenHeroPosX-60+forwadeValue && location.x <= screenHeroPosX+40+forwadeValue && location.y>screenHeroPosY-30&&location.y<screenHeroPosY+18){
            if(!jumpingChe&&!dragChe&&!runningChe&&heroStandChe){
                
                heroJumpLocationChe=YES;
                dragChe=YES;
                heroStandChe=NO;
                [self heroAnimationFunc:0 animationType:@"jump"];
                mouseDragSprite.visible=YES;
                if(!forwardChe){
                    mouseDragSprite.position=ccp(platformX -DRAG_SPRITE_OFFSET_X,platformY-DRAG_SPRITE_OFFSET_Y);
                    mouseDragSprite.rotation=(180-0)-170;
                }else{
                    mouseDragSprite.rotation=(180-180)-170;
                    mouseDragSprite.position=ccp(platformX + DRAG_SPRITE_OFFSET_X/2+heroForwardX,platformY-DRAG_SPRITE_OFFSET_Y/2);
                }
                startVect = b2Vec2(location.x, location.y);
                activeVect = startVect - b2Vec2(location.x, location.y);
                jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
            }
        }else{
            if((location.x<70 || location.x>winSize.width-70) && location.y < 70){
                if(!jumpingChe&&!landingChe&&!firstRunningChe){
                    if(!runningChe){
                    if(screenHeroPosX+25<location.x)
                        forwardChe=NO;
                    else
                        forwardChe=YES;
                    heroStandChe=NO;
                    runningChe=YES;
                    heroSprite.visible=NO;
                    heroRunSprite.visible=YES;
                    }
                }
            }
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!mouseWinChe&&motherLevel!=1&&!heroTrappedChe&&!screenMoveChe){
        activeVect = startVect - b2Vec2(location.x, location.y);
        jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
        [self HeroLiningDraw:0];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(!mouseWinChe&&!heroTrappedChe){
        if(!jumpingChe&&!runningChe&&heroJumpLocationChe&&!screenMoveChe){
            heroJumpLocationChe=NO;
            saveDottedPathCount=0;
            jumpPower = activeVect.Length();
            activeVect = startVect - b2Vec2(location.x, location.y);
            jumpAngle = fabsf( CC_RADIANS_TO_DEGREES( atan2f(-activeVect.y, activeVect.x)));
            jumpingChe=YES;
            dragChe=NO;
            mouseDragSprite.visible=NO;
            for (int i = 0; i < 20; i=i+1) {
                heroPimpleSprite[i].position=ccp(-100,100);
            }
            if(gameFunc.movePlatformChe)
                gameFunc.movePlatformChe=NO;
        }else if(!jumpingChe&&!landingChe&&!firstRunningChe){
            if(runningChe){
                gameFunc.pushChe=NO;
                heroPushSprite.visible=NO;
                heroStandChe=YES;
                runningChe=NO;
                heroRunSprite.visible=NO;
                heroSprite.visible=YES;
            }
        }
    }
    
}

-(void)clickMenuButton{
    [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
}
-(void)clickLevel:(CCMenuItem *)sender {
    if(sender.tag == 1){
        [[CCDirector sharedDirector] replaceScene:[StrongMouseEngine11 scene]];
//        [self respwanTheMice];
    }else if(sender.tag ==2){
        [[CCDirector sharedDirector] replaceScene:[LevelScreen scene]];
    }
}

-(void ) respwanTheMice{
    gameFunc.trappedChe = NO;
    safetyJumpChe = YES;
    [FTMUtil sharedInstance].isRespawnMice = YES;
    menu2.visible=NO;
    mouseTrappedBackground.visible=NO;
    runningChe = NO;
    heroTrappedSprite.visible = NO;
    if (trappedTypeValue == 3) {
        [[self getTrappingAnimatedSprite] removeFromParentAndCleanup:YES];
    }
    [self endJumping:(platformX + gameFunc.xPosition)/2 yValue:gameFunc.yPosition];
    [self schedule:@selector(startRespawnTimer) interval:1];
}

-(void) startRespawnTimer{
    [self unschedule:@selector(startRespawnTimer)];
    if ([FTMUtil sharedInstance].isRespawnMice) {
        [FTMUtil sharedInstance].isRespawnMice = NO;
        heroTrappedChe = NO;
        heroTrappedCount = 0;
    }
}


-(void) createExplosionX: (float) x y: (float) y {
    [self removeChild:cheeseEmitter cleanup:YES];
    cheeseEmitter = [CCParticleSun node];
    [self addChild:cheeseEmitter ];
    cheeseEmitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"Cheese.png"];
    cheeseEmitter.position=ccp(x,y);
    cheeseEmitter.duration = 0.1f;
    cheeseEmitter.lifeVar = 0.3f;
    
    
    if(screenHeroPosX>=240&&screenHeroPosX<=760){
        if(!forwardChe){
            cheeseEmitter.life = 0.2f;
            cheeseEmitter.angleVar=-50.0;
            cheeseEmitter.angle=-180;
            cheeseEmitter.speed=90;
            cheeseEmitter.speedVar =50;
            cheeseEmitter.startSize=20.5;
            cheeseEmitter.endSize=2.2;
        }else{
            cheeseEmitter.life = 0.2f;
            cheeseEmitter.angleVar=50.0;
            cheeseEmitter.angle=180;
            cheeseEmitter.speed=-70;
            cheeseEmitter.speedVar =-50;
            cheeseEmitter.startSize=20.5;
            cheeseEmitter.endSize=2.2;
        }
    }else{
        if(!forwardChe){
            cheeseEmitter.life = 0.5f;
            cheeseEmitter.angleVar=-50.0;
            cheeseEmitter.angle=-180;
            cheeseEmitter.speed=20;
            cheeseEmitter.speedVar =30;
            cheeseEmitter.startSize=10.5;
            cheeseEmitter.endSize=2.2;
        }else{
            cheeseEmitter.life = 0.5f;
            cheeseEmitter.angleVar=50.0;
            cheeseEmitter.angle=180;
            cheeseEmitter.speed=-20;
            cheeseEmitter.speedVar =-30;
            cheeseEmitter.startSize=10.5;
            cheeseEmitter.endSize=2.2;
        }
    }
    ccColor4F startColor = {0.8f, 0.7f, 0.3f, 1.0f};
    cheeseEmitter.startColor = startColor;
}
-(CGFloat)platesMovingpath:(int)cValue position:(int)pValue{
    
    CGFloat angle=2;
    
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= 14.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:cValue*15 andAngle:angle];
    point = b2Vec2(-point.x+(point.x/1.5), point.y+(point.y/1.5));
    
    int lValue=65;
    CGFloat xx=150+point.x+lValue-20;
    CGFloat yy=450+point.y+12;
    
    return (pValue==0?xx:yy);
}

-(void) dealloc {
    [super dealloc];
}


@end
