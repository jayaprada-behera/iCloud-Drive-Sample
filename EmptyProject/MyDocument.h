//
//  MyDocument.h
//  EmptyProject
//
//  Created by jayaprada on 15/04/16.
//  Copyright © 2016 jayaprada. All rights reserved.
//
/*
 
 My Document is requiered because when you upload this item to any app
 */
#import <UIKit/UIKit.h>
#import "DocModel.h"
#define kArchiveKey @"Bookmark"

@interface MyDocument : UIDocument
@property(nonatomic,strong)DocModel *docModelObj;
@end
