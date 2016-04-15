//
//  MyDocument.m
//  EmptyProject
//
//  Created by jayaprada on 15/04/16.
//  Copyright © 2016 jayaprada. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{

    if ([contents length] == 0) {
        self.docModelObj = [[DocModel alloc]initWithName:@"my name" andURl:@"www.example.com"];
    }else{
    
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:contents];
        self.docModelObj = [unarchiver decodeObjectForKey:kArchiveKey];
        [unarchiver finishDecoding];
    }
    return YES;

}
-(id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.docModelObj forKey:kArchiveKey];
    [archiver finishEncoding];
    
    return data;

}
@end
