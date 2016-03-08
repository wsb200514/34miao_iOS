//
//  MDesignTableViewController.m
//  miao
//
//  Created by 魏素宝 on 15/9/18.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDesignTableViewController.h"
#import "AFNetworking.h"
#import "MDesign.h"
#import "MDesignFrame.h"
#import "MDesignCell.h"
#import "MJRefresh.h"
#import "MDesignDetailController.h"
#import "ProgressHUD.h"
#import "MFavViewController.h"
#import "UMSocial.h"

@interface MDesignTableViewController ()
@property(nonatomic,copy) NSMutableArray *designFrameArr;
@property(nonatomic,copy) NSString *favFilePath;
@property(nonatomic,strong) AFHTTPRequestOperationManager *mgr;
@end

@implementation MDesignTableViewController
-(NSMutableArray *)designFrameArr{
    if (_designFrameArr==nil) {
        _designFrameArr=[NSMutableArray array];
    }
    return _designFrameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //出现HUD进度条
    [ProgressHUD show:@""];
    //设置标题
    self.navigationItem.title=@"DESIGN";
    self.navigationController.navigationBar.titleTextAttributes=[[NSDictionary alloc]initWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1],NSForegroundColorAttributeName, nil];
    //设置返回键
    UIBarButtonItem *backBtnItem=[[UIBarButtonItem alloc]init];
    backBtnItem.title=@"";
    self.navigationItem.backBarButtonItem=backBtnItem;
    
    //设置按钮颜色
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.92 green:0.54 blue:0.55 alpha:1];
    
    //设置左右边收藏、关于按钮
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyFav)];
    
    //定义mgr
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes=[mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    self.mgr=mgr;
    //获取数据
    [self loadDataForFirstTime];
    //下拉刷新数据
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshForMoreNewData)];
    //上拉加载更多老数据
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(refreshForMoreOldData)];
    
    //获取收藏data文件地址
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *favFilePath=[docPath stringByAppendingPathComponent:@"favDesign.data"];
    self.favFilePath=favFilePath;
}

-(void)loadDataForFirstTime{
    [self.mgr GET:@"http://www.34miao.com/api/design/posts/20" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MDesign *design=[MDesign designWithDict:dict];
            MDesignFrame *designFrame=[[MDesignFrame alloc]init];
            designFrame.design=design;
            [temArr addObject:designFrame];
        }
        //赋值
        _designFrameArr=temArr;
        //隐藏HUD
        [ProgressHUD dismiss];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        UIAlertView *RequestFailure=[[UIAlertView alloc]initWithTitle:@"请求数据失败" message:@"没请求到数据，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [RequestFailure show];
    }];
}

-(void)refreshForMoreNewData{
    [self.mgr GET:@"http://www.34miao.com/api/design/posts/20" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MDesign *design=[MDesign designWithDict:dict];
            MDesignFrame *designFrame=[[MDesignFrame alloc]init];
            designFrame.design=design;
            [temArr addObject:designFrame];
        }
        //把新数据赋值给模型数组
        _designFrameArr=temArr;
        //重新加载数据
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        UIAlertView *RequestFailure=[[UIAlertView alloc]initWithTitle:@"请求数据失败" message:@"没请求到数据，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [RequestFailure show];
    }];
}

-(void)refreshForMoreOldData{
    MDesignFrame *lastDesignF=[self.designFrameArr lastObject];
    NSString *min_id=lastDesignF.design.design_id;
    NSString *more_old_data_url=[NSString stringWithFormat:@"http://www.34miao.com/api/design/old/20/%@",min_id];
    [self.mgr GET:more_old_data_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MDesign *design=[MDesign designWithDict:dict];
            MDesignFrame *designFrame=[[MDesignFrame alloc]init];
            designFrame.design=design;
            [temArr addObject:designFrame];
        }
        //把新数据添加到模型数组后面
        [_designFrameArr addObjectsFromArray:temArr];
        //重新加载数据
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        UIAlertView *RequestFailure=[[UIAlertView alloc]initWithTitle:@"请求数据失败" message:@"没请求到数据，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [RequestFailure show];
    }];
}

