//
//  MDev.m
//  miao
//
//  Created by 魏素宝 on 15/9/20.
//  Copyright © 2015年 SUBAOWEI. All rights reserved.
//

#import "MDev.h"

@implementation MDev
+(instancetype)devWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.dev_title=[dict[@"fields"][@"dev_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.dev_date=dict[@"fields"][@"dev_date"];
        self.dev_link=dict[@"fields"][@"dev_link"];
        self.dev_source=dict[@"fields"][@"dev_source"];
        self.dev_category=dict[@"fields"][@"dev_category"];
        self.dev_id=dict[@"pk"];
    }
    return self;
}

-(NSString *)dev_date{
    //获取当前的时间元素
    NSCalendar *calendar=[NSCalendar currentCalendar];
    int unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *currentCmps=[calendar components:unit fromDate:[NSDate date]];
    //获取产品的时间元素
    NSString *dev_date_year=[_dev_date substringWithRange:NSMakeRange(0, 4)];
    NSString *dev_date_month=[_dev_date substringWithRange:NSMakeRange(5, 2)];
    NSString *dev_date_day=[_dev_date substringWithRange:NSMakeRange(8, 2)];
    NSString *dev_date_hour=[_dev_date substringWithRange:NSMakeRange(11, 2)];
    NSString *dev_date_minute=[_dev_date substringWithRange:NSMakeRange(14, 2)];
    int deltaYear=(int)currentCmps.year-[dev_date_year intValue];
    int deltaMonth=(int)currentCmps.month-[dev_date_month intValue];
    int deltaDay=(int)currentCmps.day-[dev_date_day intValue];
    if ((deltaYear==0)&&(deltaMonth==0)&&(deltaDay==0)) {
        int deltaHours=(int)currentCmps.hour-[dev_date_hour intValue];
        int deltaMinutes=(int)currentCmps.minute-[dev_date_minute intValue];
        if (deltaHours>=1) {
            return [NSString stringWithFormat:@"%ld小时前",(long)deltaHours];
        }else if (deltaMinutes>=1){
            return [NSString stringWithFormat:@"%ld分钟前",(long)deltaMinutes];
        }else{
            return @"刚刚";
        }
    }else{
        return [_dev_date substringWithRange:NSMakeRange(0, 10)];
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_dev_title forKey:@"dev_title"];
    [aCoder encodeObject:_dev_date forKey:@"dev_date"];
    [aCoder encodeObject:_dev_link forKey:@"dev_link"];
    [aCoder encodeObject:_dev_source forKey:@"dev_source"];
    [aCoder encodeObject:_dev_category forKey:@"dev_category"];
    [aCoder encodeObject:_dev_id forKey:@"dev_id"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _dev_title=[aDecoder decodeObjectForKey:@"dev_title"];
        _dev_date=[aDecoder decodeObjectForKey:@"dev_date"];
        _dev_link=[aDecoder decodeObjectForKey:@"dev_link"];
        _dev_source=[aDecoder decodeObjectForKey:@"dev_source"];
        _dev_category=[aDecoder decodeObjectForKey:@"dev_category"];
        _dev_id=[aDecoder decodeObjectForKey:@"dev_id"];
    }
    return self;
}
@end
