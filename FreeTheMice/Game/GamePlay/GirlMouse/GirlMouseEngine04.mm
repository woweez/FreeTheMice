//
//  HelloWorldLayer.mm
//  Tap
//
//  Created by karthik g on 27/09/12.
//  Copyright karthik g 2012. All rights reserved.
//

// Import the interfaces
#import "GirlMouseEngine04.h"
#import "LevelScreen.h"
#import "FTMConstants.h"
#import "FTMUtil.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DB.h"
enum {
    kTagParentNode = 1,
};

GirlMouseEngineMenu04 *gLayer04;

@implementation GirlMouseEngineMenu04


-(id) init {
    if( (self=[super init])) {
    }
    return self;
}
@end

@implementation GirlMouseEngine04

@synthesize tileMap = _tileMap;
@synthesize background = _background;

+(CCScene *) scene {
    CCScene *scene = [CCScene node];
    gLayer04=[GirlMouseEngineMenu04 node];
    [scene addChild:gLayer04 z:1];
    
    GirlMouseEngine04 *layer = [GirlMouseEngine04 node];
    [scene addChild: layer];
    
    return scene;
}

-(id) init
{
    if( (self=[super init])) {
        
        heroJumpIntervalValue = [[NSArray alloc] initWithObjects:@"0",@"4",@"7",@"9",@"12",@"14",@"0",@"15",@"18",@"21",nil];
        cheeseSetValue= [[NSArray alloc] initWithObjects:@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",@"5",nil];
        cheeseArrX=[[NSArray alloc] initWithObjects:@"0",@"20",@"0",   @"20",@"10",nil];
        cheeseArrY=[[NSArray alloc] initWithObjects:@"0",@"0", @"-15", @"-15",@"-8",nil];
        heroRunningStopArr=[[NSArray alloc] initWithObjects:@"80",@"80",@"80", @"40",@"140",@"80",@"80",@"80",@"80",@"80",@"80",@"80",@"40",@"80",nil];
        winSize = [CCDirector sharedDirector].winSize;
        gameFunc=[[GirlGameFunc alloc] init];
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
        
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        _tileMap.position=ccp(0,-158);
        _tileMap.scaleY=1.3;
        [self addChild:_tileMap z:-1 tag:1];
        
        
        cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"girl_default.plist"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"girl_default.png"];
        [self addChild:spriteSheet z:10];
        
        
        heroRunSprite = [CCSprite spriteWithSpriteFrameName:@"girl_run1.png"];
        heroRunSprite.position = ccp(200, 200);
        heroRunSprite.scale=0.65;
        [spriteSheet addChild:heroRunSprite];
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for(int i = 1; i < 8; i++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_run%d.png",i]];
            [animFrames addObject:frame];
        }
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.07f];
        [heroRunSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation]]];
        
