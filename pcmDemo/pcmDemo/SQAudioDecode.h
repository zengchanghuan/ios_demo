//
//  SQAudioDecode.h
//  pcmDemo
//
//  Created by 曾长欢 on 2022/4/9.
//

#import <Foundation/Foundation.h>
#import "WKAudioConfig.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SQAudioDecoderDelegate <NSObject>
- (void)audioDecodeCallback:(NSData *)pcmData;
@end

@interface SQAudioDecode : NSObject

@property (nonatomic, strong) WKAudioConfig *config;
@property (nonatomic, weak) id<SQAudioDecoderDelegate> delegate;

//初始化 传入解码配置
- (instancetype)initWithConfig:(WKAudioConfig *)config;

/**解码aac*/
- (void)decodeAudioAACData: (NSData *)aacData;

@end

NS_ASSUME_NONNULL_END
