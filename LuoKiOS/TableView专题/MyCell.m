//
//  MyCell.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/15.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "MyCell.h"

@interface MyCell ()

@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * descLabel;


@end



@implementation MyCell


+ (instancetype)myCellWithTableView:(UITableView *)tableView {
    
    static NSString * cellID = @"mycell";
    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCell" owner:self options:nil] lastObject];
    }
    
    return cell;
}


- (void)setCellData:(Number *)cellData {
    
    _cellData = cellData;
    self.titleLabel.text = cellData.titleNumber;
    self.descLabel.text = cellData.detailDescription;
    
    
//    self.titleLabel.text = cellData;
//
//    int randomNumber = arc4random_uniform(2);
//    if (randomNumber == 1) {
//        self.descLabel.text = @"在iOS 8中，苹果引入了UITableView的一项新功能–Self Sizing Cells，对于不少开发者来说这是新SDK中一项非常有用的新功能。在iOS 8之前，如果想在表视图中展示可变高度的动态内容时，你需要手动计算行高，而Self Sizing Cells为展示动态内容提供了一个解决方案。";
//    }
//    else {
//        
//        self.descLabel.text = cellData;
//    }
    
}

@end