//-(void)showInfo{
//    [self.navigationController pushViewController:[[MInfoViewController alloc] init] animated:YES];
//}

-(void)showMyFav{
    [self.navigationController pushViewController:[[MFavViewController alloc] init] animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.designFrameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"design";
    MDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[MDesignCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.designFrame=self.designFrameArr[indexPath.row];
    [cell.shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDesignFrame *designFrame=self.designFrameArr[indexPath.row];
    return designFrame.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDesignDetailController *designDetailVc=[[MDesignDetailController alloc]init];
    designDetailVc.selectedDesignF=_designFrameArr[indexPath.row];
    //push这个productDetailVc时隐藏tabbar
    designDetailVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:designDetailVc animated:YES];
    //去除选中，即去除选中背景
    MDesignCell *cell=(MDesignCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected=NO;
}

//设置cell可编辑（收藏）
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//设置cell编辑模式，delete
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//设置cell编辑后的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出收藏的数组数据
    NSMutableArray *favDesignArrM=[NSMutableArray array];
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.favFilePath]) {
        favDesignArrM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favFilePath];
    }
    //把productFrame模型添加在收藏数组中
    MDesignFrame *currentDesignF=_designFrameArr[indexPath.row];
    //判断是否已经存在
    BOOL designF_exist=NO;
    for (MDesignFrame *designF in favDesignArrM) {
        if ([designF.design.design_id isEqual:currentDesignF.design.design_id]) {
            designF_exist=YES;
        }
    }
    if (!designF_exist) {
        //最新的关注在最前面
        [favDesignArrM insertObject:currentDesignF atIndex:0];
        //持久化保存数组
        [NSKeyedArchiver archiveRootObject:favDesignArrM toFile:self.favFilePath];
    }
    //重新加载
    [tableView setEditing:NO animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出收藏的数组数据
    NSMutableArray *favDesignArrM=[NSMutableArray array];
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.favFilePath]) {
        favDesignArrM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favFilePath];
        //获取当前cell数据
        MDesignFrame *currentDesignF=_designFrameArr[indexPath.row];
        //判断是否已经存在
        BOOL designF_exist=NO;
        for (MDesignFrame *designF in favDesignArrM) {
            if ([designF.design.design_id isEqual:currentDesignF.design.design_id]) {
                designF_exist=YES;
            }
        }
        //判断是否已经被收藏
        if (designF_exist) {
            return @"已收藏";
        }else{
            return @"收藏";
        }
    }else{
        return @"收藏";
    }
}

-(void)clickShareBtn:(UIButton *)btn{
    MDesignCell *cell=(MDesignCell *)btn.superview.superview;
    NSString *textOri=[NSString stringWithFormat:@"【%@】%@",cell.designFrame.design.design_title,cell.designFrame.design.design_link];
    NSString *textSend=textOri;
    if (textOri.length>140) {
        textSend=[NSString stringWithFormat:@"【%@...】%@",[cell.designFrame.design.design_title substringToIndex:(140-5-cell.designFrame.design.design_link.length)],cell.designFrame.design.design_link];
    }
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56076d6ae0f55a68f6006f1b" shareText:textSend shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.designFrame.design.design_img_url]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTwitter, nil] delegate:nil];
    //设置微信朋友圈分享的链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url=cell.designFrame.design.design_link;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url=cell.designFrame.design.design_link;
    //设置微信朋友圈分享的title
    [UMSocialData defaultData].extConfig.wechatSessionData.title=[NSString stringWithFormat:@"【%@】",cell.designFrame.design.design_title];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title=[NSString stringWithFormat:@"【%@】",cell.designFrame.design.design_title];
    
    //根据iOS9审核规则，隐藏没有安装客户端的分享
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline]];
}


@end
