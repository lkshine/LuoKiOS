//
//  CustomPageCtrl.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/19.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "CustomPageCtrl.h"

@implementation CustomPageCtrl

-(id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    activeImage = [UIImage imageNamed:@"RedPoint.png"];
    inactiveImage = [UIImage imageNamed:@"BluePoint.png"];
    
    return self;
}


#pragma mark -- 换图
-(void) updateDots {
    
    for (int i = 0; i < [self.subviews count]; i++) {
        
        UIView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) dot.backgroundColor = [UIColor colorWithPatternImage:activeImage];
        else dot.backgroundColor = [UIColor colorWithPatternImage:inactiveImage];
        
    }
}


#pragma mark -- 变形
- (void)transform:(NSInteger)page {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 10;
        size.width = 10;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y, size.width,size.height)];
        
        if (subviewIndex == page) {
            
            [subview setBackgroundColor:self.currentPageIndicatorTintColor];
        }
        else {
            
            [subview setBackgroundColor:self.pageIndicatorTintColor];
        }
        
    }
}


-(void) setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    [self updateDots];
    [self transform:page];

}


@end


