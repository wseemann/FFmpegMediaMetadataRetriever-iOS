//
//  ViewController.mm
//  FMMRDemo
//
//  Created by William Seemann on 12/4/14.
//  Copyright (c) 2014 William Seemann. All rights reserved.
//

/*
 * FFmpegMediaMetadataRetriever-iOS: Port of FFmpegMediaMetadataRetriever for
 * iOS. A unified interface for retrieving frame and meta data from an
 * input media file.
 *
 * Copyright 2014 William Seemann
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

#import "ViewController.h"

#import "FMMRLibrary/FFmpegMediaMetadataRetriever.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *uriText;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

FFmpegMediaMetadataRetriever *fmmr;
NSMutableArray *metadata;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    metadata = [NSMutableArray new];
    fmmr = [FFmpegMediaMetadataRetriever new];
    
    //AVAsset *m = [FFmpegURLAsset URLAssetWithURL:"" options:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)uriText:(UITextField *)sender {
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [metadata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *output;
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *pair = [metadata objectAtIndex:indexPath.row];
    
    for (id key in pair) {
        id value = [pair objectForKey:key];
        //v = (NSString *) value;
        output = [NSString stringWithFormat:@"%@ : %@", (NSString *) key, (NSString *) value];
    }
    
    cell.textLabel.text = output;
    return cell;
}

- (void) addMetadata:(const NSString *) key
{
    const NSString *value = [fmmr extractMetadata: key];
    
    if (value) {
        //NSString *k = [NSString stringWithUTF8String: key];
        //NSString *v = [NSString stringWithUTF8String: value];
        
        NSDictionary *pair = [NSDictionary dictionaryWithObject: value forKey: key];
        [metadata addObject: pair];
    }
}

- (IBAction)goButtonClicked:(id)sender {
    const char *uri = [[self.uriText text] UTF8String];
    
    NSInteger ret = [fmmr setDataSourceFromPath: [NSString stringWithUTF8String: uri]];
    
    if (ret == 0) {
        printf("Ret code: %d\n", (int) ret);
        //printf("Artist: %s\n", [fmmr extractMetadata("artist"));
        
        //AVPacket pkt;
        //mmr->extractAlbumArt(&pkt);
        
        UIImage *newImage = [fmmr getEmbeddedPicture];
        
        /*NSMutableData *newData = [NSMutableData new];
        [newData appendBytes:(const void *) pkt.data length: pkt.size];
        UIImage *newImage = [UIImage imageWithData: newData];*/
        
        if (newImage) {
            CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], CGRectMake(0, 0, 25, 25));
            //[self.image setImage:[UIImage imageWithCGImage:imageRef]];
            
            [self.image setImage: newImage];
            CGImageRelease(imageRef);
        }
        
        [self addMetadata: METADATA_KEY_ALBUM];
        [self addMetadata: METADATA_KEY_ALBUM_ARTIST];
        [self addMetadata: METADATA_KEY_ARTIST];
        [self addMetadata: METADATA_KEY_COMMENT];
        [self addMetadata: METADATA_KEY_COMPOSER];
        [self addMetadata: METADATA_KEY_COPYRIGHT];
        [self addMetadata: METADATA_KEY_CREATION_TIME];
        [self addMetadata: METADATA_KEY_DATE];
        [self addMetadata: METADATA_KEY_DISC];
        [self addMetadata: METADATA_KEY_ENCODER];
        [self addMetadata: METADATA_KEY_ENCODED_BY];
        [self addMetadata: METADATA_KEY_FILENAME];
        [self addMetadata: METADATA_KEY_GENRE];
        [self addMetadata: METADATA_KEY_LANGUAGE];
        [self addMetadata: METADATA_KEY_PERFORMER];
        [self addMetadata: METADATA_KEY_PUBLISHER];
        [self addMetadata: METADATA_KEY_SERVICE_NAME];
        [self addMetadata: METADATA_KEY_SERVICE_PROVIDER];
        [self addMetadata: METADATA_KEY_TITLE];
        [self addMetadata: METADATA_KEY_TRACK];
        [self addMetadata: METADATA_KEY_VARIANT_BITRATE];
        [self addMetadata: METADATA_KEY_DURATION];
        [self addMetadata: METADATA_KEY_AUDIO_CODEC];
        [self addMetadata: METADATA_KEY_VIDEO_CODEC];
        [self addMetadata: METADATA_KEY_VIDEO_ROTATION];
        [self addMetadata: METADATA_KEY_ICY_METADATA];
        [self addMetadata: METADATA_KEY_FRAMERATE];
        [self addMetadata: METADATA_KEY_CHAPTER_START_TIME];
        [self addMetadata: METADATA_KEY_CHAPTER_END_TIME];
    }
    
    [self.table reloadData];
}

@end
