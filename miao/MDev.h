//
//  MDev.h
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDev : NSObject
@property(nonatomic,copy) NSString *dev_title;
@property(nonatomic,copy) NSString *dev_date;
@property(nonatomic,copy) NSString *dev_link;
@property(nonatomic,copy) NSString *dev_source;
@property(nonatomic,copy) NSString *dev_id;
@property(nonatomic,copy) NSString *dev_category;

+(instancetype)devWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
@end
