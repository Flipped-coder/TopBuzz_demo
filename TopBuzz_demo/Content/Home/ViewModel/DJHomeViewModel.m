//
//  DJHomeViewModel.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/12.
//

#import "DJHomeViewModel.h"
#import "DJScreen.h"
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
    itemInfo.likeNumber = [sourceData.attitudes_count stringValue];
    itemInfo.picInfos = sourceData.pic_urls;

    itemInfo.imageWidth = sourceData.pic_urls[0].width;
    itemInfo.imageHeight = sourceData.pic_urls[0].height;
    
    [itemInfo computeItemCellHeight];
    
    return itemInfo;
}



- (void)computeItemCellHeight {
    float cellWidth = (SCREEN_WIDTH - 10) / 2;
    float imageHight = [self.imageHeight floatValue] * (cellWidth / [self.imageWidth floatValue]);
    
    CGFloat labelWidth = 180; // UILabel 的宽度

    // 使用 NSAttributedString 来设置字体和段落样式，确保计算的高度与实际显示时一致
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12.0] // 你的字体大小
    };

    // 计算字符串在给定宽度下的尺寸
    CGRect boundingRect = [self.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:attributes
                                                   context:nil];
    // 获取计算出的高度
    CGFloat labelHeight = CGRectGetHeight(boundingRect);
    if (labelHeight > 35) {
        labelHeight = 35;       // 外流只展示两行
    }
    
    self.cellHeight = [NSNumber numberWithFloat:imageHight + labelHeight + 40];
}


@end

