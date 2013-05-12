//
//  HelloWorldLayer.h
//  Spider
//
//  Created by Auxano on 9/2/11.
//  Copyright ___ORGANIZATIONNAME___ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer<CCTargetedTouchDelegate>
{
    CCSprite *heroSprite;
    NSMutableArray *enemySprites;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(CGRect) positionRect: (CCSprite*)mySprite;
-(void) step: (ccTime) delta;
@end
