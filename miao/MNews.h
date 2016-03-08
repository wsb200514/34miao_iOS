//
//  MNews.h
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNews : NSObject
@property(nonatomic,copy) NSString *n_title;
@property(nonatomic,copy) NSString *n_date;
@property(nonatomic,copy) NSString *n_link;
@property(nonatomic,copy) NSString *n_img_url;
@property(nonatomic,copy) NSString *n_source;
@property(nonatomic,copy) NSString *n_id;

+(instancetype)newsWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
