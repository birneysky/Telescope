//
//  XMLReader.h
//
// THis class reads an XML document and produces a dictionary that represents that object.
//
//

#import <Foundation/Foundation.h>


@interface XMLReader : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    __autoreleasing  NSError **errorPointer;
    
    NSMutableDictionary* _teDictionary;
    NSMutableArray* _elementStack;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

/**
 解析一个xml至字典

 @param string xml字符串
 @param name 指定某个子元素解析后保持顺序，保持顺序的元素会被解析为数组
 @param error  error
 @return 成功返回字典
 */
+ (NSDictionary*)dictionaryForXMLString:(NSString *)string keepOrderElement:(NSString*)name error:(NSError **)error;

@end
