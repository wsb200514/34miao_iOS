//
//  MNewsDetailController.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MNewsDetailController.h"
#import "MNewsFrame.h"
#import "MNews.h"

@interface MNewsDetailController ()<UIWebViewDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak) UIProgressView *loadingProgressView;
@property(nonatomic,strong) NSTimer *progressTimer;
@end

@implementation MNewsDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置发起webview以及代理
    UIWebView *selectWebView=[[UIWebView alloc]init];
    selectWebView.frame=self.view.frame;
    selectWebView.scalesPageToFit=YES;
    [self.view addSubview:selectWebView];
    //网址中有中文字符，需要做一次UTF8转码
    [selectWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.selectedNewsF.news.n_link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    selectWebView.delegate=self;
    //标题
    self.title=self.selectedNewsF.news.n_title;
    
    //设置进度条
    UIProgressView *loadingProgressView=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.loadingProgressView=loadingProgressView;
    self.loadingProgressView.tintColor=[UIColor colorWithRed:0.92 green:0.39 blue:0.39 alpha:1];
    self.loadingProgressView.frame=CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 2);
    self.progressTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setProgressWithValue:) userInfo:nil repeats:YES];
    [self.view addSubview:self.loadingProgressView];
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSDefaultRunLoopMode];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self setProgressWithValue:true];
}

-(void)setProgressWithValue:(BOOL)complete{
    if (!complete) {
        if (self.loadingProgressView.progress<0.7) {
            self.loadingProgressView.progress+=0.2;
        }else{
            self.loadingProgressView.progress=0.95;
        }
    }else{
        [self.progressTimer invalidate];
        self.progressTimer=nil;
        [self.loadingProgressView setProgress:1.0 animated:YES];
        [self.loadingProgressView removeFromSuperview];
        self.loadingProgressView=nil;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //确保只调用1次
    if (!webView.isLoading) {
        [self setProgressWithValue:true];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (([error code]!=(-999)) && ([error code]!=(-1005)) && ([error code]!=(-1003))) {
        UIAlertView *RequestFailure=[[UIAlertView alloc]initWithTitle:@"请求数据失败" message:@"没请求到数据，请检查网络设置。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [RequestFailure show];
        [self setProgressWithValue:true];
    }
}

@end