//        
//        catCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        [catCache addSpriteFramesWithFile:@"cat_default.plist"];
//        catSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cat_default.png"];
//        [self addChild:catSpriteSheet z:1];
//        
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
        [gLayer04 addChild:menu z:10];
        
        mouseTrappedBackground=[CCSprite spriteWithFile:@"mouse_trapped_background.png"];
        mouseTrappedBackground.position=ccp(240,160);
        mouseTrappedBackground.visible=NO;
        [gLayer04 addChild:mouseTrappedBackground z:10];
        
        CCMenuItem *aboutMenuItem = [CCMenuItemImage itemWithNormalImage:@"main_menu_button_1.png" selectedImage:@"main_menu_button_2.png" target:self selector:@selector(clickLevel:)];
        aboutMenuItem.tag=2;
        
        CCMenuItem *optionMenuItem = [CCMenuItemImage itemWithNormalImage:@"try_again_button_1.png" selectedImage:@"try_again_button_2.png" target:self selector:@selector(clickLevel:)];
        optionMenuItem.tag=1;
        
        menu2 = [CCMenu menuWithItems: optionMenuItem,aboutMenuItem,  nil];
        [menu2 alignItemsHorizontallyWithPadding:4.0];
        menu2.position=ccp(241,136);
        menu2.visible=NO;
        [gLayer04 addChild: menu2 z:10];
        
        progressBarBackSprite=[CCSprite spriteWithFile:@"grey_bar_57.png"];
        progressBarBackSprite.position=ccp(240,300);
        progressBarBackSprite.visible = NO;
        [gLayer04 addChild:progressBarBackSprite z:10];
        
        cheeseCollectedSprite=[CCSprite spriteWithFile:@"cheese_collected.png"];
        cheeseCollectedSprite.position=ccp(430,300);
        cheeseCollectedSprite.visible = NO;
        [gLayer04 addChild:cheeseCollectedSprite z:10];
        
        timeCheeseSprite=[CCSprite spriteWithFile:@"time_cheese.png"];
        timeCheeseSprite.position=ccp(121+240,301);
        timeCheeseSprite.visible = NO;
        [gLayer04 addChild:timeCheeseSprite z:10];
        
        
        lifeMinutesAtlas = [[CCLabelAtlas labelWithString:@"01.60" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        lifeMinutesAtlas.visible = NO;
        lifeMinutesAtlas.position=ccp(250,292);
        [gLayer04 addChild:lifeMinutesAtlas z:10];
        
        
        cheeseCollectedAtlas = [[CCLabelAtlas labelWithString:@"0/3" charMapFile:@"numbers.png" itemWidth:15 itemHeight:20 startCharMap:'.'] retain];
        cheeseCollectedAtlas.visible = NO;
        cheeseCollectedAtlas.position=ccp(422,292);
        cheeseCollectedAtlas.scale=0.8;
        [gLayer04 addChild:cheeseCollectedAtlas z:10];
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
        
        CCSprite *slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(178,140);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(526,140);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        slapSprite=[CCSprite spriteWithFile:@"slap.png"];
        slapSprite.position=ccp(828,140);
        slapSprite.scale=0.7;
        [self addChild:slapSprite z:1];
        
        CCSprite *platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(35,290);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform3.png"];
        platformSprite.position=ccp(200,290);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"move_platform2.png"];
        platformSprite.position=ccp(235,405);
        [self addChild:platformSprite z:1];
        
        platformSprite=[CCSprite spriteWithFile:@"platform4.png"];
        platformSprite.position=ccp(425,485);
        platformSprite.scaleX=0.8;
        platformSprite.scaleY=0.4;
        [self addChild:platformSprite z:2];
        
        
        CCSprite *sPlatformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        sPlatformSprite.position=ccp(60,500);
        [self addChild:sPlatformSprite z:10];
        
        sPlatformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        sPlatformSprite.position=ccp(925,360);
        sPlatformSprite.scaleX=0.8;
        [self addChild:sPlatformSprite z:10];
        
        sPlatformSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        sPlatformSprite.position=ccp(755,500);
        sPlatformSprite.scaleX=0.6;
        [self addChild:sPlatformSprite z:10];
        
        stickyPlatfromSprite=[CCSprite spriteWithFile:@"sticky_platform.png"];
        stickyPlatfromSprite.position=ccp(100,690);
        stickyPlatfromSprite.scaleX=0.7;
        [self addChild:stickyPlatfromSprite z:10];
        
        CCSprite *windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(350,480);
        windowSprite.scale=1.3;
        [self addChild:windowSprite z:1];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(490,480);
        windowSprite.scale=1.3;
        [self addChild:windowSprite z:1];
        
        windowSprite=[CCSprite spriteWithFile:@"window1.png"];
        windowSprite.position=ccp(630,480);
        windowSprite.scale=1.3;
        [self addChild:windowSprite z:1];
        
        CCSprite *holeSprite=[CCSprite spriteWithFile:@"hole.png"];
        holeSprite.position=ccp(970,241);
        [self addChild:holeSprite z:0];
        
        CCSprite *knifeSprite=[CCSprite spriteWithFile:@"knives_shelf.png"];
        knifeSprite.position=ccp(275,629);
        knifeSprite.rotation=90;
//        knifeSprite.scale=0.6;
        [self addChild:knifeSprite z:1];
        
        knifeSprite=[CCSprite spriteWithFile:@"knives_shelf.png"];
        knifeSprite.position=ccp(930,629);
//        knifeSprite.scale=0.7;
        knifeSprite.flipY= 1;
        [self addChild:knifeSprite z:10];
        
        for(int i=0;i<10;i++){
            hotSprite[i]=[CCSprite spriteWithFile:@"smoke.png"];
            hotSprite[i].position=ccp(-275,415);
            [self addChild:hotSprite[i] z:0];
        }
        
        switchAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"switch.png" itemWidth:40 itemHeight:103 startCharMap:'0'] retain];
        switchAtlas.position=ccp(540,200);
        switchAtlas.scale=0.7;
        [self addChild:switchAtlas z:1];
        
        CCSprite *crackedSprite=[CCSprite spriteWithFile:@"cracked.png"];
        crackedSprite.position=ccp(696,430);
        crackedSprite.flipX=1;
        [self addChild:crackedSprite z:1];
        
        
        CCLabelAtlas *crackeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"cracked.png" itemWidth:12 itemHeight:30 startCharMap:'0'] retain];
        crackeAtlas.position=ccp(285,574);
        crackeAtlas.rotation=90;
        [self addChild:crackeAtlas z:1];
        
        crackeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"cracked.png" itemWidth:12 itemHeight:30 startCharMap:'0'] retain];
        crackeAtlas.position=ccp(310,574);
        crackeAtlas.rotation=90;
        [self addChild:crackeAtlas z:1];
        
        crackeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"cracked.png" itemWidth:12 itemHeight:30 startCharMap:'0'] retain];
        crackeAtlas.position=ccp(335,574);
        crackeAtlas.rotation=90;
        [self addChild:crackeAtlas z:1];
        
        crackeAtlas = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"cracked.png" itemWidth:12 itemHeight:30 startCharMap:'0'] retain];
        crackeAtlas.position=ccp(360,574);
        crackeAtlas.rotation=90;
        [self addChild:crackeAtlas z:1];
        
        CCSprite *cookerSprite=[CCSprite spriteWithFile:@"cooker.png"];
        cookerSprite.position=ccp(480,230);
        cookerSprite.scale=0.8;
        cookerSprite.flipX=1;
        [self addChild:cookerSprite z:1];
        
        for(int i=0;i<25;i++){
            heroPimpleSprite[i]=[CCSprite spriteWithFile:@"dotted.png"];
            heroPimpleSprite[i].position=ccp(-100,160);
            heroPimpleSprite[i].scale=0.3;
            [self addChild:heroPimpleSprite[i] z:10];
        }
        
        //===================================================================
        dotSprite=[CCSprite spriteWithFile:@"dotted.png"];

        dotSprite.position=ccp(155,515);
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
    hudLayer.tag = 4;
    [gLayer04 addChild: hudLayer z:2000];
    [hudLayer updateNoOfCheeseCollected:0 andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];
}

-(void) addLevelCompleteLayerToTheScene{
    hudLayer.visible = NO;
    LevelCompleteScreen *lvlCompleteLayer = [[LevelCompleteScreen alloc] init];
    lvlCompleteLayer.tag = 4;
    [gLayer04 addChild: lvlCompleteLayer z:2000];
}

