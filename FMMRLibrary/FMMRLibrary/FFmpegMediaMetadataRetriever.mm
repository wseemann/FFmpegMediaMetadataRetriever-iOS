//
//  FFmpegMediaMetadataRetriever.mm
//  FFmpegMediaMetadataRetriever
//
//  Created by William Seemann on 12/4/14.
//  Copyright (c) 2014 William Seemann. All rights reserved.
//

/*
 * FFmpegMediaMetadataRetriever-iOS: Port of FFmpegMediaMetadataRetriever for
 * iOS. A unified interface for retrieving frame and meta data from an
 * input media file.
 *
 * Copyright 2016 William Seemann
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FFmpegMediaMetadataRetriever.h"
#import "mediametadataretriever.h"

#include <libavformat/avformat.h>

@implementation FFmpegMediaMetadataRetriever

MediaMetadataRetriever *mmr = NULL;

- (id) init
{
    self = [super init];
    if (self) {
        mmr = new MediaMetadataRetriever();
    }
    return self;
}

- (void) dealloc {
    delete mmr;
}

- (NSInteger)setDataSourceFromPath:(const NSString *)path
{
    return [self setDataSourceFromUri: path header: NULL];
}

- (NSInteger)setDataSourceFromUri:(const NSString *)uri header:(const NSString *)headers
{
    if (headers == NULL) {
        return mmr->setDataSource([uri UTF8String], NULL);
    } else {
        return mmr->setDataSource([uri UTF8String], [headers UTF8String]);
    }
}

- (NSInteger)setDataSourceFromFDWithOffset:(NSInteger)fd offset:(int64_t)offset length:(int64_t)length
{
    return mmr->setDataSource((int) fd, offset, length);
}

- (NSInteger)setDataSourceFromFD:(NSInteger)fd
{
    return [self setDataSourceFromFDWithOffset: (int) fd offset: 0 length: 0x7ffffffffffffffL];
}

- (UIImage *)getFrameAtTimeWithOptions:(int64_t)timeUs option:(NSInteger)option
{
    AVPacket pkt;
    UIImage *image = NULL;
    
    av_init_packet(&pkt);
    if (mmr->getFrameAtTime(timeUs, (int) option, &pkt) == 0) {
        NSMutableData *data = [NSMutableData new];
        [data appendBytes:(const void *) pkt.data length: pkt.size];
        image = [UIImage imageWithData: data];
    }
    av_packet_unref(&pkt);
    
    return image;
}

- (UIImage *)getFrameAtTime:(int64_t)timeUs
{
    return [self getFrameAtTimeWithOptions: timeUs option: OPTION_CLOSEST_SYNC];
}

- (UIImage *)getFrame
{
    return [self getFrameAtTimeWithOptions: -1 option: OPTION_CLOSEST_SYNC];
}

- (UIImage *)getScaledFrameAtTime:(int64_t)timeUs width:(NSInteger)width height:(NSInteger)height
{
    AVPacket pkt;
    UIImage *image = NULL;
    
    av_init_packet(&pkt);
    if (mmr->getScaledFrameAtTime(timeUs, OPTION_CLOSEST_SYNC, &pkt, (int) width, (int) height) == 0) {
        NSMutableData *data = [NSMutableData new];
        [data appendBytes:(const void *) pkt.data length: pkt.size];
        image = [UIImage imageWithData: data];
    }
    av_packet_unref(&pkt);
    
    return image;
}

- (UIImage *)getEmbeddedPicture
{
    AVPacket pkt;
    UIImage *image = NULL;
    
    av_init_packet(&pkt);
    if (mmr->extractAlbumArt(&pkt) == 0) {
        NSMutableData *data = [NSMutableData new];
        [data appendBytes:(const void *) pkt.data length: pkt.size];
        image = [UIImage imageWithData: data];
    }
    av_packet_unref(&pkt);
    
    return image;
}

- (const NSString *)extractMetadata:(const NSString*)key
{
    const char *value = mmr->extractMetadata([key UTF8String]);
    
    if (!value) {
        return NULL;
    }
    
    return [NSString stringWithUTF8String: value];
}

- (const NSString *)extractMetadataFromChapter:(const NSString*)key chapter:(NSInteger)chapter
{
    const char *value = mmr->extractMetadataFromChapter([key UTF8String], (int) chapter);
    
    if (value) {
        return NULL;
    }
    
    return [NSString stringWithUTF8String: value];
}

+ (void)release
{
    delete mmr;
}

@end
