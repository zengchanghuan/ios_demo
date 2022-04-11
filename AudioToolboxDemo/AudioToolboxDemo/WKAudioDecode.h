//
//  WKAudioDecode.h
//  AudioToolboxDemo
//
//  Created by 曾长欢 on 2022/4/8.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "WKAudioConfig.h"
NS_ASSUME_NONNULL_BEGIN

@protocol WKAudioDecoderDelegate <NSObject>
- (void)audioDecodeCallback:(NSData *)pcmData;
@end

@interface WKAudioDecode : NSObject
@property (nonatomic, strong) WKAudioConfig *config;
@property (nonatomic, weak) id<WKAudioDecoderDelegate> delegate;

//初始化 传入解码配置
- (instancetype)initWithConfig:(WKAudioConfig *)config;

/**解码aac*/
- (void)decodeAudioAACData: (NSData *)aacData;

@end

NS_ASSUME_NONNULL_END
