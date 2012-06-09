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

- (NSString *) getDBPath;
- (NSInteger)CreateNewList:(sqlite3 *)db listTitle:(NSString *)listTitle categoryID:(NSInteger *)categoryID isShare:(BOOL)isShare;
- (NSArray *)getCategoryList;
- (NSArray *)getList;
- (NSInteger)insertNewTodoIntoDatabase;

@end
