//
//  DJHomeNetworking.h
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/17.
//

#import <Foundation/Foundation.h>
#import "DJHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJHomeNetworking : NSObject

/// 请求网络资源数据
/// - Parameters:
///   - type: 资讯类型
///   - page: 请求范围
///   - model: 需要转换的模型
+ (void)loadSourceDataItemInfoListWithRequestType:(RequestType)type Page:(int)page model:(DJHomeModel *)model;

@end

NS_ASSUME_NONNULL_END
