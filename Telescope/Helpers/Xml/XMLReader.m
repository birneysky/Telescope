//
//  XMLReader.m
//

#import "XMLReader.h"

NSString *const kXMLReaderTextNodeKey = @"text";

@interface XMLReader (Internal)

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end


@implementation XMLReader
{
    NSString* _keepOrderElementName;
}

#pragma mark -
#pragma mark Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    XMLReader *reader = [[XMLReader alloc] initWithError:error];
    NSDictionary *rootDictionary = [reader objectWithData:data];
    
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLReader dictionaryForXMLData:data error:error];
}

+ (NSDictionary*)dictionaryForXMLString:(NSString *)string keepOrderElement:(NSString*)name error:(NSError **)error
{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    XMLReader *reader = [[XMLReader alloc] initWithError:error];
    reader->_keepOrderElementName = name;
    NSDictionary *rootDictionary = [reader objectWithData:data];
    return rootDictionary;
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

- (NSDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data

    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    _teDictionary  = [[NSMutableDictionary alloc] init];
    _elementStack = [[NSMutableArray alloc] init];
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
        
        return _teDictionary;
    }
   
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];

    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];

            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
   
    // Update the stack
    [dictionaryStack addObject:childDict];
    
    
    NSMutableDictionary *techildDict = [NSMutableDictionary dictionary];
    [techildDict addEntriesFromDictionary:attributeDict];
    
    //NSString* parentElementName = [_elementStack lastObject];
    id existObject = _teDictionary.count == 0 ? [_teDictionary objectForKey:elementName] : _elementStack.lastObject;
    if (existObject) {
        //NSMutableDictionary* parentDic = _teDictionary[[dictionaryStack lastObject]];
        id subObject = [_keepOrderElementName isEqualToString:elementName]? [[NSMutableArray alloc] init] : [[NSMutableDictionary alloc] init];
        if (techildDict.count > 0) {
            [subObject setObject:techildDict forKey:elementName];
        }
        
        if ([existObject isKindOfClass:[NSMutableDictionary class]]) {
            [existObject setObject:subObject forKey:elementName];
        }
        
        if ([existObject isKindOfClass:[NSMutableArray class]]) {
            [existObject addObject:subObject];
        }
        
        [_elementStack addObject:subObject];
    }
    else{
        [_teDictionary setObject:techildDict forKey:elementName];
        [_elementStack addObject:techildDict];
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
