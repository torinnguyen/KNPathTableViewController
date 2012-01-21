//
//  KNAppDelegate.m
//  KNPathTableViewControllerDemo
//
//  Created by Kent Nguyen on 12/1/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "KNAppDelegate.h"
#import "KNFirstViewController.h"
#import "KNSecondViewController.h"
#import "KNThirdViewController.h"
#import "TNFourthViewController.h"

@implementation KNAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Basic demo
  KNFirstViewController * viewController1 = [[KNFirstViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController * uinav1 = [[UINavigationController alloc] initWithRootViewController:viewController1];

  // Section demo
  KNThirdViewController * viewController3 = [[KNThirdViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController * uinav3 = [[UINavigationController alloc] initWithRootViewController:viewController3];

  // NIB demo
  TNFourthViewController * viewController4 = [[TNFourthViewController alloc] init];
  UINavigationController * uinav4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
  viewController4.title = @"NIB Demo";
  viewController4.tabBarItem.image = [UIImage imageNamed:@"first"];

  // About tab
  UIViewController * viewController2 = [[KNSecondViewController alloc] initWithNibName:@"KNSecondViewController" bundle:nil];
  UINavigationController * uinav2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

  // The tab bar
  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:uinav1, uinav3, uinav4, uinav2, nil];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
