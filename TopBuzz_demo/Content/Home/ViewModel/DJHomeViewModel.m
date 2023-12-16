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

#pragma mark - ViewModel
@interface DJHomeViewModel ()
@property (nonatomic, strong) DJHomeModel *model;
@end

@implementation DJHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[DJHomeModel alloc] init];
        [self bindModel:_model];
        _collectionItemInfoArrays = @[].mutableCopy;
        _collectionItemInfoArray = @[].mutableCopy;
    }
    return self;
}

/// 加载View所需的模型数据
- (void)loadCollectionItemInfoDataWithType:(RequestType)type Page:(int)page {
    [_model loadSourceDataItemInfoListWithRequestType:type Page:page];
}

/// 刷新请求页（默认请求最新的第一页）
- (void)refreshCollectionItemInfoDataWith:(RequestType)type {
    [_model loadSourceDataItemInfoListWithRequestType:type Page:1];
    // 刷新后需要请求原视图数据列表 重新添加
    [_collectionItemInfoArrays removeAllObjects];
}


#pragma mark - ObserveValueForKeyPath
/// 监听model的 sourceDataItemArray 实现双向绑定
- (void)bindModel:(DJHomeModel *)model {
    [model addObserver:self forKeyPath:@"sourceDataItemArray" options:NSKeyValueObservingOptionNew context:nil];
}

/// 监听model 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sourceDataItemArray"]) {
        // 获取 model 中请求下来的原数据模型数组
        NSArray *sourceDataArray = change[NSKeyValueChangeNewKey];
        NSMutableArray <DJCollectionItemInfo *>*listItemArray = @[].mutableCopy;
        for (SourceDataItemInfo *info in sourceDataArray) {
            // 对原数据模型进行转换为ViewModel数据
            DJCollectionItemInfo *itemInfo = [DJCollectionItemInfo getCollectionItemInfoFromSourceData:info];
            [listItemArray addObject:itemInfo];
        }
        // 赋值更新 viewModel 数组（View 通过KVO监听该属性的setter方法）View可以直接通过该数据进行展示
        self.collectionItemInfoArray = listItemArray;
        [_collectionItemInfoArrays addObjectsFromArray:_collectionItemInfoArray];
    }
}

- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"sourceDataItemArray"];
}

@end


#pragma mark - Model_To_ViewModel
@implementation DJCollectionItemInfo
/// 将原数据模型转为View模型
+ (DJCollectionItemInfo *)getCollectionItemInfoFromSourceData:(SourceDataItemInfo *)sourceData{
    DJCollectionItemInfo *itemInfo = [[DJCollectionItemInfo alloc] init];
    /**博客内容**/
    itemInfo.text = sourceData.text;
    itemInfo.created_at = [itemInfo dateFormatter:sourceData.created_at];
    itemInfo.region_name = [itemInfo getViewRegionName:sourceData.region_name];
    itemInfo.repostCount = [sourceData.reposts_count stringValue];
    itemInfo.commentCount = [sourceData.comments_count stringValue];
    itemInfo.likeCount = [sourceData.attitudes_count stringValue];
    itemInfo.Id = sourceData.Id;
    itemInfo.picInfos = sourceData.pic_urls;

    /**user 信息**/
    itemInfo.username = sourceData.screen_name;
    itemInfo.profileImageString = sourceData.profile_image_url;
    itemInfo.uid = sourceData.uid;

    /**视图数据**/
    itemInfo.imageWidth = sourceData.pic_urls[0].width;
    itemInfo.imageHeight = sourceData.pic_urls[0].height;
    itemInfo.textAttributedString = [itemInfo setTextAttributed:sourceData.text];
    [itemInfo computeViewHeight];
    
    return itemInfo;
}


#pragma mark - 模型转ViewModel辅助函数
/// 富文本文字设置
- (NSMutableAttributedString *)setTextAttributed:(NSString *)text {
    // 创建NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    // 定义蓝色
    UIColor *blueColor = LINK_BLUE;

    // 找到所有的#的位置
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#" options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];

    // 设置每一对#中间文字设置为蓝色
    for (NSUInteger i = 0; i < matches.count; i += 2) {
        NSRange range = matches[i].range;
        if (i + 1 < matches.count) {
            range.length = matches[i + 1].range.location - range.location + 1;
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value:blueColor range:range];
    }
    return attributedString;
}



/// 日期格式化
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

    // 判断时间间隔，如果大于一天则显示具体日期
    if (timeInterval > 24 * 60 * 60) {
        NSDateFormatter *visualDateFormatter = [[NSDateFormatter alloc] init];
        // 判断年份是否相同
        if (currentYear != parsedYear) {
            // 如果不是本年，则显示年月日
            [visualDateFormatter setDateFormat:@"yyyy年MM月dd日"];
        } else {
            // 如果是本年则显示 月 日 小时 分钟
            [visualDateFormatter setDateFormat:@"MM-dd HH:mm"];
        }

        NSString *visualDateString = [visualDateFormatter stringFromDate:date];
        return visualDateString;
    } else {
        // 如果小于一天，则显示多少 小时/分钟 ago
        NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
        dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
        dateComponentsFormatter.maximumUnitCount = 1;
        NSString *relativeTimeString = [[dateComponentsFormatter stringFromTimeInterval:timeInterval] stringByAppendingString:@" ago"];
        
        return relativeTimeString;
    }
}

/// 获得视图所需的地址字符串
- (NSString *)getViewRegionName:(NSString *)region {
    if (region)
        return region;
    else
        return @"未知IP";
}

/// 计算View中各个视图的高度
- (void)computeViewHeight {
    float cellWidth = (SCREEN_WIDTH - 10) / 2;
    float browserWidth = SCREEN_WIDTH - 40;
    float imageHight = [self.imageHeight floatValue] * (cellWidth / [self.imageWidth floatValue]);
    float imageBrowserHight = [self.imageHeight floatValue] * (browserWidth / [self.imageWidth floatValue]);
    float imageFullScreenFormatHeight = [self.imageHeight floatValue] * (SCREEN_WIDTH / [self.imageWidth floatValue]);

    self.imageCollectionFormatHeight = [NSNumber numberWithFloat:imageHight];
    self.imageBrowserFormatHeight = [NSNumber numberWithFloat:imageBrowserHight];
    self.imageFullScreenFormatHeight = [NSNumber numberWithFloat:imageFullScreenFormatHeight];
    
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

