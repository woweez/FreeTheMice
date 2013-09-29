//
//  ToolShedScreen.h
//  FreeTheMice
//
//  Created by Muhammad Kamran on 28/09/2013.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "SWScrollView.h"
@interface ToolShedScreen : CCLayer{

float scaleFactorX;
float scaleFactorY;
    SWScrollView *scrollView;
}
+(CCScene *) scene;

@end
