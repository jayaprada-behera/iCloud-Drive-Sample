//
//  DocModel.m
//  EmptyProject
//
//  Created by jayaprada on 15/04/16.
//  Copyright © 2016 jayaprada. All rights reserved.
//

#import "DocModel.h"

@implementation DocModel
-(id)initWithName:(NSString *)name andURl:(NSString *)urlString{

    self = [super init];
    if (self) {
        self.docURl  = urlString;
        self.docName = name;
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding Protocol
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.docName forKey:kBookmarkName];
    [coder encodeObject:self.docURl forKey:kBookmarkURL];
}

- (id)initWithCoder:(NSCoder *)coder  {
    self = [super init];
    
    if (self != nil) {
        self.docName = [coder decodeObjectForKey:kBookmarkName];
        self.docURl = [coder decodeObjectForKey:kBookmarkURL];
    }
    
    return self;
}

@end
