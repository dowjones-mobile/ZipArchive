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
    _zipFileName = [[[NSUUID UUID] UUIDString] stringByAppendingPathExtension:@"zip"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSmallWriteAndRead {
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:_zipFileName];
    
    // Write to a temporary zip
    SSZipArchive *archive = [[SSZipArchive alloc] initWithPath:zipPath];
    [archive open];
    XCTAssert([archive isOpened], @"Could not open a zip file for writing");
    
    NSString *inputString = _zipFileName;
    NSData *inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filenameInZip = @"data.txt";
    
    BOOL written = [archive writeData:inputData filename:filenameInZip withPassword:nil];
    XCTAssert(written, @"Could not write data");
    
    [archive close];
    XCTAssert([archive isClosed], @"Could not close a zip");

    // Now read it
    NSMutableDictionary *contents = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    BOOL read = [SSZipArchive unzipFileAtPath:zipPath toDictionary:contents error:&error];
    XCTAssert(read, @"Could not read contents of zip");
    
    XCTAssertEqual([contents count], 1, @"Should be one item in the zip");
    NSData *outputData = [contents objectForKey:filenameInZip];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    XCTAssertNotNil(outputData, @"Could not find data in zip");
    XCTAssertEqualObjects(outputData, inputData, @"Data was not equal");
    XCTAssertEqualObjects(outputString, inputString, @"Data was not equal");
}


@end
