//
//  WKAudioConfig.h
//  AudioToolboxDemo
//
//  Created by 曾长欢 on 2022/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKAudioConfig : NSObject
@property (nonatomic, assign) NSInteger bitrate;
@property (nonatomic, assign) NSInteger channelCount;
@property (nonatomic, assign) NSInteger sampleRate;
@property (nonatomic, assign) NSInteger sampleSize;

+ (instancetype)defaultConfig;

- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
