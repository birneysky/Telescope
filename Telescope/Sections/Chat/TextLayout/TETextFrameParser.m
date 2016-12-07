//
//  TextFrameParser.m
//  Telescope
//
//  Created by zhangguang on 16/12/7.
//  Copyright © 2016年 com.v2tech.Telescope. All rights reserved.
//

#import "TETextFrameParser.h"
#import "TETextAttibuteConfig.h"
#import <CoreText/CoreText.h>

@interface TETextFrameParser ()


@end

static TETextAttibuteConfig* _config;

@implementation TETextFrameParser

#pragma mark - *** Properties ***
+ (TETextAttibuteConfig*)config
{
    if (!_config) {
        _config  = [[TETextAttibuteConfig alloc] init];
    }
    return _config;
}

#pragma mark - *** Api ***

+ (TETextLayoutModel *)parseChatMessage:(TEChatMessage *)message
{
    TETextLayoutModel* model = [self parseChatMessage:message config:[TETextFrameParser config]];
    
    return model;
}

+ (TETextLayoutModel *)parseChatMessage:(TEChatMessage *)message config:(TETextAttibuteConfig*)config
{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadChatMessage:message config:config imageArray:imageArray linkArray:linkArray];
    TETextLayoutModel *model = [self parseAttributedContent:content config:config];
    model.imageArray = imageArray;
    model.linkArray = linkArray;
    return model;
}

#pragma mark  ***CTRunDelegateCallbacks ***
static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

#pragma mark - *** Helper ***

+ (NSMutableDictionary *)attributesWithConfig:(TETextAttibuteConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(TETextAttibuteConfig*)config {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (NSAttributedString *)parseAttributedContentFromNSString:(NSString*)content
                                                        config:(TETextAttibuteConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    attributes[(id)kCTForegroundColorAttributeName] = (id)config.textColor.CGColor;
    
    // set font size
    CGFloat fontSize = config.fontSize;
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}


+ (NSAttributedString *)loadChatMessage:(TEChatMessage*)message
                                  config:(TETextAttibuteConfig*)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray {
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    
    NSArray<TEMsgSubItem*>* messageItems = message.msgItemList;
    [messageItems enumerateObjectsUsingBlock:^(TEMsgSubItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (item.type) {
            case Text:
            {
                TEMsgTextSubItem* textItem = (TEMsgTextSubItem*)item;
                NSAttributedString *as = [self parseAttributedContentFromNSString:textItem.textContent
                                                                               config:config];
                [result appendAttributedString:as];
            }
                break;
            case Link:
            {
                TEMsgLinkSubItem* linkItem = (TEMsgLinkSubItem*)item;
                NSAttributedString *as = [self parseAttributedContentFromNSString:linkItem.url
                                                                           config:config];
                [result appendAttributedString:as];
            }
                break;
            case Image:
            {
                 TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)item;
                NSAttributedString *as =  [self parseImageDataFromNSDictionary:@{@"Width":@(imageItem.imagePosition.size.width),@"height":@(imageItem.imagePosition.size.height)}
                                                                        config:config];
                [result appendAttributedString:as];
            }
                break;
            case Face:
            {
//                TEMsgImageSubItem* imageItem = (TEMsgImageSubItem*)item;
//                NSAttributedString *as =  [self parseImageDataFromNSDictionary:@{@"Width":@(44),@"height":@(44)} config:config];
//                [result appendAttributedString:as];
            }
                break;
            default:
                break;
        }
        
        
    }];
    
//    if (data) {
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data
//                                                         options:NSJSONReadingAllowFragments
//                                                           error:nil];
//        if ([array isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dict in array) {
//                NSString *type = dict[@"type"];
//                if ([type isEqualToString:@"txt"]) {
//                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict
//                                                                                   config:config];
//                    [result appendAttributedString:as];
//                } else if ([type isEqualToString:@"img"]) {
//                    // 创建 CoreTextImageData
//                    CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
//                    imageData.name = dict[@"name"];
//                    imageData.position = [result length];
//                    [imageArray addObject:imageData];
//                    // 创建空白占位符，并且设置它的CTRunDelegate信息
//                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
//                    [result appendAttributedString:as];
//                } else if ([type isEqualToString:@"link"]) {
//                    NSUInteger startPos = result.length;
//                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict
//                                                                                   config:config];
//                    [result appendAttributedString:as];
//                    // 创建 CoreTextLinkData
//                    NSUInteger length = result.length - startPos;
//                    NSRange linkRange = NSMakeRange(startPos, length);
//                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
//                    linkData.title = dict[@"content"];
//                    linkData.url = dict[@"url"];
//                    linkData.range = linkRange;
//                    [linkArray addObject:linkData];
//                }
//            }
//        }
//    }
    return result;
}


+ (TETextLayoutModel *)parseAttributedContent:(NSAttributedString *)content config:(TETextAttibuteConfig*)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到TETextLayoutModel实例中，最后返回TETextLayoutModel实例
    TETextLayoutModel *data = [[TETextLayoutModel alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(TETextAttibuteConfig *)config
                                  height:(CGFloat)height {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}



@end
