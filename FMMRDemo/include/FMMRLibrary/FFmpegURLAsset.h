//
//  FFmpegURLAsset.h
//  FFmpegMediaMetadataRetriever
//
//  Created by William Seemann on 12/4/14.
//  Copyright (c) 2014 William Seemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import AVFoundation;

@interface FFmpegURLAsset : AVURLAsset

- (NSArray *)metadataForFormat:(NSString *)format;

@end
