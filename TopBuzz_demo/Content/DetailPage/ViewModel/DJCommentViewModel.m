//
//  DJCommentViewModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentViewModel.h"
#import <UIKit/UIKit.h>
#import "DJColor.h"

@interface DJCommentViewModel ()
@property (nonatomic, strong) DJCommentModel *model;

@end

@implementation DJCommentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        DJCommentModel *model = [[DJCommentModel alloc] init];
        _model = model;
        [self bindModel:_model];
        _commentItemInfoArray = @[].mutableCopy;
        _commentHeightSum = 0;
    }
    return self;
}


- (void)loadCommentDataWithID:(NSString *)Id uid:(NSString *)uid {
    [_model loadSourceCommemtDataItemInfoListWithID:Id uid:uid];
}

- (void)bindModel:(DJCommentModel *)model {
    [model addObserver:self forKeyPath:@"sourceCommentItemArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sourceCommentItemArray"]) {
        // 处理属性变化
        NSArray *sourceDataArray = change[NSKeyValueChangeNewKey];
        NSMutableArray <DJCommentItemInfo *>*listItemArray = @[].mutableCopy;
        for (SourceCommentItemInfo *info in sourceDataArray) {
            DJCommentItemInfo *itemInfo = [DJCommentItemInfo getCommentItemFromSourceData:info];
            _commentHeightSum = [NSNumber numberWithFloat:[_commentHeightSum floatValue] + [itemInfo.cell_height floatValue] + 20];
            [listItemArray addObject:itemInfo];
        }
        if ([_commentHeightSum floatValue] > 700) {
            _commentHeightSum = [NSNumber numberWithFloat:700.0];
        }
        self.commentItemInfoArray = listItemArray;
    }
}


- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"sourceCommentItemArray"];
}

@end


@implementation DJCommentItemInfo

+ (DJCommentItemInfo *)getCommentItemFromSourceData:(SourceCommentItemInfo *)sourceData {
    DJCommentItemInfo *itemInfo = [[DJCommentItemInfo alloc] init];
    itemInfo.com_text = sourceData.com_text;
    itemInfo.com_screen_name = sourceData.com_screen_name;
    itemInfo.com_profile_image_url = sourceData.com_profile_image_url;
    itemInfo.com_created_at = [DJCommentItemInfo dateFormatter:sourceData.com_created_at];
    itemInfo.textAttributedString = [DJCommentItemInfo replaceURLsWithLinksInString:sourceData.com_text];
    [itemInfo computeCellHeight];
    if (sourceData.com_location)
        itemInfo.com_location = sourceData.com_location;
    else
        itemInfo.com_location = @"未知IP";
    return itemInfo;
    
}

- (void)computeCellHeight {
    float textWidth = 300;
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:17] // 你的字体大小
    };
    CGRect boundingRect = [_com_text boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:attributes
                                                   context:nil];
    // 获取计算出的高度
    CGFloat labelHeight = CGRectGetHeight(boundingRect);
    self.text_height = [NSNumber numberWithFloat:labelHeight];
    self.cell_height = [NSNumber numberWithFloat:labelHeight + 70];
}

+ (NSString *)dateFormatter:(NSString * )sourceDate {
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

+ (NSAttributedString *)replaceURLsWithLinksInString:(NSString *)string {
    NSError *error;
    // 可以识别 URL 的正则表达式
    NSString *regexPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];

    for (NSTextCheckingResult *match in matches) {
        NSString *urlString = [string substringWithRange:match.range];
        
        // 创建带有链接样式的属性字符串
        NSDictionary *linkAttributes = @{NSLinkAttributeName: [NSURL URLWithString:urlString],
                                         NSForegroundColorAttributeName:LINK_BLUE};
        
        NSAttributedString *linkAttributedString = [[NSAttributedString alloc] initWithString:@"网页链接" attributes:linkAttributes];
        
        // 替换原始字符串中的 URL
        [attributedString replaceCharactersInRange:match.range withAttributedString:linkAttributedString];
    }

    return attributedString;
}


@end
