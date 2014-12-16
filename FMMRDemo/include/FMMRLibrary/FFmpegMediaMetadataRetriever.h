//
//  FFmpegMediaMetadataRetriever.h
//  FFmpegMediaMetadataRetriever
//
//  Created by William Seemann on 12/4/14.
//  Copyright (c) 2014 William Seemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// metadata keys
static const NSString * METADATA_KEY_ALBUM = @"album";
static const NSString * METADATA_KEY_ALBUM_ARTIST = @"album_artist";
static const NSString * METADATA_KEY_ARTIST = @"artist";
static const NSString * METADATA_KEY_COMMENT = @"comment";
static const NSString * METADATA_KEY_COMPOSER = @"composer";
static const NSString * METADATA_KEY_COPYRIGHT = @"copyright";
static const NSString * METADATA_KEY_CREATION_TIME = @"creation_time";
static const NSString * METADATA_KEY_DATE = @"date";
static const NSString * METADATA_KEY_DISC = @"disc";
static const NSString * METADATA_KEY_ENCODER = @"encoder";
static const NSString * METADATA_KEY_ENCODED_BY = @"encoded_by";
static const NSString * METADATA_KEY_FILENAME = @"filename";
static const NSString * METADATA_KEY_GENRE = @"genre";
static const NSString * METADATA_KEY_LANGUAGE = @"language";
static const NSString * METADATA_KEY_PERFORMER = @"performer";
static const NSString * METADATA_KEY_PUBLISHER = @"publisher";
static const NSString * METADATA_KEY_SERVICE_NAME = @"service_name";
static const NSString * METADATA_KEY_SERVICE_PROVIDER = @"service_provider";
static const NSString * METADATA_KEY_TITLE = @"title";
static const NSString * METADATA_KEY_TRACK = @"track";
static const NSString * METADATA_KEY_VARIANT_BITRATE = @"bitrate";
static const NSString * METADATA_KEY_DURATION = @"duration";
static const NSString * METADATA_KEY_AUDIO_CODEC = @"audio_codec";
static const NSString * METADATA_KEY_VIDEO_CODEC = @"video_codec";
static const NSString * METADATA_KEY_VIDEO_ROTATION = @"rotate";
static const NSString * METADATA_KEY_ICY_METADATA = @"icy_metadata";
static const NSString * METADATA_KEY_FRAMERATE = @"framerate";
static const NSString * METADATA_KEY_CHAPTER_START_TIME = @"chapter_start_time";
static const NSString * METADATA_KEY_CHAPTER_END_TIME = @"chapter_end_time";

@interface FFmpegMediaMetadataRetriever : NSObject

- (NSInteger)setDataSourceFromPath:(const NSString *)path;
- (NSInteger)setDataSourceFromUri:(const NSString *)uri header:(const NSString *)headers;
- (NSInteger)setDataSourceFromFDWithOffset:(NSInteger)fd offset:(int64_t)offset length:(int64_t)length;
- (NSInteger)setDataSourceFromFD:(NSInteger)fd;
- (const NSString *)extractMetadata:(const NSString*)key;
- (const NSString *)extractMetadataFromChapter:(const NSString*)key chapter:(NSInteger)chapter;
- (UIImage *)getFrameAtTimeWithOptions:(int64_t)timeUs option:(NSInteger)option;
- (UIImage *)getFrameAtTime:(int64_t)timeUs;
- (UIImage *)getFrame;
- (UIImage *)getEmbeddedPicture;
+ (void)release;

@end
