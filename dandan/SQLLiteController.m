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
@end
