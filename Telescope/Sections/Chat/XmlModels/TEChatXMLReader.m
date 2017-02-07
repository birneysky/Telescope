//
//  XMLReader.m
//

#import "TEChatXMLReader.h"
#import "UIImage+Utils.h"
#import "TEV2KitChatDemon.h"

@interface TEChatXMLReader (Internal)

- (id)initWithError:(NSError **)error;
- (TEChatMessage *)objectWithData:(NSData *)data;

@end


@implementation TEChatXMLReader
{
    __autoreleasing  NSError **errorPointer;
    NSMutableDictionary* _teDictionary;
    NSMutableArray* _elementStack;
    TEChatMessage* _chatMessage;
}

#pragma mark Public methods

+ (TEChatMessage*)messageForXmlString:(NSString*)string error:(NSError**) error;
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    TEChatXMLReader *reader = [[TEChatXMLReader alloc] initWithError:error];
    
    return [reader objectWithData:data];
}

#pragma mark Parsing

- (id)initWithError:(NSError **)error
{
    if (self = [super init])
    {
        errorPointer = error;
    }
    return self;
}

- (TEChatMessage *)objectWithData:(NSData *)data
{
    // Clear out any old data
    
    _teDictionary  =  [[NSMutableDictionary alloc] init];
    _elementStack =  [[NSMutableArray alloc] init];
    _chatMessage = [[TEChatMessage alloc] init];
    
    // Initialize the stack with a fresh dictionary
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    
    // Return the stack's root dictionary on success
    if (success)
    {
        return _chatMessage;
    }
   
    return nil;
}

#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:TEChatElement]) {
        _chatMessage.isAutoReply = [attributeDict[TEAutoRelyAttribute] boolValue];
        _chatMessage.messageID = attributeDict[TEMessageIDAttribute];
    }
    else if([elementName isEqualToString:TETextElement] && attributeDict.count > 0){
        TEMsgTextSubItem* textSubItem = [[TEMsgTextSubItem alloc] initWithType:Text];
        textSubItem.textContent = attributeDict[TETextAttribute];
        [_chatMessage addItem:textSubItem];
    }
    else if ([elementName isEqualToString:TELinkElement]){
        TEMsgLinkSubItem* linkSubItem = [[TEMsgLinkSubItem alloc] initWithType:Link];
        linkSubItem.url = attributeDict[TEURLAttribute];
        linkSubItem.title = attributeDict[TEURLAttribute];
        [_chatMessage addItem:linkSubItem];
    }
    else if ([elementName isEqualToString:TEPictureElement]){
        TEMsgImageSubItem* pictureSubItem = [[TEMsgImageSubItem alloc] initWithType:Image];
        //NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TEImages"];
        NSString* filePath = [TEV2KitChatDemon defaultDemon].pictureStorePath;
        //NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",attributeDict[TEUUIDAttribute],@"thumbnail"];
        NSString* fileName = attributeDict[TEUUIDAttribute];//[NSString stringWithFormat:@"%@.jpg",attributeDict[TEUUIDAttribute]];
        //NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
        pictureSubItem.path = filePath;
        pictureSubItem.fileName = fileName;//attributeDict[TEUUIDAttribute];
        pictureSubItem.fileExt = attributeDict[TEFileExtAttribute];
        CGFloat width = [attributeDict[TEWidhtAttribute] floatValue];
        CGFloat height = [attributeDict[TEHeightAttribute] floatValue];
        aspectSizeInContainer(&width, &height, CGSizeMake(40, 40), CGSizeMake(200, 200));
        pictureSubItem.frame = CGRectMake(0, 0, width, height);
        [_chatMessage addItem:pictureSubItem];
        _chatMessage.type = TEChatMessageTypeImage;
    }
    else if([elementName isEqualToString:TESysFaceElement]){
        TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
        NSString* itemName = [NSString stringWithFormat:@"Expression_%@",attributeDict[TEFileNameAttribute]];
        //NSString* imageName = [path stringByAppendingPathComponent:itemName];
        faceItem.path = path;
        faceItem.fileName = itemName;
        faceItem.frame = CGRectMake(0, 0, 24, 20);
        [_chatMessage addItem:faceItem];
    }
    else if([elementName isEqualToString:TEAudioElement]){
        TEMSgAudioSubItem* audioItem = [[TEMSgAudioSubItem alloc] initWithType:Audio];
        audioItem.path = [TEV2KitChatDemon defaultDemon].audioStorePath;
        audioItem.fileName = attributeDict[TEFileIDAttribute];
        audioItem.fileExt = attributeDict[TEFileExtAttribute];
        audioItem.duration = [attributeDict[TESecondsAttribute] integerValue];
        audioItem.frame = CGRectMake(0, 0, 100, 44);
        [_chatMessage addItem:audioItem];
        _chatMessage.type = TEChatMessageTypeAudio;
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [_elementStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    *errorPointer = parseError;
}

@end
