//
//  MNewsFrame.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MNewsFrame.h"
#import "MNews.h"

@implementation MNewsFrame
-(void)setNews:(MNews *)news{
    _news=news;
    CGFloat marginLeft=12;
    CGFloat marginRight=10;
    CGFloat marginTop=12;
    CGFloat marginBottom=12;
    //设置cell宽度
    CGFloat cellW=[UIScreen mainScreen].bounds.size.width;
    
    //设置图片
    CGFloat imgViewW=84;
    CGFloat imgViewH=66;
    CGFloat imgViewX=cellW-imgViewW-marginRight;
    CGFloat imgViewY=marginTop;
    _imgViewF=CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
    
    //设置标题
    CGFloat titleX=marginLeft;
    CGFloat titleY=marginTop;
    CGFloat titleW=cellW-imgViewW-marginLeft-marginRight*2;
    NSDictionary *titleAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize titleLabelSize=[news.n_title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrDict context:nil].size;
    _titleF=(CGRect){{titleX,titleY},titleLabelSize};
    
    //设置日期
    CGFloat dateX=titleX;
    CGFloat dateY;
    if ((CGRectGetMaxY(_imgViewF)-12)>(CGRectGetMaxY(_titleF)+8)) {
        dateY=CGRectGetMaxY(_imgViewF)-12;
    }else{
        dateY=CGRectGetMaxY(_titleF)+8;
    }
    NSDictionary *dateAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize dateLabelSize=[news.n_date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dateAttrDict context:nil].size;
    _dateF=(CGRect){{dateX,dateY},dateLabelSize};
    
    //设置来源
    CGFloat sourceW=cellW;
    CGFloat sourceX=CGRectGetMaxX(_dateF)+10;
    CGFloat sourceY=dateY;
    NSDictionary *sourceAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize sourceLabelSize=[news.n_source boundingRectWithSize:CGSizeMake(sourceW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:sourceAttrDict context:nil].size;
    _sourceF=(CGRect){{sourceX,sourceY},sourceLabelSize};
    
    //设置分享按钮
    CGFloat shareBtnX=CGRectGetMaxX(_sourceF)+10;
    CGFloat shareBtnY=dateY;
    CGFloat shareBtnW=21;
    CGFloat shareBtnH=14;
    _shareBtnF=CGRectMake(shareBtnX, shareBtnY, shareBtnW, shareBtnH);
    
    //设置cell高度
    if (CGRectGetMaxY(_dateF)<CGRectGetMaxY(_imgViewF)) {
        _cellH=CGRectGetMaxY(_imgViewF)+marginBottom;
    }else{
        _cellH=CGRectGetMaxY(_dateF)+marginBottom;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_news forKey:@"news"];
    [aCoder encodeCGRect:_titleF forKey:@"titleF"];
    [aCoder encodeCGRect:_imgViewF forKey:@"imgViewF"];
    [aCoder encodeCGRect:_sourceF forKey:@"sourceF"];
    [aCoder encodeCGRect:_dateF forKey:@"dateF"];
    [aCoder encodeCGRect:_shareBtnF forKey:@"shareBtnF"];
    [aCoder encodeFloat:_cellH forKey:@"cellH"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _news=[aDecoder decodeObjectForKey:@"news"];
        _titleF=[aDecoder decodeCGRectForKey:@"titleF"];
        _imgViewF=[aDecoder decodeCGRectForKey:@"imgViewF"];
        _sourceF=[aDecoder decodeCGRectForKey:@"sourceF"];
        _dateF=[aDecoder decodeCGRectForKey:@"dateF"];
        _shareBtnF=[aDecoder decodeCGRectForKey:@"shareBtnF"];
        _cellH=[aDecoder decodeFloatForKey:@"cellH"];
    }
    return self;
}

@end
