//
//  NetworkProgrammingController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/25.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NetworkProgrammingController.h"

#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法


@interface NetworkProgrammingController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLSessionDelegate, AFMultipartFormData>

@property (nonatomic, strong) NSMutableData *myData;//由于这里面需要拼接数据，所以需要一个容器来保存多次接收的数据

@end

/*
    网络开发流程:

       1. 构造地址NSURL;
       2. 构造请求NSURLRequest;
       3. 构造启动连接NSURLConnection;
       4. 发送同步请求\异步请求;
       5. 代理对象实现协议，用于监听通讯事件.
 */

@implementation NetworkProgrammingController

#pragma mark -- 同步请求直接获取data, 异步请求的以block回调的形式来获取data, 代理方法来获取data(方法有点类似XML的sax解析)
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self postMethod];
    [self getMethod];
//    [self postMethodWithDelegate];
//    [self postMethodWithNSURLSession];
    [self postMethodWithAFNetworking];
    
}


/*
    在iOS下进行网络编程主要分为以下三步:

        1. 客户端向服务器发送请求，请求方式有两种：一种get请求，一种post请求。
            get请求是将信息直接拼接在URL后面，在真正开发中用到比较多。
            post请求是将一些比较重要的信息转化为二进制流。
            在真正开发中post请求常见于验证用户名密码是否正确，给服务器上传数据等。 
            注意不管是get请求还是post请求都是由后台决定的，
            程序员可以通过接口文档知道当前的请求方式是get还是post。
            请求方式不仅仅限于get和post，还有delete和put等，
            除了get请求可以使用NSUrlRequest之外，
            其他请求必须使用NSMutableURLRequset，明确的指定当前的HTTPMethod是什么请求。
        2. 和服务器建立连接
        3. 服务器做出响应
 
 请求方法。其实请求并不单单只有Get、Post这两种。一共有：GET、POST、OPTIONS、HEAD、PUT、DELETE、TRACE、CONNECT、PATCH八种之多。
 
 
     HTTPS和HTTP的区别主要为以下四点：
     https协议需要到ca申请证书，一般免费证书很少，需要交费。
     http是超文本传输协议，信息是明文传输，https 则是具有安全性的ssl加密传输协议。
     http和https使用的是完全不同的连接方式，用的端口也不一样，前者是80，后者是443。
     http的连接很简单，是无状态的；HTTPS协议是由SSL+HTTP协议构建的可进行加密传输、身份认证的网络协议，比http协议安全。
     反正咱们只需要记住一点，HTTPS比HTTP安全
 
 */


#pragma mark - (同步/异步)get请求
- (void)getMethod {

    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 1.URL
    NSURL * url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213"];
    
    // 2.封装请求
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];

/*
    // 3.发送请求
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    // 该方法在iOS9.0之后被废弃
    // 下面的方法有3个参数，参数分别为NSURLRequest，NSURLResponse**，NSError**，后面两个参数之所以传地址进来是为了在执行该方法的时候在方法的内部修改参数的值。这种方法相当于让一个方法有了多个返回值
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // 错误信息
    if (error) {
        
        NSLog(@"%@", [error localizedDescription]);
        // 此处需要解决iOS9.0之后，HTTP不能正常使用的问题，若不做任何处理，会打印“The resource could not be loaded because the App Transport Security policy requires the use of a secure connection” 错误信息。
    }
    
    NSError * newError = nil;
 
     //json转字典
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
    
 //字典转json  [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil]

 
 
 
    // 获取对应的数据信息
    NSArray * array = dictionary[@"news"];
    NSDictionary * dic = array[0];
    NSLog(@"%@", dic[@"title"]);
*/    
    
    // 3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSError * newError = nil;
        
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // 获取数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
        
        NSArray * array = dict[@"news"];
        NSDictionary * dic = array[0];
        NSLog(@"getMethod_news = %@", dic[@"title"]);
        
    }];
   
}

#pragma mark - (同步/异步)post请求
- (void)postMethod {
    
    // 1.获取请求网址
    NSURL * url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?"];
    
    // 2.封装请求
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];  // post
    
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    
    // 设置请求体(会把请求的数据转成data,达到用户信息保密的目的)
    NSData * data = [@"date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
   
/*
    // 3.发送请求
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSError * newError = nil;
    
    // 获取数据
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:&newError];
    
    NSArray * array = dict[@"news"];
    NSDictionary * dic = array[0];
    NSLog(@"%@", dic[@"title"]);
*/
    
    // 3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSError * newError = nil;
        
        // 获取数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&newError];
        
        NSLog(@"Json = %@", dict);
        NSArray * array = dict[@"news"];
        NSDictionary * dic = array[0];
        NSLog(@"news = %@", dic[@"title"]);
        
    }];
    
}


