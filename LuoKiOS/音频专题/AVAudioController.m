//
//  AVAudioController.m
//  iOS知识点总结项目
//
//  Created by lkshine on 16/5/11.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "AVAudioController.h"

/*
    要想使用封装好的音频类,给工程导入音频的框架（AVFoundation.framework）,
    导入音频类头文件（AVFoundation/AVFoundation.h）,缺一不可;
 */
#import <AVFoundation/AVFoundation.h>
@interface AVAudioController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer     * player;       //播放对象
@property (nonatomic,strong)  NSURL             * url;          //录音文件保存所在地的URL
@property (nonatomic,strong) AVAudioRecorder    * recorder;     //录音对象
@property (nonatomic,strong) AVAudioPlayer      * recorderPlay; //录音文件的播放对象
@property (weak, nonatomic) IBOutlet UIButton   * weChatBtn;

@end

@implementation AVAudioController


#pragma mark --LazyLoad
- (AVAudioPlayer *)player {
    
    if (_player == nil) {
        NSString *urlString = [[NSBundle mainBundle] pathForResource:@"Deep Side - Booty Music" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath: urlString];
        
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error) {
            NSLog(@"%@",error);
        }
        
        //准备播放
        [_player prepareToPlay];
        
        //设置代理
        self.player.delegate = self;
        
    }
    return _player;
}


- (NSURL *)url {
    
    if (!_url) {
        
        //录音文件都是存在每个应用程序的temp文件夹下
        NSString * tempDir = NSTemporaryDirectory();
        NSString * urlPath = [tempDir stringByAppendingString:@"record.caf"];
        _url = [NSURL fileURLWithPath:urlPath];
    }
    
    return _url;
}


- (AVAudioPlayer *)recorderPlay {
    
    if (_recorderPlay == nil) {
        
        NSError *error = nil;
        _recorderPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:self.url error:&error];
        _recorderPlay.volume = 1.0;
        
        _recorderPlay.delegate = self;
        
        if (error) {
            NSLog(@"player error:%@",error);
        }
    }
    return _recorderPlay;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self player];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressRecorder:)];
    
    [self.weChatBtn addGestureRecognizer:longPress];
    
}

#pragma mark -- 微信长按录音功能简单模拟
- (void)longPressRecorder:(UIGestureRecognizer *)sender {
    
    NSLog(@"%s",__func__);
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.weChatBtn setTitle:@"recording....." forState:UIControlStateNormal];
        self.weChatBtn.alpha = 0.5;
        //开始录音
        [self startRecord];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.weChatBtn setTitle:@"longPressRecorder" forState:UIControlStateNormal];
        self.weChatBtn.alpha = 1;
        //结束录音
        [self endRecord];
    }
}

//代码封装，易于调用
- (void)startRecord {
    NSError *error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (session!=nil) {
        [session setActive:YES error:nil];
    }else {
        NSLog(@"session error:%@",error);
    }
    
    //注意：需要在每次点击开始录音时初始化recorder对象
    NSDictionary *recorderSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:16000.0],AVSampleRateKey,
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                                      nil];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:recorderSettings error:&error];
    if (error) {
        NSLog(@"recoder error:%@",error);
    }
    
    //开始录音
    [self.recorder prepareToRecord];
    [self.recorder record];
}

- (void)endRecord {
    [self.recorder stop];
    self.recorder = nil;
}

#pragma mark -- 播放
- (IBAction)play:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.player play];
    
}


- (IBAction)pause:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.player pause];
    
}


- (IBAction)stop:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.player stop];
}


- (IBAction)slider:(UISlider *)sender {
    
    NSLog(@"%s",__func__);
    self.player.volume = sender.value;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -- 录音
- (IBAction)start:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    
    //1  激活AVAudioSession
    NSError * error = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    //判断后台有没有播放
    if (session != nil) {
        
        [session setActive:YES error:nil];
    }
    else {
        
        NSLog(@"session error: %@", error);
    }
    
    //2  设置AVAudioRecorder类的settings属性
    NSDictionary *recorderSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:16000.0],AVSampleRateKey,
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                                      nil];
    
    
    //3  初始化record对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.url settings:recorderSettings error:&error];
    
    if (error) {
        
        NSLog(@"recorder error: %@", error);
    }
    
    
    //4  开始录音
    [self.recorder record];
    
}


- (IBAction)over:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    [self.recorder stop];
    //释放self.recorder,否则无法更新录音文件，即不能进行二次录音
    self.recorder = nil;
}


- (IBAction)playVoice:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
    
    [self.recorderPlay play];
}


- (IBAction)stopVoice:(UIButton *)sender {
    
    NSLog(@"%s",__func__);
    [self.recorderPlay pause];
}


#pragma mark -- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    NSLog(@"%s",__func__);
    
    //在播放完毕录音后，需要及时销毁AVAudioPlayer对象，否则无法播放新的录音文件。因此，需要使用到AVAudioPlayer类的代理方法，当播放完毕后，销毁AVAudioPlayer对象。
    self.player = nil;
    self.recorderPlay = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    
    NSLog(@"%s",__func__);
}

//设置一个定时的闹钟可以演示中断效果，在对应方法里做相应操作设置即可
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
    NSLog(@"%s",__func__);
    [self.player pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags {
 
    NSLog(@"%s",__func__);
    [self.player play];
   
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    
    NSLog(@"%s",__func__);
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    
    NSLog(@"%s",__func__);
}

@end
