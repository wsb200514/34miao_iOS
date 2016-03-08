//
//  MInfoTableViewController.m
//  miao
//
//  Created by 魏素宝 on 15/9/23.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MInfoTableViewController.h"
#import "SDImageCache.h"
#import "ProgressHUD.h"

@interface MInfoTableViewController ()

@end

@implementation MInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加header
    UIView *infoHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    UIImageView *logoImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Icon.png"]];
    logoImgView.frame=CGRectMake((self.view.frame.size.width-60)*0.5, 30, 60, 60);
    logoImgView.layer.cornerRadius=4;
    logoImgView.layer.masksToBounds=YES;
    [infoHeaderView addSubview:logoImgView];
    
    UILabel *sloganL=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImgView.frame)+12, self.view.frame.size.width, 20)];
    sloganL.text=@"三四秒 IT精简阅读平台";
    sloganL.font=[UIFont systemFontOfSize:12];
    sloganL.textColor=[UIColor grayColor];
    sloganL.textAlignment=NSTextAlignmentCenter;
    [infoHeaderView addSubview:sloganL];
    
    UILabel *versionL=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sloganL.frame)+2, self.view.frame.size.width, 20)];
    versionL.text=@"version 1.0";
    versionL.font=[UIFont systemFontOfSize:12];
    versionL.textColor=[UIColor grayColor];
    versionL.textAlignment=NSTextAlignmentCenter;
    [infoHeaderView addSubview:versionL];
    
    self.tableView.tableHeaderView=infoHeaderView;
    
    //设置footer
    UIView *infoFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200-88-64)];
    
    UILabel *copyrightL=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(infoFooterView.frame)-30, self.view.frame.size.width, 20)];
    copyrightL.text=@"© 版权归 34miao.com 所有";
    copyrightL.font=[UIFont systemFontOfSize:12];
    copyrightL.textAlignment=NSTextAlignmentCenter;
    copyrightL.textColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    [infoFooterView addSubview:copyrightL];
    
    self.tableView.tableFooterView=infoFooterView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID=@"info";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.row==0) {
        cell.textLabel.text=@"清除图片缓存";
        //计算显示缓存大小,单位M
        float cacheImgSize=[[SDImageCache sharedImageCache]getSize]/1024/1024;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.1f M",cacheImgSize];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
        cell.imageView.image=[UIImage imageNamed:@"trash.png"];
    }else{
        cell.textLabel.text=@"评价或者反馈";
        cell.imageView.image=[UIImage imageNamed:@"feedback.png"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.5];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [ProgressHUD show:@""];
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            [ProgressHUD dismiss];
            [tableView reloadData];
        }];
    }else{
        NSString *appStoreUrl= [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"1042582193"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }
}


@end
