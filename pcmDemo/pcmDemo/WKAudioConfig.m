//
//  WKAudioConfig.m
//  AudioToolboxDemo
//
//  Created by 曾长欢 on 2022/4/8.
//

#import "WKAudioConfig.h"

@implementation WKAudioConfig


+ (instancetype)defaultConfig {
    return [[WKAudioConfig alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bitrate = 96000;
        self.channelCount = 1;
        self.sampleSize = 16;
        self.sampleRate = 44100;
    }
    return self;
}

@end
