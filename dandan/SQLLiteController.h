//
//  SQLLiteController.h
//  dandan
//
//  Created by xiaodong xue on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#define SQLiteFilename    @"dan.sqlite"

@interface SQLLiteController : NSObject{
    sqlite3 *database;
    NSString *databasePath;
}
@property (strong, nonatomic) NSMutableArray *listArray;
@end
