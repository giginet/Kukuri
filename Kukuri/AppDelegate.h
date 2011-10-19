//
//  AppDelegate.h
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright Kawaz 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
