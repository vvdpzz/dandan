//
//  SQLLiteController.m
//  dandan
//
//  Created by xiaodong xue on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SQLLiteController.h"

@implementation SQLLiteController
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
@end