-(void)initValue{
    
//    DB *db = [DB new];
    motherLevel = 4;//[[db getSettingsFor:@"CurrentLevel"] intValue];
//    [db release];
    cheeseCount=[cheeseSetValue[motherLevel-1] intValue];
    
    platformX=880;
    platformY=495;
    
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
    heroForwardX=36;
    firstRunningChe=YES;
    mouseWinChe=NO;
    safetyJumpChe=NO;
    cheeseCollectedScore=0;
    jumpRunDiff=0;
    heroJumpRunningChe=NO;
    topHittingCount=0;
    heroTrappedChe=NO;
    autoJumpValue2=0;
    
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
    [self level05];
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
    [self switchFunc];
    gameFunc.runChe=runningChe;
    [gameFunc render];
    [self hotSmokingFunc];
    [self collisionFunc];
    if(!screenMoveChe){
        [self catFunc];
        [self secondCatFunc];
    }
    
    
    if(visibleCount>=1){
        visibleCount+=15;
        if(visibleCount>=249){
            visibleCount=249;
        }
    }
    
}
-(void)catFunc{
    
    if(!catJumpChe && catObj1 == nil){
        catObj1 = [[GirlLevel4Cat alloc] init];
        [catObj1 runCurrentSequenceForFirstCat];
        [self addChild:catObj1];
    }
    
    if(!catBackChe){
        if(catMovementCount<75){
            if(turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount a:359]+40;
                catY=[trigo circley:catMovementCount a:359]+524;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                catMovementCount+=1.0;
                if(catMovementCount >=75)
                    catJumpChe=YES;
            }
        }else if(catMovementCount>=75&&catMovementCount <199){
            if(catJumpingAnimationCount>=55){
                catX=[trigo circlex:45 a:200-catMovementCount]+166;
                catY=[trigo circley:100 a:200-catMovementCount]+423;
                catMovementCount+=2;
                
                if(catJumpingAnimationCount>=55){
                    catJumpingAnimationCount+=1;
                    catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                    if(catJumpingAnimationCount%5==0)
                        [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount>=199 && catMovementCount<329){
            if(catMovementCount==199){
                if(catJumpChe){
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                        if(catJumpingAnimationCount>105){
                            turnAnimationCount=1;
                            
                        }
                    }else{
                        if(turnAnimationCount ==0){
                            catMovementCount=200;
                            catJumpingAnimationCount=0;
                        }
                    }
                }
            }else{
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:70 a:catMovementCount-150]+165;
                    catY=[trigo circley:120 a:catMovementCount-150]+312;
                    catMovementCount+=2;
                    if(catJumpingAnimationCount>=55){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount>=329 ){
            if(!catJumpChe&&turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount-329 a:359]+78;
                catY=[trigo circley:catMovementCount-329 a:359]+314;
                catMovementCount+=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount>480){
                    catBackChe=YES;
                    turnAnimationCount=1;
                    catMovementCount=480;
                }
                
            }else{
                if(catJumpChe){
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                        turnAnimationCount=1;
                    }
                }
            }
        }
    }else{
        
        if(catMovementCount>329 && catMovementCount<=480){
            if(turnAnimationCount==0){
                catX=[trigo circlex:catMovementCount-329 a:359]+78;
                catY=[trigo circley:catMovementCount-329 a:359]+314;
                catMovementCount-=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount<=329){
                    turnAnimationCount=1;
                    catMovementCount=329;
                }
            }
        }else if(catMovementCount>199&&catMovementCount<=329){
            if(catMovementCount==329){
                if(turnAnimationCount==0){
                    catJumpChe=YES;
                    catMovementCount=328;
                }
            }else{
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:70 a:catMovementCount-150]+165;
                    catY=[trigo circley:120 a:catMovementCount-150]+312;
                    catMovementCount-=2;
                    if(catJumpingAnimationCount>=55&&catMovementCount<250){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount>75&&catMovementCount<=199){
            if(catMovementCount==198){
                if(catJumpChe){
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                        if(catJumpingAnimationCount>105){
                            turnAnimationCount=1;
                        }
                    }else{
                        if(turnAnimationCount ==0){
                            catMovementCount=197;
                            catJumpingAnimationCount=0;
                        }
                    }
                }
            }else{
                if(catJumpingAnimationCount>=55){
                    catX=[trigo circlex:45 a:200-catMovementCount]+166;
                    catY=[trigo circley:100 a:200-catMovementCount]+423;
                    catMovementCount-=2;
                    if(catJumpingAnimationCount>=55&&catMovementCount<110){
                        catJumpingAnimationCount+=1;
                        catJumpingAnimationCount=(catJumpingAnimationCount>=90?90:catJumpingAnimationCount);
                        if(catJumpingAnimationCount%5==0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount<=75){
            if(!catJumpChe){
                catX=[trigo circlex:catMovementCount a:359]+40;
                catY=[trigo circley:catMovementCount a:359]+524;
                catMovementCount-=1;
                if(catAnimationCount%2 == 0)
                    [self catSpriteGenerate:catAnimationCount/2 animationType:@"run"];
                if(catMovementCount<=0){
                    turnAnimationCount=1;
                    catBackChe=NO;
                }
                
            }else{
                if(catJumpChe){
                    if(catJumpingAnimationCount<=105){
                        catJumpingAnimationCount+=1;
                        if(catJumpingAnimationCount%5 == 0)
                            [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount=0;
                        catJumpChe=NO;
                    }
                }
            }
        }
        
    }
    
    
    if(turnAnimationCount>0){
        turnAnimationCount+=1;
        if(turnAnimationCount%4==0)
            [self catSpriteGenerate:turnAnimationCount/4 animationType:@"turn"];
        if(turnAnimationCount>=40){
            turnAnimationCount=0;
            if(!catForwardChe)
                catForwardChe=YES;
            else
                catForwardChe=NO;
        }
    }
    
    if(catJumpChe){
        if(catJumpingAnimationCount<55){
            catJumpingAnimationCount+=1;
            if(catJumpingAnimationCount%5==0)
                [self catSpriteGenerate:catJumpingAnimationCount/5 animationType:@"jump"];
        }
    }
    catAnimationCount+=2;
    catAnimationCount=(catAnimationCount>=43?0:catAnimationCount);
//    if(turnAnimationCount==0)
//        catSprite.position=ccp(catX,catY+16);
//    else
//        catSprite.position=ccp(catX,catY+13);
    
}
-(void)secondCatFunc{
    
    if(!catJumpChe2 && catObj2 == nil){
        catObj2 = [[GirlLevel4Cat alloc] init];
        [catObj2 runCurrentSequenceForSecondCat];
        [self addChild:catObj2];
    }
    
    if(!catBackChe2){
        if(catMovementCount2<215){
            if(turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2 a:359]+420;
                catY2=[trigo circley:catMovementCount2 a:359]+581;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                
                if(catMovementCount2>=215)
                    catJumpChe2=YES;
            }
        }else if(catMovementCount2>=215 &&catMovementCount2<331){
            if(catJumpingAnimationCount2>=55){
                catX2=[trigo circlex:50 a:340-catMovementCount2]+726;
                catY2=[trigo circley:75 a:340-catMovementCount2]+506;
                catMovementCount2+=2;
                
                if(catJumpingAnimationCount2>=55){
                    catJumpingAnimationCount2+=1;
                    catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                    if(catJumpingAnimationCount2%5==0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount2>=331 &&catMovementCount2<438){
            if(catMovementCount2 == 331){
                if(catJumpChe2){
                    if(catJumpingAnimationCount2<=105){
                        catJumpingAnimationCount2+=1;
                        if(catJumpingAnimationCount2%5 == 0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount2=0;
                        catMovementCount2=332;
                    }
                }
            }else{
                if(catJumpingAnimationCount2>=55){
                    catX2=[trigo circlex:103 a:440-catMovementCount2]+832;
                    catY2=[trigo circley:130 a:440-catMovementCount2]+372;
                    catMovementCount2+=1;
                    if(catJumpingAnimationCount2>=55){
                        catJumpingAnimationCount2+=1;
                        catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                        if(catJumpingAnimationCount2%5==0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount2>=438 && catMovementCount2< 510){
            if(!catJumpChe2&&turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-438 a:179]+960;
                catY2=[trigo circley:catMovementCount2-438 a:179]+381;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2>=510)
                    catJumpChe2=YES;
            }else{
                if(catJumpChe2){
                    if(catJumpingAnimationCount2<=105){
                        catJumpingAnimationCount2+=1;
                        if(catJumpingAnimationCount2%5 == 0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount2=0;
                        catJumpChe2=NO;
                        turnAnimationCount2=1;
                    }
                }
            }
        }else if(catMovementCount2>=510 && catMovementCount2<629){
            if(catJumpingAnimationCount2>=55){
                catX2=[trigo circlex:50 a:catMovementCount2-450]+840;
                catY2=[trigo circley:150 a:catMovementCount2-450]+218;
                catMovementCount2+=1;
                if(catJumpingAnimationCount2>=55){
                    catJumpingAnimationCount2+=1;
                    catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                    if(catJumpingAnimationCount2%5==0)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }
            }
        }else if(catMovementCount2>=629 && catMovementCount2<750){
            if(catMovementCount2==629){
                if(catJumpChe2){
                    if(catJumpingAnimationCount2<=105){
                        catJumpingAnimationCount2+=1;
                        if(catJumpingAnimationCount2%5 == 0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount2=0;
                        catJumpChe2=NO;
                        turnAnimationCount2=1;
                        catMovementCount2=630;
                    }
                }
            }else if(turnAnimationCount2 == 0){
                catX2=[trigo circlex:catMovementCount2-629 a:359]+780;
                catY2=[trigo circley:catMovementCount2-629 a:359]+221;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2>=750)
                    turnAnimationCount2=1;
            }
        }else if(catMovementCount2>=750 && catMovementCount2<1000){
            if(turnAnimationCount2==0){
                catX2 =[trigo circlex:catMovementCount2-750 a:179]+930;
                catY2 =[trigo circley:catMovementCount2-750 a:179]+221;
                catMovementCount2+=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2>=1000){
                    catMovementCount2=1000;
                    catBackChe2=YES;
                    turnAnimationCount2=1;
                }
            }
        }
    }else{
        if(catMovementCount2>750 && catMovementCount2<=1000){
            if(turnAnimationCount2==0){
                catX2 =[trigo circlex:catMovementCount2-750 a:179]+930;
                catY2 =[trigo circley:catMovementCount2-750 a:179]+221;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2<=750){
                    turnAnimationCount2=1;
                }
            }
        }else if(catMovementCount2>629 && catMovementCount2<=750){
            if(turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-629 a:359]+780;
                catY2=[trigo circley:catMovementCount2-629 a:359]+221;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2<=629)
                    turnAnimationCount2=1;
            }
        }else if(catMovementCount2>510 && catMovementCount2<=629){
            
            if(catMovementCount2==629){
                if(turnAnimationCount2==0){
                    catMovementCount2=628;
                    catJumpChe2=YES;
                }
            }else{
                if(catJumpingAnimationCount2>=55){
                    catX2=[trigo circlex:50 a:catMovementCount2-450]+840;
                    catY2=[trigo circley:150 a:catMovementCount2-450]+218;
                    catMovementCount2-=1;
                    if(catJumpingAnimationCount2>=55&&catMovementCount2<550){
                        catJumpingAnimationCount2+=1;
                        catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                        if(catJumpingAnimationCount2%5==0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount2>438 && catMovementCount2<=510){
            if(!catJumpChe2&&turnAnimationCount2==0){
                catX2=[trigo circlex:catMovementCount2-438 a:179]+960;
                catY2=[trigo circley:catMovementCount2-438 a:179]+381;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2<=438)
                    turnAnimationCount2=1;
                
            }else{
                if(catJumpChe2){
                    if(catJumpingAnimationCount2<=105){
                        catJumpingAnimationCount2+=1;
                        if(catJumpingAnimationCount2%5 == 0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount2=0;
                        catJumpChe2=NO;
                    }
                }
            }
        }else if(catMovementCount2>331 &&catMovementCount2<=438){
            if(catMovementCount2 == 438){
                if(turnAnimationCount2==0){
                    catMovementCount2=437;
                    catJumpChe2=YES;
                }
            }else{
                if(catJumpingAnimationCount2>=55){
                    catX2=[trigo circlex:103 a:440-catMovementCount2]+832;
                    catY2=[trigo circley:130 a:440-catMovementCount2]+372;
                    catMovementCount2-=1;
                    if(catJumpingAnimationCount2>=55&&catMovementCount2<370){
                        catJumpingAnimationCount2+=1;
                        catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                        if(catJumpingAnimationCount2%5==0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount2>215 &&catMovementCount2<=331){
            if(catMovementCount2==331){
                if(catJumpChe2){
                    if(catJumpingAnimationCount2<=105){
                        catJumpingAnimationCount2+=1;
                        if(catJumpingAnimationCount2%5 == 0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }else{
                        catJumpingAnimationCount2=0;
                        catMovementCount2=330;
                    }
                }
            }else{
                if(catJumpingAnimationCount2>=55){
                    catX2=[trigo circlex:50 a:340-catMovementCount2]+726;
                    catY2=[trigo circley:75 a:340-catMovementCount2]+506;
                    catMovementCount2-=2;
                    
                    if(catJumpingAnimationCount2>=55){
                        catJumpingAnimationCount2+=1;
                        catJumpingAnimationCount2=(catJumpingAnimationCount2>=90?90:catJumpingAnimationCount2);
                        if(catJumpingAnimationCount2%5==0)
                            [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                    }
                }
            }
        }else if(catMovementCount2<=215){
            if(!catJumpChe2){
                catX2=[trigo circlex:catMovementCount2 a:359]+420;
                catY2=[trigo circley:catMovementCount2 a:359]+581;
                catMovementCount2-=1;
                if(catAnimationCount2%2 == 0)
                    [self secondCatSpriteGenerate:catAnimationCount2/2 animationType:@"run"];
                if(catMovementCount2<=0){
                    catBackChe2=NO;
                    turnAnimationCount2=1;
                }
            }else{
                if(catJumpingAnimationCount2<=105){
                    catJumpingAnimationCount2+=1;
                    if(catJumpingAnimationCount2%5 == 0&&catMovementCount2<=260)
                        [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
                }else{
                    catJumpingAnimationCount2=0;
                    catJumpChe2=NO;
                }
            }
        }
    }
    
    if(turnAnimationCount2>0){
        turnAnimationCount2+=1;
        if(turnAnimationCount2%4==0)
            [self secondCatSpriteGenerate:turnAnimationCount2/4 animationType:@"turn"];
        if(turnAnimationCount2>=40){
            turnAnimationCount2=0;
            if(!catForwardChe2)
                catForwardChe2=YES;
            else
                catForwardChe2=NO;
        }
    }
    
    if(catJumpChe2){
        if(catJumpingAnimationCount2<55){
            catJumpingAnimationCount2+=1;
            if(catJumpingAnimationCount2%5==0)
                [self secondCatSpriteGenerate:catJumpingAnimationCount2/5 animationType:@"jump"];
        }
    }
    catAnimationCount2+=2;
    catAnimationCount2=(catAnimationCount2>=43?0:catAnimationCount2);
//    if(turnAnimationCount2==0)
//        catSprite2.position=ccp(catX2,catY2+16);
//    else
//        catSprite2.position=ccp(catX2,catY2+13);
}
-(void)catSpriteGenerate:(int)fValue animationType:(NSString *)type{
//    NSString *fStr=@"";
//    if([type isEqualToString:@"run"])
//        fStr=[NSString stringWithFormat:@"cat_run%d.png",fValue+1];
//    else if([type isEqualToString:@"turn"]){
//        fStr=[NSString stringWithFormat:@"cat_turn_run%d.png",fValue];
//    }else if([type isEqualToString:@"jump"])
//        fStr=[NSString stringWithFormat:@"cat_jump%d.png",fValue];
//    
//    [catSpriteSheet removeChild:catSprite cleanup:YES];
//    catSprite = [CCSprite spriteWithSpriteFrameName:fStr];
//    catSprite.position = ccp(catX,catY);
//    catSprite.scale=0.6;
//    if(!catForwardChe){
//        catSprite.flipX=0;
//    }else{
//        catSprite.flipX=1;
//    }
//    [catSpriteSheet addChild:catSprite z:10];
}

-(void)secondCatSpriteGenerate:(int)fValue animationType:(NSString *)type{
//    NSString *fStr=@"";
//    if([type isEqualToString:@"run"])
//        fStr=[NSString stringWithFormat:@"cat_run%d.png",fValue+1];
//    else if([type isEqualToString:@"turn"]){
//        fStr=[NSString stringWithFormat:@"cat_turn_run%d.png",fValue];
//    }else if([type isEqualToString:@"jump"])
//        fStr=[NSString stringWithFormat:@"cat_jump%d.png",fValue];
//    
//    [catSpriteSheet removeChild:catSprite2 cleanup:YES];
//    catSprite2 = [CCSprite spriteWithSpriteFrameName:fStr];
//    catSprite2.position = ccp(catX2,catY2);
//    catSprite2.scale=0.6;
//    if(!catForwardChe2){
//        catSprite2.flipX=0;
//    }else{
//        catSprite2.flipX=1;
//    }
//    [catSpriteSheet addChild:catSprite2 z:10];
}

-(void)collisionFunc{
    CGFloat hx=heroSprite.position.x;
    CGFloat hy=heroSprite.position.y;
    int iValue=(forwardChe?43:0);
    
    
    if(hx-iValue>495 && hx-iValue<570&&hy>218 &&hy<260 && gameFunc.switchCount==0&&screenMovementFindValue==0){
        gameFunc.switchCount=1;
        [switchAtlas setString:@"1"];
        
        screenMoveChe=YES;
        screenMovementFindValue=1;
        screenShowX=platformX;
        screenShowY=platformY;
        screenShowX2=platformX;
        screenShowY2=platformY;
        
        heroStandChe=YES;
        runningChe=NO;
        heroRunSprite.visible=NO;
        heroSprite.visible=YES;
    }
    
    for(int i=0;i<10;i++){
        if(hx-iValue>hotSprite[i].position.x-70 &&hx-iValue<hotSprite[i].position.x+20 &&hy > hotSprite[i].position.y-10 &&hy<hotSprite[i].position.y+10 &&!gameFunc.
           trappedChe){
            gameFunc.trappedChe=YES;
            trappedTypeValue=2;
        }
    }
    
    if(hx>195&&hx<235&&hy>580&&hy<720&&jumpingChe&&!forwardChe&&!gameFunc.trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=1;
    }else if(hx-iValue>830&&hy>605&&hy<=665&&!gameFunc.trappedChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=3;
    }
    
    if(hx-iValue>[catObj1 getCatSprite].position.x-90 &&hx-iValue<[catObj1 getCatSprite].position.x+40 &&hy > [catObj1 getCatSprite].position.y-30 &&hy<[catObj1 getCatSprite].position.y+50 &&!gameFunc.
       trappedChe&&!gameFunc.stickyChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=4;
    }else if(hx-iValue>[catObj2 getCatSprite].position.x-90 &&hx-iValue<[catObj2 getCatSprite].position.x+40 &&hy > [catObj2 getCatSprite].position.y-30 &&hy<[catObj2 getCatSprite].position.y+50 &&!gameFunc.trappedChe&&!gameFunc.stickyChe){
        gameFunc.trappedChe=YES;
        trappedTypeValue=4;
    }
}

-(void)switchFunc{
    if(screenMoveChe){
        if(screenMovementFindValue==1){
            screenShowY+=2;
            if(screenShowY>500){
                screenMovementFindValue=2;
            }
        }else if(screenMovementFindValue==2){
            screenShowY-=5;
            if(screenShowY<screenShowY2){
                screenShowY=screenShowY2;
                screenMovementFindValue=5;
                screenMoveChe=NO;
                screenHeroPosX=platformX;
                screenHeroPosY=platformY;
                screenShowX=platformX;
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
        if(heroJumpLocationChe){
            [self HeroLiningDraw:0];
        }
    }
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
    
    stickyPlatfromSprite.position=ccp(100+gameFunc.moveCount2,720);
    
    int fValue=(!forwardChe?0:30);
    if(heroSprite.position.x>=920+fValue &&heroSprite.position.y<=330&&!mouseWinChe&&!gameFunc.trappedChe){
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
-(void)hotSmokingFunc{
    CGFloat sx=0;
    CGFloat sy=0;
    CGFloat hotScale=0;
    CGFloat divideLength=0;
    
    sx=466;
    sy=230;
    hotScale=0.7;
    divideLength=1.8;
    
    for(int i=0;i<10;i++){
        if(hotSmokingCount[i]>=1){
            hotSmokingCount[i]+=1.5;
            hotSprite[i].position=ccp(sx,sy+(hotSmokingCount[i]/divideLength));
            hotSprite[i].opacity=250-(hotSmokingCount[i]);
            hotSprite[i].scale=hotScale+(hotSmokingCount[i]/400.0);
            if(hotSmokingCount[i]>=250){
                hotSmokingCount[i]=0;
                hotSprite[i].position=ccp(-200,100);
            }
        }
    }
    
    
    if(hotSmokingRelease == 0){
        for(int i=0;i<10;i++){
            if(hotSmokingCount[i]==0){
                hotSmokingCount[i]=1;
                hotSmokingRelease=1;
                break;
            }
        }
    }
    if(hotSmokingRelease>=1){
        hotSmokingRelease+=1;
        if(hotSmokingRelease>=17){
            hotSmokingRelease=0;
        }
    }
    
    
}

-(void)starCheeseSpriteInitilized{
    for(int i=0;i<5;i++){
        starSprite[i] = [CCSprite spriteWithSpriteFrameName:@"star2.png"];
        starSprite[i].scale=0.4;
        starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8);
        [spriteSheet addChild:starSprite[i] z:10];
        
        NSMutableArray *animFrames3 = [NSMutableArray array];
        for(int j = 0; j <5; j++) {
            CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"star%d.png",j+1]];
            [animFrames3 addObject:frame];
        }
        CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames3 delay:0.2f];
        [starSprite[i] runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
    }
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
                
                starSprite[i].position=ccp([gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].x-12+cheeseX2,[gameFunc getCheesePosition:1 gameLevel:motherLevel iValue:i].y+8+cheeseY2);
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
            
            if(!forwardChe){
                if(heroX>=cheeseX-70-mValue &&heroX<=cheeseX+10-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];

                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }else{
                if(heroX>=cheeseX-10-mValue &&heroX<=cheeseX+70-mValue&&heroY>cheeseY-20+mValue2&&heroY<cheeseY+30+mValue2){
                    [soundEffect cheeseCollectedSound];
                    cheeseCollectedChe[i]=NO;
                    cheeseSprite[i].visible=NO;
                    cheeseSprite2[i].visible=NO;
                    cheeseCollectedScore+=1;
                    starSprite[i].visible=NO;
                    [hudLayer updateNoOfCheeseCollected:cheeseCollectedScore andMaxValue:[cheeseSetValue[motherLevel-1] intValue]];

                    [self createExplosionX:cheeseX-mValue y:cheeseY+mValue2];
                    break;
                }
            }
        }else{
            starSprite[i].visible=NO;
        }
    }
}

-(void)heroTrappedFunc{
    
    if(heroTrappedChe){
        heroTrappedCount+=1;
        if(heroTrappedCount==10){
            for (int i = 0; i < 20; i=i+1)
                heroPimpleSprite[i].position=ccp(-100,100);
            
            if(trappedTypeValue<=4){
                heroTrappedMove=1;
            }
            mouseDragSprite.visible=NO;
            if (trappedTypeValue == 1) {
                [self showAnimationWithMiceIdAndIndex:FTM_GIRL_MICE_ID andAnimationIndex:GIRL_KNIFE_ANIM];
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp([self getTrappingAnimatedSprite].position.x, 440)];
                [[self getTrappingAnimatedSprite] runAction:move];
            }
            else if (trappedTypeValue == 2) {
                heroTrappedSprite = [CCSprite spriteWithFile:@"gm_mist_0.png"];
                heroTrappedSprite.scale=0.5;
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(heroSprite.position.x +1.2 * heroForwardX, heroSprite.position.y+15);
                else
                    heroTrappedSprite.position = ccp(heroSprite.position.x - 1.2 * heroForwardX, heroSprite.position.y+15);
    
                heroTrappedSprite.scale=0.5;
                [self addChild:heroTrappedSprite z:1000];
                CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:ccp(heroTrappedSprite.position.x, 233)];
                [heroTrappedSprite runAction:move];
                
            }
            else{
                heroTrappedSprite = [CCSprite spriteWithSpriteFrameName:@"girl_trapped1.png"];
                heroTrappedSprite.scale=0.7;
                if(!forwardChe)
                    heroTrappedSprite.position = ccp(platformX, platformY+15);
                else
                    heroTrappedSprite.position = ccp(platformX+heroForwardX, platformY+15);
                [spriteSheet addChild:heroTrappedSprite];
                spriteSheet.zOrder=11;
                
                NSMutableArray *animFrames2 = [NSMutableArray array];
                for(int i = 1; i < 8; i++) {
                    CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_trapped%d.png",i]];
                    [animFrames2 addObject:frame];
                }
                CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
                [heroTrappedSprite runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:animation2]]];
            }
            heroSprite.visible=NO;
        }
        if(heroTrappedMove!=0){
            int fValue = (forwardChe?heroForwardX:0);
            CGFloat xPos=0;
            if(trappedTypeValue== 1){
                xPos=250;//heroSprite.position.x-(forwardChe?40:-40);
            }else if(trappedTypeValue== 2){
                xPos=464;
            }else if(trappedTypeValue== 3||trappedTypeValue == 4){
                xPos=heroSprite.position.x-(forwardChe?40:-40);
            }
            if (trappedTypeValue != 1 && trappedTypeValue != 2) {
                heroTrappedSprite.position = ccp(xPos,heroSprite.position.y-heroTrappedMove);
            }
            
            CGPoint copyHeroPosition = ccp(heroSprite.position.x-fValue, heroSprite.position.y-heroTrappedMove);
            [self setViewpointCenter:copyHeroPosition];
            if(trappedTypeValue == 1){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=440)
                    heroTrappedMove=0;
            }else if(trappedTypeValue == 2){
                heroTrappedMove+=1;
                if(heroSprite.position.y-heroTrappedMove<=265)
                    heroTrappedMove=0;
            }else if(trappedTypeValue == 3){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=397)
                    heroTrappedMove=0;
            }else if(trappedTypeValue == 4){
                heroTrappedMove+=2;
                if(heroSprite.position.y-heroTrappedMove<=233)
                    heroTrappedMove=0;
            }
        }
    }
}
-(void)heroWinFunc{
    if(mouseWinChe&&!gameFunc.trappedChe){
        heroWinCount+=1;
        if(heroWinCount==15){
            heroWinSprite = [CCSprite spriteWithSpriteFrameName:@"girl_win1.png"];
            heroWinSprite.scale=0.6;
            if(!forwardChe)
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            else
                heroWinSprite.position = ccp(platformX+30, platformY+5);
            [spriteSheet addChild:heroWinSprite];
            
            NSMutableArray *animFrames2 = [NSMutableArray array];
            for(int i = 0; i < 4; i++) {
                CCSpriteFrame *frame = [cache spriteFrameByName:[NSString stringWithFormat:@"girl_win%d.png",i+1]];
                [animFrames2 addObject:frame];
            }
            CCAnimation *animation2 = [CCAnimation animationWithSpriteFrames:animFrames2 delay:0.1f];
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
                platformX+=2.2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }else{
                platformX-=2.2;
                [gameFunc runningRender:platformX yPosition:platformY fChe:forwardChe];
                platformX=gameFunc.xPosition;
            }
        }
        if(gameFunc.stickyChe){
            heroSprite.visible=YES;
            heroRunSprite.visible=NO;
        }
        if(gameFunc.autoJumpChe){
            jumpPower = 4;
            jumpAngle=(forwardChe?120:20);
            jumpingChe=YES;
            runningChe=NO;
            heroRunSprite.visible=NO;
            heroSprite.visible=YES;
            if(gameFunc.stickyChe){
                gameFunc.stickyChe=NO;
                gameFunc.stickyCount=1;
            }
        }
        
        CGPoint copyHeroPosition = ccp(platformX, platformY);
        heroRunSprite.position=ccp(platformX,platformY);
        [self setViewpointCenter:copyHeroPosition];
        [self heroUpdateForwardPosFunc];
    }
}
-(void)heroAnimationFrameFunc{
    if(heroStandChe){
        [self heroAnimationFunc:heroStandAnimationCount/40 animationType:@"stand"];
        if(gameFunc.stickyChe)
            heroSprite.flipY=1;
        
        heroStandAnimationCount+=1;
        if(heroStandAnimationCount>=80){
            heroStandAnimationCount=0;
        }
    }
}

-(void)heroAnimationFunc:(int)fValue animationType:(NSString *)type{
    NSString *fStr=@"";
    if([type isEqualToString:@"jump"])
        fStr=[NSString stringWithFormat:@"girl_jump%d.png",fValue+1];
    else if([type isEqualToString:@"stand"])
        fStr=[NSString stringWithFormat:@"girl_stand%d.png",fValue+1];
    else if([type isEqualToString:@"win"])
        fStr=@"girl_win1.png";
    
    [spriteSheet removeChild:heroSprite cleanup:YES];
    heroSprite = [CCSprite spriteWithSpriteFrameName:fStr];
    heroSprite.position = ccp(platformX, platformY);
    heroSprite.scale=0.65;
    [spriteSheet addChild:heroSprite z:10];
    [self heroUpdateForwardPosFunc];
    
    if([type isEqualToString:@"jump"]){
        if(gameFunc.stickyChe){
            heroSprite.flipY=1;
        }
    }
        
}
-(void)heroUpdateForwardPosFunc{
    if(!forwardChe){
        heroSprite.flipX=0;
        heroRunSprite.flipX=0;
        heroSprite.position=ccp(platformX,platformY);
        heroRunSprite.position=ccp(platformX,platformY);
    }else{
        heroSprite.flipX=1;
        heroRunSprite.flipX=1;
        heroSprite.position=ccp(platformX+heroForwardX,platformY);
        heroRunSprite.position=ccp(platformX+heroForwardX,platformY);
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
            if(heroJumpingAnimationCount<=14)
                heroJumpingAnimationCount+=1;//(gameFunc.autoJumpChe?5:1);
            
        }else{
            CGFloat angle=jumpAngle;
            if(stickyJumpValue==1){
                if(!forwardChe)
                    angle=(angle>10?10:angle);
                else
                    angle=(angle<170?170:angle);
            }
            if(!safetyJumpChe && !gameFunc.autoJumpChe&&!gameFunc.autoJumpChe2&&!gameFunc.minimumJumpingChe&&!gameFunc.topHittingCollisionChe){
                jumpPower = activeVect.Length();
                forwardChe=(angle<90.0?NO:YES);
                [self heroUpdateForwardPosFunc];
            }
            if(gameFunc.minimumJumpingChe)
                jumpPower=1;
            
            jumpPower=(jumpPower>21.0?21.0:jumpPower);
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
            CGFloat yy=platformY+point.y-(stickyJumpValue==1?15:0);
            
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
            if(gameFunc.autoJumpChe){
                gameFunc.autoJumpChe=NO;
                gameFunc.stickyChe=NO;
            }
            
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
            if(gameFunc.visibleWindowChe&&visibleCount==0)
                visibleCount=1;
            
            if(stickyJumpValue==1)
                stickyJumpValue=0;
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
    int dValue=0;
    if(gameFunc.stickyChe){
        if(!forwardChe)
            angle=(angle>10?10:angle);
        else
            angle=(angle<170?170:angle);
        dValue=9;
    }
    
    jumpPower=(jumpPower>20.5?20.5:jumpPower);
    b2Vec2 impulse = b2Vec2(cosf(angle*3.14/180), sinf(angle*3.14/180));
    impulse *= (jumpPower/2.2)-0.6;
    
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    
    b2Vec2 velocity = heroBody->GetLinearVelocity();
    impulse *= -1;
    heroBody->ApplyLinearImpulse(impulse, heroBody->GetWorldCenter());
    velocity = b2Vec2(-velocity.x, velocity.y);
    
    for (int i = 0; i < 25&&!safetyJumpChe; i=i+1) {
        b2Vec2 point = [self getTrajectoryPoint:heroBody->GetWorldCenter() andStartVelocity:velocity andSteps:i*170 andAngle:angle];
        point = b2Vec2(-point.x, point.y);
        
        int lValue=(!forwardChe?35:-28);
        CGFloat xx=platformX+point.x+lValue+15;
        CGFloat yy=platformY+point.y+3-dValue;
        
        heroPimpleSprite[i].position=ccp(xx,yy);
    }
    if(!forwardChe)
        mouseDragSprite.position=ccp(platformX,platformY-11);
    else
        mouseDragSprite.position=ccp(platformX+heroForwardX,platformY-11);
    
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
        screenHeroPosY=position.y-60;
    else if(y>=_tileMap.mapSize.height-winSize.height/2)
        screenHeroPosY=(position.y-y)+winSize.height/2-60;
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/3);
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
                    mouseDragSprite.position=ccp(platformX+10,platformY-11);
                    mouseDragSprite.rotation=(180-0)-170;
                }else{
                    mouseDragSprite.rotation=(180-180)-170;
                    mouseDragSprite.position=ccp(platformX-10+heroForwardX,platformY-11);
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
                            runningChe=YES;
                            heroStandChe=NO;
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
            for (int i = 0; i < 25; i=i+1) {
                heroPimpleSprite[i].position=ccp(-100,100);
            }
            if(gameFunc.stickyChe){
                gameFunc.stickyChe=NO;
                gameFunc.movePlatformChe=NO;
                stickyJumpValue=1;
                gameFunc.stickyCount=1;
            }
        }else if(!jumpingChe&&!landingChe&&!firstRunningChe){
            if(runningChe){
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
        [[CCDirector sharedDirector] replaceScene:[GirlMouseEngine04 scene]];
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
    if (trappedTypeValue == 1) {
        [[self getTrappingAnimatedSprite] removeFromParentAndCleanup:YES];
    }
    [self endJumping:(platformX + gameFunc.xPosition)/2 yValue:gameFunc.yPosition];
    [self schedule:@selector(startRespawnTimer) interval:2];
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


-(void) dealloc {
    [super dealloc];
}


@end
