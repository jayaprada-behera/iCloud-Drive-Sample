//
//  DocModel.h
//  EmptyProject
//
//  Created by jayaprada on 15/04/16.
//  Copyright © 2016 jayaprada. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kBookmarkName   @"Bookmark Name"
#define kBookmarkURL    @"Bookmark URL"
@interface DocModel : NSObject
@property(nonatomic,strong)NSString *docURl;
@property(nonatomic,strong)NSString *docName;
-(id)initWithName:(NSString *)name andURl:(NSString *)urlString;
@end
