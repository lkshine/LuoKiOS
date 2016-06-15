//
//  PickerViewController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/20.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "PickerViewController.h"



@interface PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) NSDictionary *dic;//存放要选择的数据
@property (nonatomic, strong) NSArray *provinceArray;//存放第一列省份数据的数组
@property (nonatomic, strong) NSString *selectedProvince;//第一列中选中的数据

@end



@implementation PickerViewController


#pragma mark -- LazyLoad
- (UIPickerView *)myPickerView {
    
    if (!_myPickerView) {
        
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 193, 375, 216)];
        _myPickerView.dataSource = self;
        _myPickerView.delegate = self;
        [self.view addSubview:_myPickerView];
    }
    
    return _myPickerView;
}


// 设置相关的字典和数组
- (NSDictionary *)dic {
    
    if (!_dic) {
        
        _dic = @{@"江苏": @[@"南京",@"徐州",@"镇江",@"无锡",@"常州"],@"山西":@[@"太原",@"平遥",@"大同"]};
    }
    
    return _dic;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self dic];
    
    //使用provinceArray保存dic中所有key组成的NSArray排序后的结果
    self.provinceArray = [[self.dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //设置默认选中的省份是provinceArray中的第一个元素
    self.selectedProvince = self.provinceArray[0];
    [self myPickerView];
    
}


#pragma mark -- UIPickerViewDataSource & UIPickerViewDelegate
//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}

//设置每一列对应的元素个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    //如果是第一列返回provinceArray中元素的个数
    if (component == 0) {
        
        return self.provinceArray.count;
    }
    
    //如果是第二列返回self.dic中self.selectedProvince对应的元素个数
    return [self.dic[self.selectedProvince] count];
}


//返回指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    //如果是第一列返回self.provinceArray中row索引处的元素
    if (component == 0) {
        
        return self.provinceArray[row];
    }
    
    //其他列则返回dic中self.selectedProvince对应的数组中row索引处的元素
    return [self.dic[self.selectedProvince] objectAtIndex:row];
}


//当用户选中指定项时候调用该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        
        //改变被选中的省份
        self.selectedProvince = self.provinceArray[row];
        //根据选中省份重新加载第二个列表
        [self.myPickerView reloadComponent:1];
        //保证第二列中选中标记的元素始终是第一个
        [self.myPickerView selectRow:0 inComponent:1 animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}




@end



