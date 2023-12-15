//
//  DJHomeViewModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeViewModel.h"
#import "DJScreen.h"
#import "DJColor.h"
#include <objc/runtime.h>

@interface DJHomeViewModel ()
@property (nonatomic, strong) DJHomeModel *model;

@end


@implementation DJHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        DJHomeModel *model = [[DJHomeModel alloc] init];
        _model = model;
        [self bindModel:_model];
        _collectionItemInfoArrays = @[].mutableCopy;
    }
    return self;
}


- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page {
    [_model loadSourceDataItemInfoListWithRequestType:type Page:page];
}

- (void)refreshCollectionItemInfoDataWith:(RequestType)type {
    [_model loadSourceDataItemInfoListWithRequestType:type Page:1];
    [_collectionItemInfoArrays removeAllObjects];
}



- (void)bindModel:(DJHomeModel *)model {
    [model addObserver:self forKeyPath:@"sourceDataItemArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sourceDataItemArray"]) {
        // 处理属性变化
        NSArray *sourceDataArray = change[NSKeyValueChangeNewKey];
        NSMutableArray <DJCollectionItemInfo *>*listItemArray = @[].mutableCopy;
        
        for (SourceDataItemInfo *info in sourceDataArray) {
            DJCollectionItemInfo *itemInfo = [DJCollectionItemInfo getCollectionItemInfoFromSourceData:info];
            [listItemArray addObject:itemInfo];
        }
        
        [self willChangeValueForKey:@"collectionItemInfoArray"];
        self.collectionItemInfoArray = listItemArray;
        [self didChangeValueForKey:@"collectionItemInfoArray"];
        
        [_collectionItemInfoArrays addObjectsFromArray:_collectionItemInfoArray];
    }
}


- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"sourceDataItemArray"];
}

@end




typedef NS_ENUM(NSUInteger, ImageType) {
    ThumbnailType              = 0,  // 缩略图
    BmiddleType                = 1,  // 中尺寸图
    OriginalType               = 2,  // 原图
    ProfileType                = 3,  // 头像
};


@implementation DJCollectionItemInfo

+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData{
    DJCollectionItemInfo *itemInfo = [[DJCollectionItemInfo alloc] init];
    itemInfo.profileImageString = sourceData.profile_image_url;
    itemInfo.text = sourceData.text;
    itemInfo.username = sourceData.screen_name;
    itemInfo.created_at = [itemInfo dateFormatter:sourceData.created_at];
    itemInfo.likeNumber = [sourceData.attitudes_count stringValue];
    itemInfo.picInfos = sourceData.pic_urls;
    itemInfo.imageWidth = sourceData.pic_urls[0].width;
    itemInfo.imageHeight = sourceData.pic_urls[0].height;
    
    itemInfo.textAttributedString = [itemInfo setTextAttributed:sourceData.text];
    
    if (sourceData.region_name)
        itemInfo.region_name = sourceData.region_name;
    else
        itemInfo.region_name = @"未知IP";
    
    [itemInfo computeItemCellHeight];
    
    return itemInfo;
}

- (NSMutableAttributedString *)setTextAttributed:(NSString *)text {
    // 创建NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    // 定义蓝色
    UIColor *blueColor = LINK_BLUE;

    // 找到所有的#的位置
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#" options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];

    // 设置每一对#中间文字的颜色
    for (NSUInteger i = 0; i < matches.count; i += 2) {
        NSRange range = matches[i].range;
        if (i + 1 < matches.count) {
            range.length = matches[i + 1].range.location - range.location + 1;
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value:blueColor range:range];
    }
    return attributedString;
}



- (NSString *)dateFormatter:(NSString * )sourceDate {
    // 创建日期格式化器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];

    // 将字符串转换为 NSDate
    NSDate *date = [dateFormatter dateFromString:sourceDate];

    // 获取当前日期的年份
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];

    // 获取解析得到的日期的年份
    NSInteger parsedYear = [calendar component:NSCalendarUnitYear fromDate:date];

    // 计算时间间隔
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];

    // 判断时间间隔，如果大于一天则使用日期格式化器
    if (timeInterval > 24 * 60 * 60) {
        NSDateFormatter *visualDateFormatter = [[NSDateFormatter alloc] init];
        // 判断年份是否相同
        if (currentYear != parsedYear) {
            [visualDateFormatter setDateFormat:@"yyyy年MM月dd日"];
        } else {
            [visualDateFormatter setDateFormat:@"MM-dd HH:mm"];
        }

        NSString *visualDateString = [visualDateFormatter stringFromDate:date];
        return visualDateString;
    } else {
        // 如果小于一天，则使用日期组件格式化器
        NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
        dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
        dateComponentsFormatter.maximumUnitCount = 1;
        NSString *relativeTimeString = [[dateComponentsFormatter stringFromTimeInterval:timeInterval] stringByAppendingString:@" ago"];
        
        return relativeTimeString;
    }
}


- (void)computeItemCellHeight {
    float cellWidth = (SCREEN_WIDTH - 10) / 2;
    float browserWidth = SCREEN_WIDTH - 40;
    float imageHight = [self.imageHeight floatValue] * (cellWidth / [self.imageWidth floatValue]);
    float imageBrowserHight = [self.imageHeight floatValue] * (browserWidth / [self.imageWidth floatValue]);
    self.imageCollectionFormatHeight = [NSNumber numberWithFloat:imageHight];
    self.imageBrowserFormatHeight = [NSNumber numberWithFloat:imageBrowserHight];
    
    CGFloat collectionLabelWidth = 180; // UILabel 的宽度
    CGFloat browserLabelWidth = SCREEN_WIDTH - 40; // UILabel 的宽度


    // 使用 NSAttributedString 来设置字体和段落样式，确保计算的高度与实际显示时一致
    NSDictionary *collectionAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12.0] // 你的字体大小
    };
    NSDictionary *browserAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:16.5] // 你的字体大小
    };

    // 计算字符串在给定宽度下的尺寸
    CGRect collectionBoundingRect = [self.text boundingRectWithSize:CGSizeMake(collectionLabelWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:collectionAttributes
                                                   context:nil];
    CGRect browserBoundingRect = [self.text boundingRectWithSize:CGSizeMake(browserLabelWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:browserAttributes
                                                   context:nil];
    // 获取计算出的高度
    CGFloat collectionLabelHeight = CGRectGetHeight(collectionBoundingRect);
    if (collectionLabelHeight > 40) {
        collectionLabelHeight = 40;       // 外流只展示两行
    }
    self.textCollectionFormatHeight = [NSNumber numberWithFloat:collectionLabelHeight];
    self.textBrowserFormatHeight = [NSNumber numberWithFloat:CGRectGetHeight(browserBoundingRect)];

    
    self.cellHeight = [NSNumber numberWithFloat:imageHight + collectionLabelHeight + 50];
}


@end

