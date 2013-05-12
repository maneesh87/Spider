//
//  HelloWorldLayer.m
//  Spider
//
//  Created by Maneesh on 9/2/11.
//  
//


// Import the interfaces
#import "HelloWorldLayer.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


float velocity=150.0;

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
	
      [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	  heroSprite = [CCSprite spriteWithFile:@"Blue.png"];
      heroSprite.tag=1;
      heroSprite.position=CGPointMake(480/2, 320/2);
      [self addChild:heroSprite z:1];

    enemySprites=[[NSMutableArray alloc] init];
        
 /*   for (int i=0; i<8; i++) {
        CCSprite *enemy=[CCSprite spriteWithFile:@"Green.png"];
        [enemySprites addObject:enemy];
        CGPoint enemyPoint=CGPointMake(arc4random()%480, arc4random()%320);
        CGPoint openGLEnemyPoint=[self convertToNodeSpace:enemyPoint];
        enemy.position=openGLEnemyPoint;
        [self addChild:enemy];
        }*/
        
        CCProgressTimer* timer = [CCProgressTimer progressWithFile:@"Red.png"]; 
        timer.type = kCCProgressTimerTypeRadialCCW; 
        timer.percentage = 0;
        [self addChild:timer z:1 tag:1099];
        
        
        
        
        
        // For first zombie
        [self step:0.0];
        // For creating zombie
        [self schedule: @selector(step:) interval: 1.0];  
        // For Removing zombie
        [self schedule:@selector(removeEnemy:) interval:2];
        // For moving zombie to kill
        [self schedule: @selector(goToHero:) interval: 0.1];  
      
       
    //[self step:nil];   
        
    }
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    [enemySprites release];
    [heroSprite cleanup];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}


-(void) goToHero:  (ccTime) delta
{
    for (int i=0; i<[enemySprites count]; i++) {
        CCSprite *enemy=[enemySprites objectAtIndex:i];

        CGRect rect1 = [self positionRect:enemy];
		CGRect rect2 = [self positionRect:heroSprite];
        
        if (!CGRectIsNull(CGRectIntersection(rect1, rect2))) {
            NSLog(@"Game Over");
        }
        
        int offRealX = enemy.position.x - heroSprite.position.x;
        int offRealY = enemy.position.y - heroSprite.position.y;
        float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
        float time=length/velocity;
        
        float angle=atan2(offRealX,offRealY);
             
        NSLog(@"angle %f",angle);
        
        id actionMove = [CCMoveTo actionWithDuration:time position:heroSprite.position];
        id rotateAction = [CCRotateTo actionWithDuration:0.2 angle:RADIANS_TO_DEGREES(angle)];
        id spawAction = [CCSpawn actions:actionMove, rotateAction, nil];
        
        [enemy stopAllActions];
        [enemy runAction:spawAction];
    }
}


-(CGRect) positionRect: (CCSprite*)mySprite
{
	CGSize contentSize = [mySprite contentSize];
	CGPoint contentPosition = [mySprite position];
	CGRect result = CGRectOffset(CGRectMake(0, 0, contentSize.width, contentSize.height), contentPosition.x-contentSize.width/2, contentPosition.y-contentSize.height/2);
	return result;
}

-(void) step: (ccTime) delta
{
    if ([enemySprites count]>8) {
        return;
    }
    
    CCSprite *enemy=[CCSprite spriteWithFile:@"left.png"];
    CCSprite *enemy2=[CCSprite spriteWithFile:@"left.png"];
    [enemySprites addObject:enemy];
//  [enemySprites addObject:enemy2];
    
    CGPoint enemyPoint=CGPointMake(arc4random()%1024, arc4random()%768);
    
    CGPoint openGLEnemyPoint=[self convertToNodeSpace:enemyPoint];
    enemy.position=openGLEnemyPoint;
    
    enemyPoint=CGPointMake(arc4random()%1024, arc4random()%768);
    openGLEnemyPoint=[self convertToNodeSpace:enemyPoint];
    enemy2.position=openGLEnemyPoint;
    
    [self addChild:enemy];
//  [self addChild:enemy2];
    
    int offRealX = enemy.position.x - heroSprite.position.x;
    int offRealY = enemy.position.y - heroSprite.position.y;
    
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float time=length/velocity;
    
    id actionMove = [CCMoveTo actionWithDuration:time
                                        position:heroSprite.position];
    
    [enemy stopAllActions];
    [enemy runAction:[CCSequence actions:actionMove,nil]];
}


-(void) removeEnemy: (ccTime) delta
{
    CCSprite *deadEnemy=[enemySprites objectAtIndex:0];
    [enemySprites removeObjectAtIndex:0];
    [deadEnemy setTexture:[[CCTextureCache sharedTextureCache] addImage:@"Red.png"]]; 
    id action1 = [CCFadeOut actionWithDuration:1.0];
    [deadEnemy stopAllActions];
    [deadEnemy runAction:action1];
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
     CGPoint touchPoint=[touch locationInView:[touch view]];
     NSLog(@"touch began called %f %f",touchPoint.x,touchPoint.y);
     CGPoint point = [self convertTouchToNodeSpace:touch];
     heroSprite.position=point;
     return YES;    
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint point = [self convertTouchToNodeSpace:touch];
    heroSprite.position=point;    
}

@end
