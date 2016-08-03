//
//  TableCell.m
//  LuoKiOS
//
//  Created by lkshine on 16/8/2.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.mTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 40)];
        [self.contentView addSubview:self.mTitle];
        
        self.mChoose = [[UISwitch alloc]initWithFrame:CGRectMake(self.bounds.size.width-100, 10, 40, 20)];
        [self.mChoose setOn:YES animated:YES];
        [self.mChoose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.mChoose];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.btn.frame = CGRectMake(150, 10, 60, 20);
        [self.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
        [self.btn setTitle:@"btn" forState:UIControlStateNormal];
        [self.contentView addSubview:self.btn];
    }
    return self;
}


- (void)configureForData:(NSString *)data {
    
    self.mTitle.text = data;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    //    if (_cellActionBlock) {
    //        _cellActionBlock(self.indexPath);
    //    }
    // Configure the view for the selected state
}

- (void)chooseAction:(UISwitch *)sender {
  
    NSLog(@"self.row = %ld", self.indexPath.row);
    self.cellSwitchActionBlock(self.indexPath, self.mChoose);
}

- (void)btnAction:(UIButton *)sender {
    
    NSLog(@"ind = %ld, btn = %@", (long)self.indexPath.row, self.btn);
    self.cellBtnActionBlock(self.indexPath, self.btn);
}


@end
