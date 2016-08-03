//
//  TableCell.h
//  LuoKiOS
//
//  Created by lkshine on 16/8/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (retain,nonatomic ) UILabel     * mTitle;
@property (retain,nonatomic ) UISwitch    * mChoose;
@property (nonatomic, strong) UIButton    * btn;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, copy) void(^cellSwitchActionBlock)(NSIndexPath *indexPath, UISwitch * chooseSwitch);
@property (nonatomic, copy) void(^cellBtnActionBlock)(NSIndexPath *indexPath, UIButton * btn);

- (void)configureForData:(NSString *)data;

@end
