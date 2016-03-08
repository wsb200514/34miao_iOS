//
//  MDevFrame.m
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDevFrame.h"
#import "MDev.h"

@implementation MDevFrame

-(void)setDev:(MDev *)dev{
    _dev=dev;
    CGFloat marginLeft=10;
    CGFloat marginRight=10;
    CGFloat marginTop=10;
    CGFloat marginBottom=10;
    //设置cell宽度
    CGFloat cellW=[UIScreen mainScreen].bounds.size.width;
    
    //设置类别
    CGFloat categoryW=32;
    CGFloat categoryH=18;
    CGFloat categoryX=marginLeft;
    CGFloat categoryY=marginTop;
    _categoryF=CGRectMake(categoryX, categoryY, categoryW, categoryH);
    
    //设置标题
    CGFloat titleX=CGRectGetMaxX(_categoryF)+marginRight;
    CGFloat titleY=marginTop;
    CGFloat titleW=cellW-categoryW-marginLeft-marginRight*2;
    NSDictionary *titleAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGSize titleLabelSize=[dev.dev_title boundingRectWithSize:CGSizeMake(titleW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrDict context:nil].size;
    _titleF=(CGRect){{titleX,titleY},titleLabelSize};
    
    //设置日期
    CGFloat dateX=titleX;
    CGFloat dateY=CGRectGetMaxY(_titleF)+marginTop;
    NSDictionary *dateAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize dateLabelSize=[dev.dev_date boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:dateAttrDict context:nil].size;
    _dateF=CGRectMake(dateX, dateY, ceilf(dateLabelSize.width), ceilf(dateLabelSize.height));
    
    //设置来源
    CGFloat sourceW=cellW;
    CGFloat sourceX=CGRectGetMaxX(_dateF)+marginRight;
    CGFloat sourceY=dateY;
    NSDictionary *sourceAttrDict=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName, nil];
    CGSize sourceLabelSize=[dev.dev_source boundingRectWithSize:CGSizeMake(sourceW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:sourceAttrDict context:nil].size;
    _sourceF=(CGRect){{sourceX,sourceY},sourceLabelSize};
    
    //设置分享按钮
    CGFloat shareBtnX=CGRectGetMaxX(_sourceF)+10;
    CGFloat shareBtnY=dateY;
    CGFloat shareBtnW=21;
    CGFloat shareBtnH=14;
    _shareBtnF=CGRectMake(shareBtnX, shareBtnY, shareBtnW, shareBtnH);
    
    //设置cell高度
    _cellH=CGRectGetMaxY(_dateF)+marginBottom;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_dev forKey:@"dev"];
    [aCoder encodeCGRect:_titleF forKey:@"titleF"];
    [aCoder encodeCGRect:_categoryF forKey:@"categoryF"];
    [aCoder encodeCGRect:_sourceF forKey:@"sourceF"];
    [aCoder encodeCGRect:_dateF forKey:@"dateF"];
    [aCoder encodeCGRect:_shareBtnF forKey:@"shareBtnF"];
    [aCoder encodeFloat:_cellH forKey:@"cellH"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _dev=[aDecoder decodeObjectForKey:@"dev"];
        _titleF=[aDecoder decodeCGRectForKey:@"titleF"];
        _categoryF=[aDecoder decodeCGRectForKey:@"categoryF"];
        _sourceF=[aDecoder decodeCGRectForKey:@"sourceF"];
        _dateF=[aDecoder decodeCGRectForKey:@"dateF"];
        _shareBtnF=[aDecoder decodeCGRectForKey:@"shareBtnF"];
        _cellH=[aDecoder decodeFloatForKey:@"cellH"];
    }
    return self;
}
@end
