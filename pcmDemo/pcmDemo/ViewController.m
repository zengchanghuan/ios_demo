//
//  ViewController.m
//  pcmDemo
//
//  Created by 曾长欢 on 2022/4/9.
//

#import "ViewController.h"
#import "WKAudioConfig.h"
#import "SQAudioDecode.h"

@interface ViewController ()<SQAudioDecoderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *audioURLString = [self musicPath];
    NSData *data = [NSData dataWithContentsOfFile:audioURLString];
    
    WKAudioConfig *config = [[WKAudioConfig alloc] init];
    
    SQAudioDecode *decode = [[SQAudioDecode alloc] initWithConfig:config];
    decode.delegate = self;
    [decode decodeAudioAACData:data];
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

#pragma mark - SQAudioDecoderDelegate
- (void)audioDecodeCallback:(NSData *)pcmData
{
    NSLog(@"audioDecode pcmData %p",pcmData);
}
@end
