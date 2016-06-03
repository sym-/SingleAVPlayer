//
//  YMVideoModel.h
//  SingleAVPlayer
//
//  Created by 宋元明 on 16/5/27.
//  Copyright © 2016年 宋元明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMVideoModel : NSObject

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *videosource;

@property (nonatomic, copy) NSString *topicImg;

@property (nonatomic, copy) NSString *topicSid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sectiontitle;

@property (nonatomic, copy) NSString *vid;

@property (nonatomic, copy) NSString *m3u8_url;

@property (nonatomic, assign) NSInteger playersize;

@property (nonatomic, copy) NSString *topicName;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *replyBoard;

@property (nonatomic, assign) NSInteger playCount;

@property (nonatomic, assign) NSInteger length;

@property (nonatomic, copy) NSString *topicDesc;

@property (nonatomic, copy) NSString *mp4Hd_url;

@property (nonatomic, copy) NSString *replyid;

@property (nonatomic, copy) NSString *m3u8Hd_url;

@property (nonatomic, copy) NSString *mp4_url;

@property (nonatomic, copy, readwrite) NSString *description;


-(void)autoParseDictionary:(NSDictionary *)dict;

@end



