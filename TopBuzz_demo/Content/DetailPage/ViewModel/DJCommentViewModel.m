//
//  DJCommentViewModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentViewModel.h"
#import "DJColor.h"
#import "DJCommentNetworking.h"

#pragma mark - ViewModel
@interface DJCommentViewModel ()
@property (nonatomic, strong) DJCommentModel *model;
@end

@implementation DJCommentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[DJCommentModel alloc] init];
        [self bindModel:_model];
        _commentItemInfoArray = @[].mutableCopy;
        _commentHeightSum = 0;
    }
    return self;
}

/// 加载CommentView所需的模型数据
- (void)loadCommentDataWithID:(NSString *)Id uid:(NSString *)uid {
    [DJCommentNetworking loadSourceCommemtDataItemInfoListWithID:Id uid:uid model:_model];
}


#pragma mark - ObserveValueForKeyPath
/// 监听model的 sourceCommentItemArray 实现双向绑定
- (void)bindModel:(DJCommentModel *)model {
    [model addObserver:self forKeyPath:@"sourceCommentItemArray" options:NSKeyValueObservingOptionNew context:nil];
}

// 观察者回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sourceCommentItemArray"]) {
        // 获取 model 中请求下来的原数据模型数组
        NSArray *sourceDataArray = change[NSKeyValueChangeNewKey];
        NSMutableArray <DJCommentItemInfo *>*listItemArray = @[].mutableCopy;
        for (SourceCommentItemInfo *info in sourceDataArray) {
            // 对原数据模型进行转换为ViewModel数据
            DJCommentItemInfo *itemInfo = [DJCommentItemInfo getCommentItemFromSourceData:info];
            // 计算累加Cell高度和
            _commentHeightSum = [NSNumber numberWithFloat:[_commentHeightSum floatValue] + [itemInfo.cell_height floatValue] + 20];
            [listItemArray addObject:itemInfo];
        }
        if ([_commentHeightSum floatValue] > 700) {
            _commentHeightSum = [NSNumber numberWithFloat:700.0];
        }
        // 赋值更新 viewModel 数组（View 通过KVO监听该属性的setter方法）View可以直接通过该数据进行展示
        self.commentItemInfoArray = listItemArray;
    }
}

- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"sourceCommentItemArray"];
}
@end


#pragma mark - Model_To_ViewModel
@implementation DJCommentItemInfo
/// 将原数据模型转为View模型
+ (DJCommentItemInfo *)getCommentItemFromSourceData:(SourceCommentItemInfo *)sourceData {
    DJCommentItemInfo *itemInfo = [[DJCommentItemInfo alloc] init];
    [itemInfo setValue:sourceData.com_text forKey:@"com_text"];
    [itemInfo setValue:sourceData.com_screen_name forKey:@"com_screen_name"];
    [itemInfo setValue:sourceData.com_profile_image_url forKey:@"com_profile_image_url"];
    [itemInfo setValue:[itemInfo dateFormatter:sourceData.com_created_at] forKey:@"com_created_at"];
    [itemInfo setValue:[itemInfo replaceURLsWithLinksInString:sourceData.com_text] forKey:@"textAttributedString"];
    [itemInfo setValue:[itemInfo getViewRegionName:sourceData.com_location] forKey:@"com_location"];
    
    [itemInfo computeCellHeight];

    return itemInfo;
}



#pragma mark - 模型转ViewModel辅助函数
/// 计算View中各个视图的高度
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
    [self setValue:[NSNumber numberWithFloat:labelHeight] forKey:@"text_height"];
    [self setValue:[NSNumber numberWithFloat:labelHeight + 70] forKey:@"cell_height"];
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


/// 富文本文字设置
- (NSAttributedString *)replaceURLsWithLinksInString:(NSString *)string {
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
