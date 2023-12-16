//
//  DJCommentView.m
//  TopBuzz_demo
//
//  Created by 邓杰 on 2023/12/16.
//

#import "DJCommentView.h"
#import "DJCommentViewCell.h"

@interface DJCommentView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray <DJCommentItemInfo *> *itemInfoArray;
@property (nonatomic, strong) DJCommentViewCell *cell;

@end

@implementation DJCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
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
    return _cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return _itemInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [_itemInfoArray[indexPath.row].cell_height floatValue];
}

@end
