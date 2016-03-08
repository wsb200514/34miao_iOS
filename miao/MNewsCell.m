//
//  MNewsCell.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MNewsCell.h"
#import "MNews.h"
#import "MNewsFrame.h"
#import "UIImageView+WebCache.h"

@interface MNewsCell()
@property(nonatomic,weak) UIImageView *newsImgView;
@property(nonatomic,weak) UILabel *titleLabel;
@property(nonatomic,weak) UILabel *sourceLabel;
@property(nonatomic,weak) UILabel *dateLabel;
@end

@implementation MNewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加控件
        UIImageView *newsImgView=[[UIImageView alloc]init];
        newsImgView.layer.cornerRadius=2;
        newsImgView.layer.masksToBounds=YES;
        [self.contentView addSubview:newsImgView];
        self.newsImgView=newsImgView;
        
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.numberOfLines=0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel=titleLabel;
        
        UILabel *dateLabel=[[UILabel alloc]init];
        dateLabel.font=[UIFont systemFontOfSize:12];
        dateLabel.textColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        [self.contentView addSubview:dateLabel];
        self.dateLabel=dateLabel;
        
        UILabel *sourceLabel=[[UILabel alloc]init];
        sourceLabel.font=[UIFont systemFontOfSize:12];
        sourceLabel.textColor=[UIColor colorWithRed:0.92 green:0.39 blue:0.39 alpha:0.5];
        [self.contentView addSubview:sourceLabel];
        self.sourceLabel=sourceLabel;
        
        //添加分享按钮
        UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:shareBtn];
        self.shareBtn=shareBtn;
    }
    return self;
}

-(void)setNewsFrame:(MNewsFrame *)newsFrame{
    MNews *news=newsFrame.news;
    _newsFrame=newsFrame;
    _newsFrame.news=news;
    [self.newsImgView sd_setImageWithURL:[NSURL URLWithString:news.n_img_url]];
    self.titleLabel.text=news.n_title;
    self.dateLabel.text=news.n_date;
    self.sourceLabel.text=news.n_source;
    
    self.newsImgView.frame=newsFrame.imgViewF;
    self.titleLabel.frame=newsFrame.titleF;
    self.dateLabel.frame=newsFrame.dateF;
    self.sourceLabel.frame=newsFrame.sourceF;
    self.shareBtn.frame=newsFrame.shareBtnF;
}

//当处于编辑取消收藏状态时，因为左边有删除按钮占据空间，导致cell右移，所以右边滑出的“取消收藏”会被遮挡，所以此处把cell放底层，“取消收藏”放在上面
- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isEditing) {
        [self sendSubviewToBack:self.contentView];
    }
}

@end
