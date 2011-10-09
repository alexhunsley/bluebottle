//
//  MethodsDAO.h
//  BlueBottle
//
//  Created by alex hunsley on 09/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<sqlite3.h>


@interface MethodsDAO : NSObject {
    NSString *filename;
    bool open;
    sqlite3* db;
}

- (id)initWithFilename:(NSString *)filenameIn;
- (NSArray *)getAllMethods;

@end
