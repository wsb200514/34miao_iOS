//
//  MProduct.h
//  sansimiao
//
//  Created by 魏素宝 on 15/8/27.
//  Copyright (c) 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MProduct : NSObject <NSCoding>
@property(nonatomic,copy) NSString *p_name;
@property(nonatomic,copy) NSString *p_desc;
@property(nonatomic,copy) NSString *p_date;
@property(nonatomic,copy) NSString *p_link;
@property(nonatomic,copy) NSString *p_source;
@property(nonatomic,copy) NSString *p_source_link;
@property(nonatomic,copy) NSString *p_id;

+(instancetype)productWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
