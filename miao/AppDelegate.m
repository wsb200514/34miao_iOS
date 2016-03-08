//
//  AppDelegate.m
//  miao
//
//  Created by 魏素宝 on 15/9/17.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import "AppDelegate.h"
#import "MTabBarViewController.h"
//友盟社会化分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialTwitterHandler.h"
//错误日志收集
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController=[[MTabBarViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    //设置友盟社会化分享组件
    [UMSocialData setAppKey:@"56076d6ae0f55a68f6006f1b"];
    
    //设置sina微博分享
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //设置微信分享，设置后才会显示分享按钮
    [UMSocialWechatHandler setWXAppId:@"wxf9c077bd1a4d958b" appSecret:@"95dd03f335d169a9dad8975d72593491" url:nil];
    
    //设置twitter分享
    [UMSocialTwitterHandler openTwitter];
    
    //错误日志设置
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}

//设置sina微博和微信的分享需要的回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
