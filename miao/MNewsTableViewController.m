//
//  MNewsTableViewController.m
//  miao
//
//  Created by 魏素宝 on 15/9/18.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MNewsTableViewController.h"
#import "AFNetworking.h"
#import "MNews.h"
#import "MNewsFrame.h"
#import "MNewsCell.h"
#import "MJRefresh.h"
#import "MNewsDetailController.h"
#import "ProgressHUD.h"
#import "MFavViewController.h"
#import "UMSocial.h"

@interface MNewsTableViewController ()
@property(nonatomic,copy) NSMutableArray *newsFrameArr;
@property(nonatomic,copy) NSString *favFilePath;
@property(nonatomic,strong) AFHTTPRequestOperationManager *mgr;
@end

@implementation MNewsTableViewController

-(NSMutableArray *)newsFrameArr{
    if (_newsFrameArr==nil) {
        _newsFrameArr=[NSMutableArray array];
    }
    return _newsFrameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //出现HUD进度条
    [ProgressHUD show:@""];
    //设置标题
    self.navigationItem.title=@"NEWS";
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
    NSString *favFilePath=[docPath stringByAppendingPathComponent:@"favNews.data"];
    self.favFilePath=favFilePath;
}

-(void)loadDataForFirstTime{
    [self.mgr GET:@"http://www.34miao.com/api/news/posts/20" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MNews *news=[MNews newsWithDict:dict];
            MNewsFrame *newsFrame=[[MNewsFrame alloc]init];
            newsFrame.news=news;
            [temArr addObject:newsFrame];
        }
        //赋值
        _newsFrameArr=temArr;
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
    [self.mgr GET:@"http://www.34miao.com/api/news/posts/20" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MNews *news=[MNews newsWithDict:dict];
            MNewsFrame *newsFrame=[[MNewsFrame alloc]init];
            newsFrame.news=news;
            [temArr addObject:newsFrame];
        }
        //把新数据赋值给模型数组
        _newsFrameArr=temArr;
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
    MNewsFrame *lastNewsF=[self.newsFrameArr lastObject];
    NSString *min_id=lastNewsF.news.n_id;
    NSString *more_old_data_url=[NSString stringWithFormat:@"http://www.34miao.com/api/news/old/20/%@",min_id];
    [self.mgr GET:more_old_data_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MNews *news=[MNews newsWithDict:dict];
            MNewsFrame *newsFrame=[[MNewsFrame alloc]init];
            newsFrame.news=news;
            [temArr addObject:newsFrame];
        }
        //把新数据添加到模型数组后面
        [_newsFrameArr addObjectsFromArray:temArr];
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
    return self.newsFrameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"news";
    MNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[MNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.newsFrame=self.newsFrameArr[indexPath.row];
    [cell.shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MNewsFrame *newsFrame=self.newsFrameArr[indexPath.row];
    return newsFrame.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MNewsDetailController *newsDetailVc=[[MNewsDetailController alloc]init];
    newsDetailVc.selectedNewsF=_newsFrameArr[indexPath.row];
    //push这个productDetailVc时隐藏tabbar
    newsDetailVc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:newsDetailVc animated:YES];
    //去除选中，即去除选中背景
    MNewsCell *cell=(MNewsCell *)[tableView cellForRowAtIndexPath:indexPath];
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
    NSMutableArray *favNewsArrM=[NSMutableArray array];
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.favFilePath]) {
        favNewsArrM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favFilePath];
    }
    //把productFrame模型添加在收藏数组中
    MNewsFrame *currentNewsF=_newsFrameArr[indexPath.row];
    //判断是否已经存在
    BOOL newsF_exist=NO;
    for (MNewsFrame *newsF in favNewsArrM) {
        if ([newsF.news.n_id isEqual:currentNewsF.news.n_id]) {
            newsF_exist=YES;
        }
    }
    if (!newsF_exist) {
        //最新的关注在最前面
        [favNewsArrM insertObject:currentNewsF atIndex:0];
        //持久化保存数组
        [NSKeyedArchiver archiveRootObject:favNewsArrM toFile:self.favFilePath];
    }
    //重新加载
    [tableView setEditing:NO animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出收藏的数组数据
    NSMutableArray *favNewsArrM=[NSMutableArray array];
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.favFilePath]) {
        favNewsArrM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favFilePath];
        //获取当前cell数据
        MNewsFrame *currentNewsF=_newsFrameArr[indexPath.row];
        //判断是否已经存在
        BOOL newsF_exist=NO;
        for (MNewsFrame *newsF in favNewsArrM) {
            if ([newsF.news.n_id isEqual:currentNewsF.news.n_id]) {
                newsF_exist=YES;
            }
        }
        //判断是否已经被收藏
        if (newsF_exist) {
            return @"已收藏";
        }else{
            return @"收藏";
        }
    }else{
        return @"收藏";
    }
}

-(void)clickShareBtn:(UIButton *)btn{
    MNewsCell *cell=(MNewsCell *)btn.superview.superview;
    NSString *textOri=[NSString stringWithFormat:@"【%@】%@",cell.newsFrame.news.n_title,cell.newsFrame.news.n_link];
    NSString *textSend=textOri;
    if (textOri.length>140) {
        textSend=[NSString stringWithFormat:@"【%@...】%@",[cell.newsFrame.news.n_title substringToIndex:(140-5-cell.newsFrame.news.n_link.length)],cell.newsFrame.news.n_link];
    }
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56076d6ae0f55a68f6006f1b" shareText:textSend shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cell.newsFrame.news.n_img_url]]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTwitter, nil] delegate:nil];
    //设置微信朋友圈分享的链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url=cell.newsFrame.news.n_link;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url=cell.newsFrame.news.n_link;
    //设置微信朋友圈分享的title
    [UMSocialData defaultData].extConfig.wechatSessionData.title=[NSString stringWithFormat:@"【%@】",cell.newsFrame.news.n_title];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title=[NSString stringWithFormat:@"【%@】",cell.newsFrame.news.n_title];
    
    //根据iOS9审核规则，隐藏没有安装客户端的分享
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline]];
}

@end
