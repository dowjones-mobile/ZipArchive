//
//  ZipArchive_iOSTests.m
//  ZipArchive-iOSTests
//
//  Created by PattersonJ on 2/10/16.
//  Copyright © 2016 smumryak. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SSZipArchive.h"

@interface ZipArchive_iOSTests : XCTestCase
@property (nonatomic, copy) NSString *zipFileName;
@end

@implementation ZipArchive_iOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _zipFileName = [[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:@".zip"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWriteAndRead {
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:_zipFileName];
    SSZipArchive *archive = [[SSZipArchive alloc] initWithPath:zipPath];
    [archive open];
    XCTAssert([archive isOpened], @"Could not open a zip file for writing");
    
    NSData *inputData = [_zipFileName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filenameInZip = @"data.txt";
    
    BOOL written = [archive writeData:inputData filename:filenameInZip withPassword:nil];
    XCTAssert(written, @"Could not write data");
    
    [archive close];
    XCTAssert([archive isClosed], @"Could not close a zip");
}


@end