- (void)postMethodWithDelegate {
    
    // 1.获取请求网址
    NSURL *url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?"];
    
    // 2.封装请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];  // post
    
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    
    // 设置请求体(会把请求的数据转成data,达到用户信息保密的目的)
    NSData *data = [@"date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark -- NSURLConnectionDelegate

// 懒加载
- (NSMutableData *)myData {
    
    if(_myData == nil) {
        
        self.myData = [NSMutableData data];
    }
    
    return _myData;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    //  获取到对应错误信息。
    if(error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark -- NSURLConnectionDataDelegate
// 收到服务器响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"收到服务器响应");
}

// 可能多次调用，可以多次拼接获取的数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.myData appendData:data];
    NSLog(@"收到数据");
}

// 完成数据接收
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.myData
                                                        options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                          error:&error];
    
    if (error) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSLog(@"%@", dic);
}

/*
 
    到这里，通过delegate所获取data一套流程基本完成了(需要NSURLConnectionDelegate, NSURLConnectionDataDelegate,两个代理)。
    发送请求时候，如果发送出错，调用didFailWithError:方法来输出错误信息。
    如果没有错误，收到服务器响应，会调用didReceiveResponse:方法。
    然后从服务器返回数据，通过didReceiveData:方法。
    如果数据量比较大，这个方法会多次调用，所以需要拼接获取到得数据。
    最后数据接收完成，会调用connectionDidFinishLoading:方法，这里面可以做数据解析。
 
 */

#pragma mark -- NSURLSession也是一组相互依赖的类，它的大部分组件和NSURLConnection中的组件相同如NSURLRequest，NSURLCache等。而NSURLSession的不同之处在于，它将NSURLConnection替换为NSURLSession和NSURLSessionConfiguration，以及3个NSURLSessionTask的子类：NSURLSessionDataTask, NSURLSessionUploadTask, 和NSURLSessionDownloadTask。

/*
 1. 为什么要使用NSURLSession而不是NSURLConnection
 2. 为什么要用共享的SessionManager/Session，而不是每次都启动一个新的
 
    适应 HTTP /2以快著称， 为了让我们的请求更快，避免每次都产生一个TCP三次握手，成了一个优化的选项，这个优化选项，可以使得客户端和服务器端复用一个TCP连接，从而减小每次的网络请求时间。共享的Session将会复用TCP的连接，而每次都新建Session的操作将导致每次的网络请求都开启一个TCP的三次握手。同样都是两次HTTP请求，共享Session的代码在第二次网络请求时少了TCP的三次握手的过程。即加速了整个网络的请求时间。默认配置下，iOS对于同一个IP服务器的并发最大为4，OS X为6。而如果你没有使用共享的Session，则可能会超过这个数。
 
 因此，如果能用共享的Session，还是用共享的吧。有些许的网络加速，也是一件不错的事情，您说呢？
 ps：http://www.cocoachina.com/ios/20160202/15211.html
 
 */


- (void)postMethodWithNSURLSession {
    // 1.获取请求网址
    NSURL *url = [NSURL URLWithString:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?"];
    
    // 2.封装请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];  // post
    
    // 设置请求方式
    [request setHTTPMethod:@"POST"];
    
    // 设置请求体(会把请求的数据转成data,达到用户信息保密的目的)
    NSData * data = [@"date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    // 创建NSURLSession，设置代理，就要遵守协议,配置为默认配置，代理方法执行在主线程。
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                           delegate:self
                                                      delegateQueue:[NSOperationQueue mainQueue]];
    
    //还有2种创建NSURLSession的方法:
    // NSURLSession *session = [NSURLSession sharedSession];
    // NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request
                                             completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // 获取数据
                                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                                          options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                                                            error:nil];
                                      
                                      NSLog(@"URLSession_dic = %@", dic);
                                  }];
    
    [task resume];
    
}

#pragma mark -- NSURLSessionDelegate
// 在协议的方法中可以完成各种各样的回调动作，如身份验证、完成任务后的动作、错误处理和后台任务完成的动作等。委托方法指定在NSURLSession中一定数量的字节传输使用int64_t类型的参数。
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
    NSLog(@"%s",__func__);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    NSLog(@"%s",__func__);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    NSLog(@"%s",__func__);
}


/*
 
    总结:
    其实这两个类(NSURLConnection/NSURLSession)的使用流程大差不差，
    那么苹果为什么要重构一个NSURLSession来替换NSURLConnection呢？

    与NSURLConnection相比，NSURLSession最直接的改善就是提供了配置每个会话的缓存，协议，cookie和证书政策（credential policies），
    甚至跨应用程序共享它们的能力。这使得框架的网络基础架构和部分应用程序独立工作，而不会互相干扰。
    每一个NSURLSession对象都是根据一个NSURLSessionConfiguration初始化的，
    该NSURLSessionConfiguration指定了上面提到的政策，以及一系列为了提高移动设备性能而专门添加的新选项。

    NSURLSession的另一重要组成部分是会话任务，它负责处理数据的加载，
    以及客户端与服务器之间的文件和数据的上传下载服务。
    NSURLSessionTask与NSURLConnection是及其相似的，因为它负责加载数据，
    而主要的区别在于，任务共享它们父类NSURLSession的共同委托（common delegate）。

    简而言之，就是在处理多任务上传下载，频繁切换前台后台的时候，NSURLSession明显是有很大的优势。
    如果只是像咱们上面这样简单的获取一个JSon数据，其实是看不出来什么差别的，反而还会觉得NSURLSession比较麻烦，毕竟先入为主。
 
 
 */


