//
//  Base1VC.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/28.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "Base1VC.h"
#import "Base1View.h"
#import "TestClass.h"

@interface Base1VC ()<TapActionDelegate>

@property (nonatomic, strong) Base1View * base1View;

@end




@implementation Base1VC

- (Base1View *)base1View {
    
    if (!_base1View) {
        
        _base1View = [[Base1View alloc]init];
        _base1View.frame = CGRectMake(90, 90, 150, 150);
        _base1View.backgroundColor = [UIColor greenColor];
        
        //确保了Base1View.m的判断语句if(self.delegate && ...){}中得self.delegate不为空
//        _base1View.delegate = self;
        
        //block来了,注意循环引用哟
        // 关于block的循环引用解决http://www.jianshu.com/p/17872da184fb
        //http://my.oschina.net/leejan97/blog/209762
        __weak typeof (self)weakSelf = self;
        //这里补充一句，感谢兔子的教导，float这种基本类型需要用 __block，引用类型用 __weak，对block内的使用者弱化引用，就不会在发生循环引用(retain cycle)的问题了
        _base1View.tapActionBlock = ^(){
            [weakSelf  blockAction];
        };
    }
    return _base1View;
}

/*
 我用Base1View 一个view不具备控制器能力，但是需要做控制器的操作，比如页面跳转
 
 */
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.base1View];
    [self demo];
}



#pragma mark -- 对于block的循环引用问题这个Demo将会是很好的诠释 http://www.jianshu.com/p/7a9c8c8e53a0
- (void)demo {
    
    TestClass *person = [[TestClass alloc]init];
    __weak TestClass * weakPerson = person;
    person.midBlock = ^{
        
        __strong typeof (weakPerson)strongPerson = weakPerson;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [strongPerson test];
        });
    };
    person.midBlock();
}// 作用域问题影响对象的生命周期，所以为了解决循环引用，__weak对象后再放进block里调用，如果block执行时该对象已经销毁了，又要掉该对象呢，就必须在 __strong该已被弱化的对象，强持有话了


//确保了Base1View.m的判断语句if(self.delegate && ...){}中得&&后者不为空
- (void)pushToNext {
    [self jumpPage];
}//遵守协议后，实现协议方法，就完成代理了


- (void)blockAction {
    [self jumpPage];
}



//这个才是我们拐那么多弯，要让控制器帮我们帮的事
- (void)jumpPage {
    
    NullVC * vc = [[NullVC alloc] init];
    vc.view.backgroundColor = [UIColor orangeColor];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end


