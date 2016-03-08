//
//  MTabBarViewController.m
//  miao
//
//  Created by 魏素宝 on 15/9/17.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import "MTabBarViewController.h"
#import "MProductsNavController.h"
#import "MNewsNavController.h"
#import "MDesignNavController.h"
#import "MDevNavController.h"
#import "MMarketingNavController.h"
#import "MProductsTableViewController.h"
#import "MNewsTableViewController.h"
#import "MDesignTableViewController.h"
#import "MDevTableViewController.h"
#import "MMarketingTableViewController.h"

@interface MTabBarViewController ()

@end

@implementation MTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置几个控制器
    MProductsNavController *productsNav=[[MProductsNavController alloc]initWithRootViewController:[[MProductsTableViewController alloc]init]];
    productsNav.tabBarItem.title=@"Products";
    productsNav.tabBarItem.image=[UIImage imageNamed:@"products.png"];
    productsNav.navigationBar.barTintColor=[UIColor whiteColor];
    
    MNewsNavController *newsNav=[[MNewsNavController alloc] initWithRootViewController:[[MNewsTableViewController alloc]init]];
    newsNav.tabBarItem.title=@"News";
    newsNav.tabBarItem.image=[UIImage imageNamed:@"news.png"];
    newsNav.navigationBar.barTintColor=[UIColor whiteColor];
    
    MDesignNavController *designNav=[[MDesignNavController alloc]initWithRootViewController:[[MDesignTableViewController alloc]init]];
    designNav.tabBarItem.title=@"Design";
    designNav.tabBarItem.image=[UIImage imageNamed:@"design.png"];
    designNav.navigationBar.barTintColor=[UIColor whiteColor];
    
    MDevNavController *devNav=[[MDevNavController alloc]initWithRootViewController:[[MDevTableViewController alloc]init]];
    devNav.tabBarItem.title=@"Development";
    devNav.tabBarItem.image=[UIImage imageNamed:@"dev.png"];
    devNav.navigationBar.barTintColor=[UIColor whiteColor];
    
    MMarketingNavController *marketingNav=[[MMarketingNavController alloc]initWithRootViewController:[[MMarketingTableViewController alloc]init]];
    marketingNav.tabBarItem.title=@"Marketing";
    marketingNav.tabBarItem.image=[UIImage imageNamed:@"marketing.png"];
    marketingNav.navigationBar.barTintColor=[UIColor whiteColor];
    
    //设置tabbaritem选中的颜色
    self.tabBar.tintColor=[UIColor colorWithRed:0.92 green:0.39 blue:0.39 alpha:1];
    self.tabBar.barTintColor=[UIColor whiteColor];
    self.viewControllers=[NSArray arrayWithObjects:productsNav,newsNav,designNav,devNav,marketingNav, nil];
}

@end
