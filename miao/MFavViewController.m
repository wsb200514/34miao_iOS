//
//  MFavViewController.m
//  miao
//
//  Created by 魏素宝 on 15/9/25.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MFavViewController.h"
#import "MProductCell.h"
#import "MProductFrame.h"
#import "MProductDetailController.h"
#import "MNewsCell.h"
#import "MNewsFrame.h"
#import "MNewsDetailController.h"
#import "MDesignCell.h"
#import "MDesignFrame.h"
#import "MDesignDetailController.h"
#import "MDevCell.h"
#import "MDevFrame.h"
#import "MDevDetailController.h"
#import "MMarketingCell.h"
#import "MMarketingFrame.h"
#import "MMarketingDetailController.h"

#define MenuBtnWidth self.view.frame.size.width*0.2
#define MenuBtnHeight 30

@interface MFavViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak) UIScrollView *menuScrollView;
@property(nonatomic,weak) UIScrollView *contentScrollView;
@property(nonatomic,copy) NSMutableArray *favProductArr;
@property(nonatomic,copy) NSMutableArray *favNewsArr;
@property(nonatomic,copy) NSMutableArray *favDesignArr;
@property(nonatomic,copy) NSMutableArray *favDevArr;
@property(nonatomic,copy) NSMutableArray *favMarketingArr;

@property(nonatomic,copy) NSString *favProductsFilePath;
@property(nonatomic,copy) NSString *favNewsFilePath;
@property(nonatomic,copy) NSString *favDesignFilePath;
@property(nonatomic,copy) NSString *favDevFilePath;
@property(nonatomic,copy) NSString *favMarketingFilePath;

@property(nonatomic,copy) NSString *docPath;
@property(nonatomic,strong) NSFileManager *fileMgr;

@property(nonatomic,copy) NSMutableArray *contentTableViewArrM;
@end

@implementation MFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    //设置标题
    self.navigationItem.title=@"FAVORITE";
    self.navigationController.navigationBar.titleTextAttributes=[[NSDictionary alloc]initWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1],NSForegroundColorAttributeName, nil];
    
    //设置返回键
    UIBarButtonItem *backBtnItem=[[UIBarButtonItem alloc]init];
    backBtnItem.title=@"";
    self.navigationItem.backBarButtonItem=backBtnItem;
    
    //获取收藏data文件地址
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    self.fileMgr=fileMgr;
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.docPath=docPath;
    
    //取得存储文件路径
    NSString *favProductsFilePath=[self.docPath stringByAppendingPathComponent:@"favProducts.data"];
    self.favProductsFilePath=favProductsFilePath;
    
    NSString *favNewsFilePath=[self.docPath stringByAppendingPathComponent:@"favNews.data"];
    self.favNewsFilePath=favNewsFilePath;
    
    NSString *favDesignFilePath=[self.docPath stringByAppendingPathComponent:@"favDesign.data"];
    self.favDesignFilePath=favDesignFilePath;
    
    NSString *favDevFilePath=[self.docPath stringByAppendingPathComponent:@"favDev.data"];
    self.favDevFilePath=favDevFilePath;
    
    NSString *favMarketingFilePath=[self.docPath stringByAppendingPathComponent:@"favMarketing.data"];
    self.favMarketingFilePath=favMarketingFilePath;
}

-(void)showNoFavDataTips:(UITableView *)tableview{
    UILabel *noDataLabel=[[UILabel alloc]init];
    noDataLabel.text=@"阅读时左滑点击收藏";
    noDataLabel.font=[UIFont systemFontOfSize:12];
    noDataLabel.textAlignment=NSTextAlignmentCenter;
    noDataLabel.textColor=[UIColor whiteColor];
    noDataLabel.backgroundColor=[UIColor colorWithRed:0.92 green:0.54 blue:0.55 alpha:1];
    noDataLabel.layer.cornerRadius=4;
    noDataLabel.layer.masksToBounds=YES;
    CGFloat noDataLabelW=150;
    CGFloat noDataLabelH=30;
    CGFloat noDataLabelX=([UIScreen mainScreen].bounds.size.width-noDataLabelW)*0.5;
    CGFloat noDataLabelY=noDataLabelH*2;
    noDataLabel.frame=CGRectMake(noDataLabelX, noDataLabelY, noDataLabelW, noDataLabelH);
    //先取消之前的，再添加新的
    [noDataLabel removeFromSuperview];
    [tableview addSubview:noDataLabel];
}