#pragma mark -- AFNetworking

- (void)postMethodWithAFNetworking {
    
    // 请求的参数
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

// 顺带一提
//     服务器返回的数据解析的几种方式
    
//     解析服务器返回的普通数据(直接使用 *服务器本来返回的数据* 不作任何解析)
//     mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//     
//     解析服务器返回的XML数据
//     mgr.responseSerializer = [AFXMLParserResponseSerializer serializer];
//     
//     解析服务器返回的JSON数据 (默认解析的是JSON可以不传)
//     mgr.responseSerializer = [AFJSONRequestSerializer serializer];


    // post请求
//    [manager POST:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?" parameters:dic constructingBodyWithBlock:^(id  _Nonnull formData) {
//        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        // 这里可以获取到目前的数据请求的进度
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        // 请求成功，解析数据
//        NSLog(@"%@", responseObject);
//        
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        
//        NSLog(@"%@", dic);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        // 请求失败
//        NSLog(@"%@", [error localizedDescription]);
//    }];
//    
    
    [manager POST:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 请求成功，解析数据
        NSLog(@"%@", responseObject);
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);

    }];
    
}

#pragma mark -- 不知道为什么AFNetworking的进度条代码方法不能用

- (void)getMethodWithAFNetworking {
    
//    // 请求的参数
//    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"20131129", @"date", @"1", @"startRecord", @"5", @"len", @"1234567890", @"udid", @"Iphone", @"terminalType", @"213", @"cid", nil];
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // Get请求
//    [manager GET:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        // 这里可以获取到目前的数据请求的进度
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        // 请求成功，解析数据
//        NSLog(@"%@", responseObject);
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        
//        NSLog(@"%@", dic);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        // 请求失败
//        NSLog(@"%@", [error localizedDescription]);
//    }];
    
    [manager GET:@"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx?date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 请求成功，解析数据
        NSLog(@"%@", responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@", dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    
}



/*
 
 
 AFNetworking内部类说明如下
 
 AFURLConnectionOperation:一个 NSOperation 实现了NSURLConnection 的代理方法.
 
 HTTP Requests:
 
 AFHTTPRequestOperation:AFURLConnectionOperation的子类,当request使用的协议为HTTP和HTTPS时,它压缩了用于决定request是否成功的状态码和内容类型.
 
 AFJSONRequestOperation:AFHTTPRequestOperation的一个子类,用于下载和处理jason response数据.
 
 AFXMLRequestOperation:AFHTTPRequestOperation的一个子类,用于下载和处理xml response数据.
 
 AFPropertyListRequestOperation:AFHTTPRequestOperation的一个子类,用于下载和处理property list response数据.
 
 HTTP CLIENT:
 
 AFHTTPClient:捕获一个基于http协议的网络应用程序的公共交流模式.包含:
 
 使用基本的url相关路径来只做request
 为request自动添加设置http headers.
 使用http 基础证书或者OAuth来验证request
 为由client制作的requests管理一个NSOperationQueue
 从NSDictionary生成一个查询字符串或http bodies.
 从request中构建多部件
 自动的解析http response数据为相应的表现数据
 在网络可达性测试用监控和响应变化.
 IMAGES
 
 AFImageRequestOperation:一个AFHTTPRequestOperation的子类,用于下载和处理图片.
 
 UIImageView+AFNetworking:添加一些方法到UIImageView中,为了从一个URL中异步加载远程图片
 
 */
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end

/*
 
    总结 服务器请求方式get/post与网络请求方式同步/异步的4种组合：

        主要区别还是在3.发送请求这里，sendAsynchronousRequest:有几个参数，
        第一个请求不需要介绍了，
        第二个是线程，前面说过这里会涉及到线程相关知识，
        只需要记住这里只用在主线程就可以了（一般接收到数据后回到主线程，有些时候还是按需求而定），然后就是后面的block，通过回调获得请求的数据。这就是为什么它能够做到异步。
        粗略的理解就是，用户的点击操作都是在主线程完成的，
        如果你在主线程里发送网络请求，获取服务器响应，
        那么用户的操作就会被阻塞，使得应用就跟死了一样，不会接收到用户的任何操作。
        异步发送请求，会将网络请求响应这一块放到一个新的线程，
        用户还是可以该做什么做什么，互不干扰，当获取到服务器数据，
        就需要回到主线程，来显示和处理这些数据，
        这也是为什么queue:的参数是[NSOperationQueue mainQueue]。

    举一个平常咱们经常会看到的例子：你在用这一类app看新闻或者刷贴吧的时候，
    有没有注意到经常我们滑动到下面的视图，上面的图片并没有全部都显示上去，
    而是过一会，图片就自动出现了。这就是异步的效果，如果是同步请求，
    不等到图片被请求下来，你的界面只会卡在哪里，你什么也干不了，是不是很反人类？
 
 */
