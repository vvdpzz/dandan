//
//  SQLLiteController.m
//  dandan
//
//  Created by xiaodong xue on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SQLLiteController.h"
#import "DataSyncController.h"

@implementation SQLLiteController
@synthesize listArray;

static sqlite3_stmt *statementChk = nil;
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *selectstmt = nil;

-(void)createEditableCopyofDatabaseIfNeeded{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    databasePath = [documentsDirectory stringByAppendingPathComponent:SQLiteFilename];
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
	if(success) return;
    //    NSString * sQLiteFilename = [AppDelegate sharedInstance];
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLiteFilename];
    NSError *error;
	success = [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)initializeDatabase{    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSArray *tableArray = [NSArray arrayWithObjects:@"List", @"Categorie", nil];
        for ( NSString *table in tableArray ){
            NSLog( @"table name:%@", table);
            SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"syncWith%@:", table]);
            //NSLog( @"customSelector:%@", customSelector);
            SEL syncToLiteSel = NSSelectorFromString([NSString stringWithFormat:@"sync%@", table]);
            //NSLog( @"syncToLiteSel:%@", syncToLiteSel);
            NSString *sql_str = [NSString stringWithFormat:@"SELECT id FROM %@s ORDER BY id DESC LIMIT 1", table];
            const char *sql = (char *)[sql_str UTF8String];
            NSLog( @"SQL :%@", sql_str);
            sqlite3_stmt *statement;
            DataSyncController * sync = [DataSyncController alloc];
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    int primaryKey = sqlite3_column_int(statement, 0);
                    NSLog(@"primaryKey：%i",primaryKey);
                    if ([[DataSyncController alloc] respondsToSelector:customSelector]) {
                        sync = [[DataSyncController alloc] performSelector:customSelector withObject:[NSNumber numberWithInt:primaryKey]];
                        listArray = [sync copy];
                        if ([self respondsToSelector:syncToLiteSel]) 
                        {
                            [self performSelector:syncToLiteSel];
                        } else {
                            NSLog(@"## Class does not respond to %s", sel_getName(syncToLiteSel));
                        }
                    } else {
                        NSLog(@"## Class does not respond to %s", sel_getName(customSelector));
                    }
                } else {
                    if ([[DataSyncController alloc] respondsToSelector:customSelector]) {
                        sync = [[DataSyncController alloc] performSelector:customSelector withObject:0];
                        listArray = [sync copy];
                        if ([self respondsToSelector:syncToLiteSel]) 
                        {
                            [self performSelector:syncToLiteSel];
                        } else {
                            NSLog(@"## Class does not respond to %s", sel_getName(syncToLiteSel));
                        }
                    } else {
                        NSLog(@"## Class does not respond to %s", sel_getName(customSelector));
                    }
                }
            }
            sqlite3_finalize(statement);
            //NSLog(@"listArray包含：%@",listArray);
            NSLog(@"The content of arry is %i",[listArray count]); 
        }
    }else{
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
}

-(void)syncList{
    NSDictionary *listDict;
    char *errorMsg; 
    NSNumber *listID;
    NSString *listTitle;
    NSNumber *categoryID;
    
    for(int i = 0; i < [listArray count]; i++){		
		listDict = [listArray objectAtIndex:i];
        for (id key in listDict) {
            NSLog(@"key:%@, value:%@",key,[listDict objectForKey:key]);
        }
        listID = [listDict objectForKey:@"id"];
        listTitle = [listDict objectForKey:@"title"];
        categoryID = [listDict objectForKey:@"category_id"];
        NSString *insertSQL = [NSString stringWithFormat: @"insert into lists (id,title,category_id) values(\"%@\", \"%@\", \"%@\")", listID, listTitle,categoryID];
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        if (sqlite3_exec(database, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) { 
            NSLog(@"insert ok.");
        }
	}	
}

-(void)syncCategorie{
    NSDictionary *categoryDict;
    char *errorMsg; 
    NSInteger categoryID;
    NSString *categoryName;
    
    for(int i = 0; i < [listArray count]; i++){		
		categoryDict = [listArray objectAtIndex:i];
        for (id key in categoryDict) {
            NSLog(@"key:%@, value:%@",key,[categoryDict objectForKey:key]);
        }
        categoryID = [categoryDict objectForKey:@"id"];
        categoryName = [categoryDict objectForKey:@"name"];
        NSString *insertSQL = [NSString stringWithFormat: @"insert into categories (id,name) values(\"%@\", \"%@\")", categoryID, categoryName];
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        if (sqlite3_exec(database, insert_stmt, NULL, NULL, &errorMsg)==SQLITE_OK) { 
            NSLog(@"insert ok.");
        }
	}	
}

//获取数据库路径
- (NSString *) getDBPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"dan.sqlite"];
}

//建立新列表list
- (NSInteger)CreateNewList:(sqlite3 *)db listTitle:(NSString *)listTitle categoryID:(NSInteger *)categoryID isShare:(BOOL)isShare{
    if (sqlite3_open([self.getDBPath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"path:%@",self.getDBPath);
        
        if (insert_statement == nil) {
            //        int category_ID = [categoryID intValue];
            int share = (isShare==true)? 1:0;
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO `lists` (`title`, `category_id`, `isShare`) VALUES (\"%@\", \"%i\", \"%i\")", listTitle,categoryID,share];
            const char *sql = [insertSQL UTF8String];
            NSLog(@"Insert SQL: %s",sql);
            if (sqlite3_prepare_v2(db, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
            }
        }
        int success = sqlite3_step(insert_statement);
        
        sqlite3_reset(insert_statement);
        if (success != SQLITE_ERROR) {
            return sqlite3_last_insert_rowid(db);
        }
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(db));
        return -1;
    }
}

//获取Category列表
- (NSArray *)getCategoryList
{
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT name FROM categories";
        NSMutableArray *categroyNameArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(selectstmt) == SQLITE_ROW) {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                [categroyNameArray addObject:name];
                
                
            }
            return categroyNameArray;
        }
        sqlite3_finalize(selectstmt);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}


//获取Category列表
- (NSArray *)getList
{
    if (sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT title FROM lists";
        NSMutableArray *categroyNameArray = [[NSMutableArray alloc] init];
        if (sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(selectstmt) == SQLITE_ROW) {
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
                [categroyNameArray addObject:name];
                
                
            }
            return categroyNameArray;
        }
        sqlite3_finalize(selectstmt);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}

//调试用 Debug Only!
-(void)mungeFirst:(NSString**)stringOne andSecond:(NSString**)stringTwo
{
    *stringOne = [NSString stringWithString:@"foo"];
    *stringTwo = [NSString stringWithString:@"baz"];
}
@end
