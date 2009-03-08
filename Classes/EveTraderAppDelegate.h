//
//  EveTraderAppDelegate.h
//  EveTrader
//
//  Created by jrk on 01.03.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EveTraderAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	IBOutlet UINavigationController *calcNavigationController;
	IBOutlet UINavigationController *profilesNavigationController;
	IBOutlet UINavigationController *aboutNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
