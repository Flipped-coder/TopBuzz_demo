//
//  TopBuzz_demoUITestsLaunchTests.m
//  TopBuzz_demoUITests
//
//  Created by 邓杰 on 2023/12/12.
//

#import <XCTest/XCTest.h>

@interface TopBuzz_demoUITestsLaunchTests : XCTestCase

@end

@implementation TopBuzz_demoUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
