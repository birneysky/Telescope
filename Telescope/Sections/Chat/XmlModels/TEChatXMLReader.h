//
//  XMLReader.h
//
// THis class reads an XML document and produces a dictionary that represents that object.
//
//

#import <Foundation/Foundation.h>
#import "TEChatMessage.h"


/**
 聊天消息xml解析器
 
 忽略了字体列表，字体，字体颜色，字体大小等不适用与移动平台的属性
 只保留了ItemList元素
 */
@interface TEChatXMLReader : NSObject<NSXMLParserDelegate>


/**
 解析一个聊天的xml字符串至 TEChatMessage 实例

 @param string xml字符串
 @param error error
 @return 返回 TEChatMessage
 */
+ (TEChatMessage*)messageForXmlString:(NSString*)string error:(NSError**) error;



@end
