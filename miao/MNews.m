//
//  MNews.m
//  miao
//
//  Created by 魏素宝 on 15/9/19.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MNews.h"

@implementation MNews
+(instancetype)newsWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.n_title=[dict[@"fields"][@"n_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.n_date=dict[@"fields"][@"n_date"];
        self.n_link=dict[@"fields"][@"n_link"];
        self.n_source=dict[@"fields"][@"n_source"];
        self.n_img_url=dict[@"fields"][@"n_img_url"];
        self.n_id=dict[@"pk"];
    }
    return self;
}

-(NSString *)n_date{
    //获取当前的时间元素
    NSCalendar *calendar=[NSCalendar currentCalendar];
    int unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *currentCmps=[calendar components:unit fromDate:[NSDate date]];
    //获取产品的时间元素
    NSString *n_date_year=[_n_date substringWithRange:NSMakeRange(0, 4)];
    NSString *n_date_month=[_n_date substringWithRange:NSMakeRange(5, 2)];
    NSString *n_date_day=[_n_date substringWithRange:NSMakeRange(8, 2)];
    NSString *n_date_hour=[_n_date substringWithRange:NSMakeRange(11, 2)];
    NSString *n_date_minute=[_n_date substringWithRange:NSMakeRange(14, 2)];
    int deltaYear=(int)currentCmps.year-[n_date_year intValue];
    int deltaMonth=(int)currentCmps.month-[n_date_month intValue];
    int deltaDay=(int)currentCmps.day-[n_date_day intValue];
    if ((deltaYear==0)&&(deltaMonth==0)&&(deltaDay==0)) {
        int deltaHours=(int)currentCmps.hour-[n_date_hour intValue];
        int deltaMinutes=(int)currentCmps.minute-[n_date_minute intValue];
        if (deltaHours>=1) {
            return [NSString stringWithFormat:@"%ld小时前",(long)deltaHours];
        }else if (deltaMinutes>=1){
            return [NSString stringWithFormat:@"%ld分钟前",(long)deltaMinutes];
        }else{
            return @"刚刚";
        }
    }else{
        return [_n_date substringWithRange:NSMakeRange(0, 10)];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_n_title forKey:@"n_title"];
    [aCoder encodeObject:_n_date forKey:@"n_date"];
    [aCoder encodeObject:_n_link forKey:@"n_link"];
    [aCoder encodeObject:_n_source forKey:@"n_source"];
    [aCoder encodeObject:_n_img_url forKey:@"n_img_url"];
    [aCoder encodeObject:_n_id forKey:@"n_id"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _n_title=[aDecoder decodeObjectForKey:@"n_title"];
        _n_date=[aDecoder decodeObjectForKey:@"n_date"];
        _n_link=[aDecoder decodeObjectForKey:@"n_link"];
        _n_source=[aDecoder decodeObjectForKey:@"n_source"];
        _n_img_url=[aDecoder decodeObjectForKey:@"n_img_url"];
        _n_id=[aDecoder decodeObjectForKey:@"n_id"];
    }
    return self;
}

@end
