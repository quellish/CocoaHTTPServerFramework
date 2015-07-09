//
//  CocoaHTTPServerFrameworkTests.m
//  CocoaHTTPServerFrameworkTests
//
//  Created by Dan Zinngrabe on 7/8/15.
//  Copyright (c) 2015 Dan Zinngrabe. All rights reserved.
//

#import <XCTest/XCTest.h>
@import CocoaHTTPServerKit;

@interface CocoaHTTPServerFrameworkTests : XCTestCase
@property   (nonatomic, readwrite, strong)  HTTPServer  *httpServer;
@end

@implementation CocoaHTTPServerFrameworkTests

- (void)setUp {
    NSError *error  = nil;

    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // Set up the internal HTTP server
    _httpServer = [[HTTPServer alloc] init];
    [[self httpServer] setType:@"_http._tcp."];
    
    // This can point to anything you want to use as the web root for these tests, as long as it exists in the test
    // Here it is the folder 'Web' inside the Supporting Files group - note that it has to be a "folder reference" to get
    // copied correctly during the "Copy resources" build phase.
    NSString *webPath = [[NSBundle bundleForClass:[self class]] resourcePath];
    
    [[self httpServer] setDocumentRoot:webPath];
    if([[self httpServer] start:&error]) {
        NSLog(@"Started HTTP Server on port %hu", [[self httpServer] listeningPort]);
    } else {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[self httpServer] stop];
    [super tearDown];
}

- (void) testCanAccessListeningPort {
    NSString            *urlString      = nil;
    NSURL               *url            = nil;
    NSData              *downloadResult = nil;
    
    urlString = [[NSString alloc] initWithFormat:@"http://127.0.0.1:%d/Info.plist", [[self httpServer] listeningPort] ];
    url = [NSURL URLWithString:urlString];
    
    downloadResult = [NSData dataWithContentsOfURL:url];
    
    XCTAssertNotNil(downloadResult, @"Did not get any data!");
}


@end