-(void)clickDeleteFavBtn{
    int i=(int)((self.contentScrollView.contentOffset.x+self.view.bounds.size.width*0.5)/(int)self.view.bounds.size.width);
    UITableView *tempTableView=self.contentTableViewArrM[i];
    if (tempTableView.editing) {
        [tempTableView setEditing:NO animated:YES];
    }else{
        [tempTableView setEditing:YES animated:YES];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    //初始化menu，在viewDidLoad里面的frame计算不准确，所以在此初始化
    UIScrollView *menuScrollView=[[UIScrollView alloc]init];
    menuScrollView.frame=CGRectMake(0, 64, self.view.bounds.size.width, MenuBtnHeight);
    menuScrollView.contentSize=CGSizeMake(MenuBtnWidth*5, MenuBtnHeight);
    menuScrollView.bounces=NO;
    menuScrollView.showsHorizontalScrollIndicator=NO;
    self.menuScrollView=menuScrollView;
    
    for (int i=0; i<5; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        switch (i) {
            case 0:
                [btn setTitle:@"产品" forState:UIControlStateNormal];
                btn.selected=YES;
                break;
            case 1:
                [btn setTitle:@"新闻" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"设计" forState:UIControlStateNormal];
                break;
            case 3:
                [btn setTitle:@"开发" forState:UIControlStateNormal];
                break;
            case 4:
                [btn setTitle:@"营销" forState:UIControlStateNormal];
                break;
        }
        [btn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.92 green:0.39 blue:0.39 alpha:1] forState:UIControlStateSelected];
        btn.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        [btn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        btn.tag=i;
        [btn addTarget:self action:@selector(didClickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(MenuBtnWidth*i, 0, MenuBtnWidth, MenuBtnHeight);
        [self.menuScrollView addSubview:btn];
    }
    [self.view addSubview:menuScrollView];
    
    //初始化内容
    UIScrollView *contentScrollView=[[UIScrollView alloc]init];
    contentScrollView.frame=CGRectMake(0, 94, self.view.bounds.size.width, self.view.bounds.size.height-94);
    contentScrollView.contentSize=CGSizeMake(self.view.frame.size.width*5, self.view.bounds.size.height-94);
    contentScrollView.bounces=NO;
    contentScrollView.showsHorizontalScrollIndicator=NO;
    contentScrollView.pagingEnabled=YES;
    contentScrollView.backgroundColor=[UIColor yellowColor];
    contentScrollView.delegate=self;
    self.contentScrollView=contentScrollView;
    
    NSMutableArray *tempTableViewArrM=[NSMutableArray array];
    for (int i=0; i<5; i++) {
        UITableView *contentTableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, self.view.bounds.size.height-94)];
        //去除下面空白的横线
        contentTableView.tableFooterView=[[UIView alloc]init];
        contentTableView.tag=i;
        contentTableView.dataSource=self;
        contentTableView.delegate=self;
        
        //设置右边按钮
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"delete.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickDeleteFavBtn)];
        
        [tempTableViewArrM addObject:contentTableView];
        [self.contentScrollView addSubview:contentTableView];
    }
    NSMutableArray *contentTableViewArrM=[NSMutableArray array];
    contentTableViewArrM=tempTableViewArrM;
    self.contentTableViewArrM=contentTableViewArrM;
    
    _favProductArr=[self setArrayAndTitleWithFile:self.favProductsFilePath frameArr:_favProductArr onView:contentTableViewArrM[0]];
    _favNewsArr=[self setArrayAndTitleWithFile:self.favNewsFilePath frameArr:_favNewsArr onView:contentTableViewArrM[1]];
    _favDesignArr=[self setArrayAndTitleWithFile:self.favDesignFilePath frameArr:_favDesignArr onView:contentTableViewArrM[2]];
    _favDevArr=[self setArrayAndTitleWithFile:self.favDevFilePath frameArr:_favDevArr onView:contentTableViewArrM[3]];
    _favMarketingArr=[self setArrayAndTitleWithFile:self.favMarketingFilePath frameArr:_favMarketingArr onView:contentTableViewArrM[4]];
    
    [self.view addSubview:contentScrollView];
    
    
}

-(void)didClickMenuBtn:(UIButton *)btn{
    for (UIButton *childBtn in self.menuScrollView.subviews) {
        if ([childBtn isKindOfClass:[UIButton class]]) {
            childBtn.selected=NO;
            if (childBtn.tag==btn.tag) {
                childBtn.selected=YES;
                //设置nav标题
//                [self setNavTitleWith:(int)btn.tag];
                if ((btn.tag+0.5)*MenuBtnWidth<self.view.bounds.size.width*0.5) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    self.menuScrollView.contentOffset=CGPointMake(0,0);
                    self.contentScrollView.contentOffset=CGPointMake(self.view.bounds.size.width*btn.tag, 0);
                    [UIView commitAnimations];
                }else if ((4+0.5-btn.tag)*MenuBtnWidth<self.view.bounds.size.width*0.5){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    self.menuScrollView.contentOffset=CGPointMake(MenuBtnWidth*5-self.view.bounds.size.width,0);
                    self.contentScrollView.contentOffset=CGPointMake(self.view.bounds.size.width*btn.tag, 0);
                    [UIView commitAnimations];
                }else{
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    self.menuScrollView.contentOffset=CGPointMake((btn.tag+0.5)*MenuBtnWidth-self.view.bounds.size.width*0.5, 0);
                    self.contentScrollView.contentOffset=CGPointMake(self.view.bounds.size.width*btn.tag, 0);
                    [UIView commitAnimations];
                }
            }
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int i=(int)((scrollView.contentOffset.x+self.view.bounds.size.width*0.5)/(int)self.view.bounds.size.width);
    [self moveMenuBtnToCenter:i];
}

-(void)moveMenuBtnToCenter:(int)i{
    for (UIButton *childBtn in self.menuScrollView.subviews){
        if ([childBtn isKindOfClass:[UIButton class]]) {
            childBtn.selected=NO;
            if (childBtn.tag==i) {
                childBtn.selected=YES;
                if ((i+0.5)*MenuBtnWidth<self.view.bounds.size.width*0.5) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    self.menuScrollView.contentOffset=CGPointMake(0,0);
                    [UIView commitAnimations];
                }else if ((4+0.5-i)*MenuBtnWidth<self.view.bounds.size.width*0.5){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    self.menuScrollView.contentOffset=CGPointMake(MenuBtnWidth*5-self.view.bounds.size.width,0);
                    [UIView commitAnimations];
                }else{
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    self.menuScrollView.contentOffset=CGPointMake((i+0.5)*MenuBtnWidth-self.view.bounds.size.width*0.5, 0);
                    [UIView commitAnimations];
                }
            }
        }
    }
//    [self setNavTitleWith:i];
}

-(NSMutableArray *)setArrayAndTitleWithFile:(NSString *)path frameArr:(NSMutableArray *)arrayM onView:(UITableView *)tableview{
    if ([self.fileMgr fileExistsAtPath:path]) {
        arrayM=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
        //标题
//        self.title=[NSString stringWithFormat:@"FAVORITE - %ld",(unsigned long)arrayM.count];
        self.title=@"FAVORITE";
        //没有关注内容提醒
        if (arrayM.count==0) {
            [self showNoFavDataTips:tableview];
        }
        return arrayM;
    }else{
        arrayM=[NSMutableArray array];
//        self.title=@"FAVORITE - 0";
        self.title=@"FAVORITE";
        //没有关注内容提醒
        [self showNoFavDataTips:tableview];
        return arrayM;
    }
}

-(void)setNavTitleWith:(int)i{
    if (i==0) {
        if ([self.fileMgr fileExistsAtPath:self.favProductsFilePath]) {
            _favNewsArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favProductsFilePath];
            //标题
            self.title=[NSString stringWithFormat:@"FAVORITE - %ld",(unsigned long)_favNewsArr.count];
            //没有关注内容提醒
            if (_favNewsArr.count==0) {
                [self showNoFavDataTips:self.contentTableViewArrM[i]];
            }
        }else{
            _favNewsArr=[NSMutableArray array];
            self.title=@"FAVORITE - 0";
            //没有关注内容提醒
            [self showNoFavDataTips:self.contentTableViewArrM[i]];
        }
    }else if(i==1){
        if ([self.fileMgr fileExistsAtPath:self.favNewsFilePath]) {
            _favNewsArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favNewsFilePath];
            //标题
            self.title=[NSString stringWithFormat:@"FAVORITE - %ld",(unsigned long)_favNewsArr.count];
            //没有关注内容提醒
            if (_favNewsArr.count==0) {
                [self showNoFavDataTips:self.contentTableViewArrM[i]];
            }
        }else{
            _favNewsArr=[NSMutableArray array];
            self.title=@"FAVORITE - 0";
            //没有关注内容提醒
            [self showNoFavDataTips:self.contentTableViewArrM[i]];
        }
    }else if(i==2){
        if ([self.fileMgr fileExistsAtPath:self.favDesignFilePath]) {
            _favDesignArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favDesignFilePath];
            //标题
            self.title=[NSString stringWithFormat:@"FAVORITE - %ld",(unsigned long)_favDesignArr.count];
            //没有关注内容提醒
            if (_favDesignArr.count==0) {
                [self showNoFavDataTips:self.contentTableViewArrM[i]];
            }
        }else{
            _favDesignArr=[NSMutableArray array];
            self.title=@"FAVORITE - 0";
            //没有关注内容提醒
            [self showNoFavDataTips:self.contentTableViewArrM[i]];
        }
    }else if(i==3){
        if ([self.fileMgr fileExistsAtPath:self.favDevFilePath]) {
            _favDevArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favDevFilePath];
            //标题
            self.title=[NSString stringWithFormat:@"FAVORITE - %ld",(unsigned long)_favDevArr.count];
            //没有关注内容提醒
            if (_favDevArr.count==0) {
                [self showNoFavDataTips:self.contentTableViewArrM[i]];
            }
        }else{
            _favDevArr=[NSMutableArray array];
            self.title=@"FAVORITE - 0";
            //没有关注内容提醒
            [self showNoFavDataTips:self.contentTableViewArrM[i]];
        }
    }else if(i==4){
        if ([self.fileMgr fileExistsAtPath:self.favMarketingFilePath]) {
            _favMarketingArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favMarketingFilePath];
            //标题
            self.title=[NSString stringWithFormat:@"FAVORITE - %ld",(unsigned long)_favMarketingArr.count];
            //没有关注内容提醒
            if (_favMarketingArr.count==0) {
                [self showNoFavDataTips:self.contentTableViewArrM[i]];
            }
        }else{
            _favMarketingArr=[NSMutableArray array];
            self.title=@"FAVORITE - 0";
            //没有关注内容提醒
            [self showNoFavDataTips:self.contentTableViewArrM[i]];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==0) {
        return _favProductArr.count;
    }else if (tableView.tag==1){
        return _favNewsArr.count;
    }else if (tableView.tag==2){
        return _favDesignArr.count;
    }else if (tableView.tag==3){
        return _favDevArr.count;
    }else{
        return _favMarketingArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        static NSString *cellId=@"favProducts";
        MProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[MProductCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.productFrame=_favProductArr[indexPath.row];
        return cell;
    }else if (tableView.tag==1){
        static NSString *cellId=@"favNews";
        MNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[MNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.newsFrame=_favNewsArr[indexPath.row];
        return cell;
    }else if (tableView.tag==2){
        static NSString *cellId=@"favDesign";
        MDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[MDesignCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.designFrame=_favDesignArr[indexPath.row];
        return cell;
    }else if (tableView.tag==3){
        static NSString *cellId=@"favDev";
        MDevCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[MDevCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.devFrame=_favDevArr[indexPath.row];
        return cell;
    }else{
        static NSString *cellId=@"favMarketing";
        MMarketingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[MMarketingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        cell.marketingFrame=_favMarketingArr[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        MProductFrame *productFrame=_favProductArr[indexPath.row];
        return productFrame.cellH;
    }else if (tableView.tag==1){
        MNewsFrame *newsFrame=_favNewsArr[indexPath.row];
        return newsFrame.cellH;
    }else if (tableView.tag==2){
        MDesignFrame *designFrame=_favDesignArr[indexPath.row];
        return designFrame.cellH;
    }else if (tableView.tag==3){
        MDevFrame *devFrame=_favDevArr[indexPath.row];
        return devFrame.cellH;
    }else {
        MMarketingFrame *marketingFrame=_favMarketingArr[indexPath.row];
        return marketingFrame.cellH;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        MProductDetailController *productDetailVc=[[MProductDetailController alloc]init];
        productDetailVc.selectedProductF=_favProductArr[indexPath.row];
        [self.navigationController pushViewController:productDetailVc animated:YES];
        //去除选中，即去除选中背景
        MProductCell *cell=(MProductCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
    }else if (tableView.tag==1){
        MNewsDetailController *newsDetailVc=[[MNewsDetailController alloc]init];
        newsDetailVc.selectedNewsF=_favNewsArr[indexPath.row];
        [self.navigationController pushViewController:newsDetailVc animated:YES];
        //去除选中，即去除选中背景
        MNewsCell *cell=(MNewsCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
    }else if (tableView.tag==2){
        MDesignDetailController *designDetailVc=[[MDesignDetailController alloc]init];
        designDetailVc.selectedDesignF=_favDesignArr[indexPath.row];
        [self.navigationController pushViewController:designDetailVc animated:YES];
        //去除选中，即去除选中背景
        MDesignCell *cell=(MDesignCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
    }else if (tableView.tag==3){
        MDevDetailController *devDetailVc=[[MDevDetailController alloc]init];
        devDetailVc.selectedDevF=_favDevArr[indexPath.row];
        [self.navigationController pushViewController:devDetailVc animated:YES];
        //去除选中，即去除选中背景
        MDevCell *cell=(MDevCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
    }else {
        MMarketingDetailController *marketingDetailVc=[[MMarketingDetailController alloc]init];
        marketingDetailVc.selectedMarketingF=_favMarketingArr[indexPath.row];
        [self.navigationController pushViewController:marketingDetailVc animated:YES];
        //去除选中，即去除选中背景
        MMarketingCell *cell=(MMarketingCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected=NO;
    }
}

//cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        return YES;
    }else if (tableView.tag==1){
        return YES;
    }else if (tableView.tag==2){
        return YES;
    }else if (tableView.tag==3){
        return YES;
    }else {
        return YES;
    }
}
//编辑-删除delete
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//编辑的字样
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}
//点击删除后，重新加载
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        [_favProductArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [NSKeyedArchiver archiveRootObject:_favProductArr toFile:self.favProductsFilePath];
        //删除时改变标题中的数量
        _favProductArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favProductsFilePath];
        //标题
//        self.title=[NSString stringWithFormat:@"FAV - %ld",(unsigned long)_favProductArr.count];
        //没有关注内容提醒
        if (_favProductArr.count==0) {
            [self showNoFavDataTips:tableView];
        }
    }else if (tableView.tag==1){
        [_favNewsArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [NSKeyedArchiver archiveRootObject:_favNewsArr toFile:self.favNewsFilePath];
        //删除时改变标题中的数量
        _favNewsArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favNewsFilePath];
        //标题
//        self.title=[NSString stringWithFormat:@"FAV - %ld",(unsigned long)_favNewsArr.count];
        //没有关注内容提醒
        if (_favNewsArr.count==0) {
            [self showNoFavDataTips:tableView];
        }
    }else if (tableView.tag==2){
        [_favDesignArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [NSKeyedArchiver archiveRootObject:_favDesignArr toFile:self.favDesignFilePath];
        //删除时改变标题中的数量
        _favDesignArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favDesignFilePath];
        //标题
//        self.title=[NSString stringWithFormat:@"FAV - %ld",(unsigned long)_favDesignArr.count];
        //没有关注内容提醒
        if (_favDesignArr.count==0) {
            [self showNoFavDataTips:tableView];
        }
    }else if (tableView.tag==3){
        [_favDevArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [NSKeyedArchiver archiveRootObject:_favDevArr toFile:self.favDevFilePath];
        //删除时改变标题中的数量
        _favDesignArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favDevFilePath];
        //标题
//        self.title=[NSString stringWithFormat:@"FAV - %ld",(unsigned long)_favDevArr.count];
        //没有关注内容提醒
        if (_favDevArr.count==0) {
            [self showNoFavDataTips:tableView];
        }
    }else {
        [_favMarketingArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [NSKeyedArchiver archiveRootObject:_favMarketingArr toFile:self.favMarketingFilePath];
        //删除时改变标题中的数量
        _favMarketingArr=(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:self.favMarketingFilePath];
        //标题
//        self.title=[NSString stringWithFormat:@"FAV - %ld",(unsigned long)_favMarketingArr.count];
        //没有关注内容提醒
        if (_favMarketingArr.count==0) {
            [self showNoFavDataTips:tableView];
        }
    }
}

@end
