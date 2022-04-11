//
//  ViewController.m
//  AudioToolboxDemo
//
//  Created by 曾长欢 on 2022/4/8.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ZJAudioFileStream.h"

/**
 iOS
 iOS平台提供了AVFoundation库，用于音视频操作。我们可以基于它直接提取出整首歌的PCM数据，然后计算出分贝值。大体流程如下所示：

 首先通过AVAudioFile加载本地音频文件，获取采样率、声道数等音频信息。
 接着通过上述采样率、声道数以及采样点格式AVAudioCommonFormat构建AVAudioFormat，表示一种音频格式。
 然后通过AVAudioFormat和音频采样帧数（等于采样率乘以时长）构建AVAudioPCMBuffer，并且通过AVAudioFile.read把音频数据解码到AVAudioPCMBuffer，获取到解码后的PCM Buffer。
 AVAudioPCMBuffer包含了多个声道的数据，多个声道的数据是如何存储的那？可以通过AVAudioFormat.isInterleaved进行判断，若是true，则表示多个声道数据是交替存储的，即：LRLRLRLR方式，若是false，则表示多个声道数据是分开存储的，即：LLLLRRRR模式。
 最后基于AVAudioPCMBuffer提供的PCM数据，针对单一声道，计算出分贝值，计算方式与Android平台类似
 */
@interface ViewController ()<AVAudioPlayerDelegate,ZJAudioFileStreamDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer; // 播放
@property (nonatomic, strong) ZJAudioFileStream *audioFileStream;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 60, 44)];
    playBtn.backgroundColor = [UIColor purpleColor];
    [playBtn setTitle:@"play" forState:UIControlStateNormal];
    [self.view addSubview:playBtn];

    [playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 180, 60, 44)];
    stopBtn.backgroundColor = [UIColor purpleColor];
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [self.view addSubview:stopBtn];
    
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
  
    

}

- (void)playMusic {
    NSString *path = [self musicPath];
    if (path != NULL && ![path isEqualToString:@""]) {
        [self audioPlayWithFilePath:path];
        [self setupAudioFileStream:path];

    } else {
        NSLog(@"path is null");
    }
    
  
}

- (void)stop {
    [self audioPlayerStop];
}
- (NSString *)musicPath {
    // 获取main bundle
    NSBundle *mainBundle = [NSBundle mainBundle];
    // 放在app mainBundle中的自定义Test.bundle
    NSString *testBundlePath = [mainBundle pathForResource:@"music" ofType:@"bundle"];
    NSBundle *testBundle = [NSBundle bundleWithPath:testBundlePath];
    // 放在自定义Test.bundle中的图片
    NSString *resPath = [testBundle pathForResource:@"m_set_21" ofType:@"mp3"];
    NSLog(@"自定义bundle中资源的路径: %@", resPath);
    return resPath;
}
- (void)audioPlayWithFilePath:(NSString *)filePath
{
    if (self.audioPlayer)
    {
        // 判断当前与下一个是否相同
        // 相同时，点击时要么播放，要么停止
        // 不相同时，点击时停止播放当前的，开始播放下一个
        NSString *pathPrevious = [self.audioPlayer.url relativeString];
//
//        pathPrevious = [pathPrevious stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        pathPrevious = [pathPrevious stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

        /*
         NSString *currentName = [self getFileNameAndType:currentStr];
         NSString *nextName = [self getFileNameAndType:filePath];

         if ([currentName isEqualToString:nextName])
         {
             if ([self.audioPlayer isPlaying])
             {
                 [self.audioPlayer stop];
                 self.audioPlayer = nil;
             }
             else
             {
                 self.audioPlayer = nil;
                 [self audioPlayerPlay:filePath];
             }
         }
         else
         {
             [self audioPlayerStop];
             [self audioPlayerPlay:filePath];
         }
         */

        // currentStr包含字符"file://location/"，通过判断filePath是否为currentPath的子串，是则相同，否则不同
        NSRange range = [pathPrevious rangeOfString:filePath];
        if (range.location != NSNotFound)
        {
            if ([self.audioPlayer isPlaying])
            {
                [self.audioPlayer stop];
                self.audioPlayer = nil;
            }
            else
            {
                self.audioPlayer = nil;
                [self audioPlayerPlay:filePath];
            }
        }
        else
        {
            [self audioPlayerStop];
            [self audioPlayerPlay:filePath];
        }
    }
    else
    {
        [self audioPlayerPlay:filePath];
    }
}

- (void)audioPlayerPlay:(NSString *)filePath
{
    // 判断将要播放文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist)
    {
        return;
    }

    NSURL *urlFile = [NSURL fileURLWithPath:filePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFile error:nil];
    self.audioPlayer.delegate = self;
    if (self.audioPlayer)
    {
        if ([self.audioPlayer prepareToPlay])
        {
            // 播放时，设置喇叭播放否则音量很小
            AVAudioSession *playSession = [AVAudioSession sharedInstance];
            [playSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            [playSession setActive:YES error:nil];

            [self.audioPlayer play];
        }
    }
}

- (void)audioPlayerStop
{
    if (self.audioPlayer)
    {
        if ([self.audioPlayer isPlaying])
        {
            [self.audioPlayer stop];
        }

        self.audioPlayer.delegate = nil;
        self.audioPlayer = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    
}

#pragma mark - AACEncodeDelegate
- (void)AACCallBackData:(NSData *)audioData;
{
    NSLog(@"audioDecodeCallback");
}
#pragma mark - ZJAudioFileStreamDelegate
- (void)audioFileStream:(ZJAudioFileStream *)audioFileStream audioDataParsed:(NSArray *)audioData
{
    
}
- (void)audioFileStreamReadyToProducePackets:(ZJAudioFileStream *)audioFileStream {
    
}
#pragma mark - Private Method
- (void)setupAudioFileStream:(NSString *)path
{
    NSError *error = nil;
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];

    _audioFileStream = [[ZJAudioFileStream alloc]initWithFileType:kAudioFileMP3Type fileSize:fileSize error:&error];

//    _audioFileStream = [[ZJAudioFileStream alloc]initWithFileType:kAudioFileFLACType fileSize:fileSize error:&error];
    _audioFileStream.delegate = self;
    
    if (error) {
        _audioFileStream = nil;
        NSLog(@"create file stream failed ,error : %@",[error description]);
    }else{
        NSLog(@"audio file open");
        if (file) {
            NSUInteger lengthPerRead = 10000;
            while (fileSize > 0) {
                NSData *data = [file readDataOfLength:lengthPerRead];
                fileSize -= [data length];
                [_audioFileStream parseData:data error:&error];
                if (error) {
                    if (error.code == kAudioFileStreamError_NotOptimized) {
                        NSLog(@"audio not  optimized");
                    }
                    break;
                }
            }
            
            NSLog(@"audio format: bitrate = %zd, duration = %lf.",_audioFileStream.bitRate,_audioFileStream.duration);
            [_audioFileStream close];
            _audioFileStream = nil;
            NSLog(@"xxxxxxxxx_________xxxxxxxxxx");
            [file closeFile];
        }
    }
    
}


@end
