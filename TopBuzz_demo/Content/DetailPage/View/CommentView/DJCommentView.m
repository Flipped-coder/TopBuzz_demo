//
//  DJCommentView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentView.h"
#import "DJCommentViewCell.h"

@interface DJCommentView () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (nonatomic, strong) NSArray <DJCommentItemInfo *> *itemInfoArray;
@property (nonatomic, strong) DJCommentViewCell *cell;

@end

@implementation DJCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.bounces = YES;
    }
    return self;
}



- (void)loadCommentData:(NSArray <DJCommentItemInfo *> *)itemInfo {
    _itemInfoArray = itemInfo;
    
    [self reloadData];
    
    
    NSLog(@"");
    
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
     _cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
     if (_cell == nil) {
         _cell = [[DJCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
    [_cell loadCommentCellWithData:_itemInfoArray[indexPath.row]];
    _cell.textView.delegate = self;
    
    return _cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return _itemInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [_itemInfoArray[indexPath.row].cell_height floatValue];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    // 在这里控制是否允许点击
    return NO;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_DEPRECATED("Replaced by primaryActionForTextItem: and menuConfigurationForTextItem: for additional customization options.", ios(10.0, 17.0), visionos(1.0, 1.0)) {
    
    if ([_dj_delegate respondsToSelector:@selector(pushWebViewWithURL:)]) {
        [_dj_delegate pushWebViewWithURL:URL];
    }
    
    return NO;
}


@end
