//
//  MProductsTableViewController.m
//  miao
//
//  Created by 魏素宝 on 15/9/18.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MProductsTableViewController.h"
#import "AFNetworking.h"
#import "MProduct.h"
#import "MProductFrame.h"
#import "MProductCell.h"
#import "MJRefresh.h"
#import "MProductDetailController.h"
#import "ProgressHUD.h"
#import "MInfoTableViewController.h"
#import "MFavViewController.h"
#import "UMSocial.h"

@interface MProductsTableViewController ()
@property(nonatomic,copy) NSMutableArray *productFrameArr;
@property(nonatomic,copy) NSString *favFilePath;
@property(nonatomic,strong) AFHTTPRequestOperationManager *mgr;
@end

@implementation MProductsTableViewController

-(NSMutableArray *)productFrameArr{
    if (_productFrameArr==nil) {
        _productFrameArr=[NSMutableArray array];
    }
    return _productFrameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //出现HUD进度条
    [ProgressHUD show:@""];
    //设置标题
    self.navigationItem.title=@"PRODUCTS";
    self.navigationController.navigationBar.titleTextAttributes=[[NSDictionary alloc]initWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1],NSForegroundColorAttributeName, nil];
    //设置左右边收藏、关于按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showInfo)];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fav.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyFav)];
    //设置按钮颜色
    self.navigationController.navigationBar.tintColor=[UIColor colorWithRed:0.92 green:0.54 blue:0.55 alpha:1];
    //设置返回键
    UIBarButtonItem *backBtnItem=[[UIBarButtonItem alloc]init];
    backBtnItem.title=@"";
    self.navigationItem.backBarButtonItem=backBtnItem;
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
    NSString *favFilePath=[docPath stringByAppendingPathComponent:@"favProducts.data"];
    self.favFilePath=favFilePath;
}

-(void)loadDataForFirstTime{
    [self.mgr GET:@"http://www.34miao.com/api/product/posts/20" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MProduct *product=[MProduct productWithDict:dict];
            MProductFrame *productFrame=[[MProductFrame alloc]init];
            productFrame.product=product;
            [temArr addObject:productFrame];
        }
        //赋值
        _productFrameArr=temArr;
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
    [self.mgr GET:@"http://www.34miao.com/api/product/posts/20" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MProduct *product=[MProduct productWithDict:dict];
            MProductFrame *productFrame=[[MProductFrame alloc]init];
            productFrame.product=product;
            [temArr addObject:productFrame];
        }
        //把新数据赋值给模型数组
        _productFrameArr=temArr;
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
    MProductFrame *lastProductF=[self.productFrameArr lastObject];
    NSString *min_id=lastProductF.product.p_id;
    NSString *more_old_data_url=[NSString stringWithFormat:@"http://www.34miao.com/api/product/old/20/%@",min_id];
    [self.mgr GET:more_old_data_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseObjectArray=(NSArray *)responseObject;
        NSMutableArray *temArr=[NSMutableArray array];
        for (NSDictionary *dict in responseObjectArray) {
            MProduct *product=[MProduct productWithDict:dict];
            MProductFrame *productFrame=[[MProductFrame alloc]init];
            productFrame.product=product;
            [temArr addObject:productFrame];
        }
        //把新数据添加到模型数组后面
        [_productFrameArr addObjectsFromArray:temArr];
        //重新加载数据
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.footer endRefreshing];
        UIAlertView *RequestFailure=[[UIAlertView alloc]initWithTitle:@"请求数据失败" message:@"没请求到数据，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [RequestFailure show];
    }];
}

-(void)showInfo{
    MInfoTableViewController *infoVc=[[MInfoTableViewController alloc] init];
    infoVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:infoVc animated:YES];
}

-(void)showMyFav{
    [self.navigationController pushViewController:[[MFavViewController alloc] init] animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productFrameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"product";
    MProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[MProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.productFrame=self.productFrameArr[indexPath.row];
    [cell.shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MProductFrame *productFrame=self.productFrameArr[indexPath.row];
    return productFrame.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MProductDetailController *productDetailVc=[[MProductDetailController alloc]init];
    productDetailVc.selectedProductF=_productFrameArr[indexPath.row];
    //push这个productDetailVc时隐藏tabbar
    productDetailVc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:productDetailVc animated:YES];
    //去除选中，即去除选中背景
    MProductCell *cell=(MProductCell *)[tableView cellForRowAtIndexPath:indexPath];
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
    NSMutableArray *favProductArrM=[NSMutableArray array];
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.favFilePath]) {
        favProductArrM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favFilePath];
    }
    //把productFrame模型添加在收藏数组中
    MProductFrame *currentProductF=_productFrameArr[indexPath.row];
    //判断是否已经存在
    BOOL productF_exist=NO;
    for (MProductFrame *productF in favProductArrM) {
        if ([productF.product.p_id isEqual:currentProductF.product.p_id]) {
            productF_exist=YES;
        }
    }
    if (!productF_exist) {
        //最新的关注在最前面
        [favProductArrM insertObject:currentProductF atIndex:0];
        //持久化保存数组
        [NSKeyedArchiver archiveRootObject:favProductArrM toFile:self.favFilePath];
    }
    //重新加载
    [tableView setEditing:NO animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出收藏的数组数据
    NSMutableArray *favProductArrM=[NSMutableArray array];
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:self.favFilePath]) {
        favProductArrM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favFilePath];
        //获取当前cell数据
        MProductFrame *currentProductF=_productFrameArr[indexPath.row];
        //判断是否已经存在
        BOOL productF_exist=NO;
        for (MProductFrame *productF in favProductArrM) {
            if ([productF.product.p_id isEqual:currentProductF.product.p_id]) {
                productF_exist=YES;
            }
        }
        //判断是否已经被收藏
        if (productF_exist) {
            return @"已收藏";
        }else{
            return @"收藏";
        }
    }else{
        return @"收藏";
    }
}

-(void)clickShareBtn:(UIButton *)btn{
    MProductCell *cell=(MProductCell *)btn.superview.superview;
    NSString *textOri=[NSString stringWithFormat:@"【%@】%@ %@",cell.productFrame.product.p_name,cell.productFrame.product.p_desc,cell.productFrame.product.p_source_link];
    NSString *textSend=textOri;
    if (textOri.length>140) {
        textSend=[NSString stringWithFormat:@"【%@】%@... %@",cell.productFrame.product.p_name,[cell.productFrame.product.p_desc substringToIndex:(140-5-cell.productFrame.product.p_name.length-cell.productFrame.product.p_source_link.length)],cell.productFrame.product.p_source_link];
    }
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56076d6ae0f55a68f6006f1b" shareText:textSend shareImage:[UIImage imageNamed:@"Icon-1024.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToTwitter, nil] delegate:nil];
    //设置微信朋友圈分享的链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url=cell.productFrame.product.p_source_link;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url=cell.productFrame.product.p_source_link;
    //设置微信朋友圈分享的title
    [UMSocialData defaultData].extConfig.wechatSessionData.title=[NSString stringWithFormat:@"【%@】%@",cell.productFrame.product.p_name,cell.productFrame.product.p_desc];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title=[NSString stringWithFormat:@"【%@】%@",cell.productFrame.product.p_name,cell.productFrame.product.p_desc];
    
    //根据iOS9审核规则，隐藏没有安装客户端的分享
     [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline]];
}

@end
