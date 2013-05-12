//
//  AppDelegate.h
//  Spider
//
//  Created by Auxano on 9/2/11.
//  Copyright ___ORGANIZATIONNAME___ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
