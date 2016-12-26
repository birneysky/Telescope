//
//  XMLReader.m
//

#import "TEChatXMLReader.h"
#import "TESizeAspect.h"
#import "TEV2KitChatDemon.h"

NSString *const kXMLReaderTextNodeKey = @"text";




@interface TEChatXMLReader (Internal)

- (id)initWithError:(NSError **)error;
- (TEChatMessage *)objectWithData:(NSData *)data;

@end


@implementation TEChatXMLReader
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    __autoreleasing  NSError **errorPointer;
    
    NSMutableDictionary* _teDictionary;
    NSMutableArray* _elementStack;
    //NSMutableArray* _messageSubItems;
    TEChatMessage* _chatMessage;
}

#pragma mark -
#pragma mark Public methods

//+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
//{
//    TEChatXMLReader *reader = [[TEChatXMLReader alloc] initWithError:error];
//    NSDictionary *rootDictionary = [reader objectWithData:data];
//    
//    return rootDictionary;
//}
//
//+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error
//{
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    return [TEChatXMLReader dictionaryForXMLData:data error:error];
//}

//+ (NSDictionary*)dictionaryForXMLString:(NSString *)string keepOrderElement:(NSString*)name error:(NSError **)error
//{
//    
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    //TEChatXMLReader *reader = [[XMLReader alloc] initWithError:error];
//    //TEChatXMLReader->_keepOrderElementName = name;
//    //NSDictionary *rootDictionary = [reader objectWithData:data];
//    return rootDictionary;
//}

+ (TEChatMessage*)messageForXmlString:(NSString*)string error:(NSError**) error;
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    TEChatXMLReader *reader = [[TEChatXMLReader alloc] initWithError:error];
    
    return [reader objectWithData:data];
}

#pragma mark -
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

    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    _teDictionary  =  [[NSMutableDictionary alloc] init];
    _elementStack =  [[NSMutableArray alloc] init];
    //_messageSubItems = [[NSMutableArray alloc] init];
    _chatMessage = [[TEChatMessage alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    
    // Return the stack's root dictionary on success
    if (success)
    {
        //NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return _chatMessage;
    }
   
    return nil;
}




#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    
//    NSMutableDictionary *techildDict = [NSMutableDictionary dictionary];
//    [techildDict addEntriesFromDictionary:attributeDict];
    
    //NSString* parentElementName = [_elementStack lastObject];
//    id existObject = _teDictionary.count == 0 ? [_teDictionary objectForKey:elementName] : _elementStack.lastObject;
//    if (existObject) {
//        //NSMutableDictionary* parentDic = _teDictionary[[dictionaryStack lastObject]];
//        id subObject = [_keepOrderElementName isEqualToString:elementName]? [[NSMutableArray alloc] init] : [[NSMutableDictionary alloc] init];
//        if (techildDict.count > 0) {
//            [subObject setObject:techildDict forKey:elementName];
//        }
//        
//        if ([existObject isKindOfClass:[NSMutableDictionary class]]) {
//            [existObject setObject:subObject forKey:elementName];
//        }
//        
//        if ([existObject isKindOfClass:[NSMutableArray class]]) {
//            [existObject addObject:subObject];
//        }
//        
//        [_elementStack addObject:subObject];
//    }
//    else{
//        [_teDictionary setObject:techildDict forKey:elementName];
//        [_elementStack addObject:techildDict];
//    }
    
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
        NSString* fileThumbnailName = [NSString stringWithFormat:@"%@_%@.jpg",attributeDict[TEUUIDAttribute],@"thumbnail"];
        NSString* thumbnailImgPath = [filePath stringByAppendingPathComponent:fileThumbnailName];
        pictureSubItem.fileName = thumbnailImgPath;//attributeDict[TEUUIDAttribute];
        pictureSubItem.fileExt = attributeDict[TEFileExtAttribute];
        CGFloat width = [attributeDict[TEWidhtAttribute] floatValue];
        CGFloat height = [attributeDict[TEHeightAttribute] floatValue];
        aspectSizeInContainer(&width, &height, CGSizeMake(40, 40), CGSizeMake(200, 200));
        pictureSubItem.imagePosition = CGRectMake(0, 0, width, height);
        [_chatMessage addItem:pictureSubItem];
    }
    else if([elementName isEqualToString:TESysFaceElement]){
        TEExpresssionSubItem* faceItem = [[TEExpresssionSubItem alloc] initWithType:Face];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"TEExpression" ofType:@"bundle"];
        NSString* itemName = [NSString stringWithFormat:@"Expression_%@",attributeDict[TEFileNameAttribute]];
        NSString* imageName = [path stringByAppendingPathComponent:itemName];
        faceItem.fileName = imageName;
        faceItem.imagePosition = CGRectMake(0, 0, 20, 20);
        [_chatMessage addItem:faceItem];
    }
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        [dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];

        // Reset the text
        
        textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
    [_elementStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    *errorPointer = parseError;
}

@end
