//
//  MethodsDAO.m
//  BlueBottle
//
//  Created by alex hunsley on 09/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MethodsDAO.h"
#import "Method.h"

@implementation MethodsDAO

- (id)initWithFilename:(NSString *)filenameIn {
    if ((self = [super init])) {
        filename = filenameIn;
        [filename retain];
        open = false;
    }
    return self;
}

- (bool)openDB {
    if (open) {
        return true;
    }
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:filename];
    if ([fileManager fileExistsAtPath:writableDBPath] == NO) {
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    ////
    
    int err = sqlite3_open([writableDBPath UTF8String], &db);
    
    if (err != SQLITE_OK) {
        return false;
    }
    
    char *szErrorMessage = 0;
    err = sqlite3_exec(db, 
                       "PRAGMA locking_mode = EXCLUSIVE; PRAGMA journal_mode = OFF;",
                       0, 
                       0, 
                       &szErrorMessage);
    
    if (err != SQLITE_OK) {
        fprintf(stderr, "Warning: Could not turn journalling off. Message : %s", szErrorMessage);
    }
    
    open = true;
    
    return open;
}

- (NSArray *)getAllMethods {
    [self openDB];
    
    int returnCode = 0;
	sqlite3_stmt* statement = NULL;
    
    char buffer[300];
    
    sprintf(buffer, "SELECT * from Methods");
    
    returnCode = sqlite3_prepare(db, buffer, -1, &statement, 0);
    
    if (SQLITE_OK != returnCode) {
        NSLog(@" SQLITE ERROR: %s", sqlite3_errmsg(db));
        sqlite3_finalize(statement);
        return nil;
    }
    
    NSMutableArray *methods = [NSMutableArray array];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *name = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
        int numBells = sqlite3_column_int(statement, 2);
        NSString *notation = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
        NSString *leadEnd = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
        
        Method *method = [[Method alloc] initWithTitle:name numBells:numBells
                                              notation:notation leadEnd:leadEnd];
        [methods addObject:method];
        [method retain];
        //[method release];
//        TagData data;
//        data.oid = sqlite3_column_int(statement, 0);
//        data.position.latitude = sqlite3_column_double(statement, 1);
//        data.position.longitude = sqlite3_column_double(statement, 2);
//        char* airportCharCode = (char *)sqlite3_column_text(statement, 3);
//        char* cityCharCode = (char *)sqlite3_column_value(statement, 4);
//        string str;
//        
//        if (airportCharCode) {
//            str = airportCharCode;
//        } else {
//            str = cityCharCode;
//        }
//        
//        //        data.id = str;
//        data.type = TTDestination;
//        //        cout << "code: " << data.id << " and oid: " << data.oid << ", lat/long: " << data.position.latitude << ", " << data.position.longitude << "\n";
//        
//        tagMap[data.oid] = data;
    }
    
    sqlite3_finalize(statement);

    return methods;
}

- (void)closeDB {
    if (open) {
        sqlite3_close(db);
        db = NULL;
        open = false;
    }
}

- (void)dealloc {
    [filename release];
    [self closeDB];
    [super dealloc];
}

@end
