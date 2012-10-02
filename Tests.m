#import <SenTestingKit/SenTestingKit.h>

@interface localizedbugTests : SenTestCase
@end

@implementation localizedbugTests

+ (void) setUp
{
    // This test only makes sense in a non-English language.
    // Please set both your machine and iOS simulator primary language to french.
    NSLog(@"languages : %@",[NSLocale preferredLanguages]);
    NSAssert([[NSLocale preferredLanguages][0] hasPrefix:@"fr"], @"YOU NEED TO SET YOUR PREFERRED LANGUAGE TO FRENCH FOR THIS TEST.");
}

- (void) test_1_InMainBundle
{
    // Look in the *main bundle*
    //
    // In AppTests, this will work, because the main bundle is AppTestsHost, which does have the resource
    //
    // In UnitTests, this will fail, because the main bundle it the ocunit test tool. This is expected.
    NSBundle * mainBundle = [NSBundle mainBundle];

    NSString * localizedPathInMainBundle = [mainBundle pathForResource:@"Localized" ofType:@"txt"];
    STAssertEqualObjects([[localizedPathInMainBundle stringByDeletingLastPathComponent] lastPathComponent],
                         @"fr.lproj",
                         @"This is expected for UnitTests.");

    NSString * localizedText = [NSString stringWithContentsOfFile:localizedPathInMainBundle encoding:NSUTF8StringEncoding error:NULL];
    STAssertEqualObjects(localizedText,
                         @"Français",
                         @"This is expected for UnitTests.");
}


- (void) test_2_InCurrentbundle
{
    // Look in the *.octest bundle* 
    //
    // In AppTests, this will work, because AppTests.octest does have the localized resource.
    //
    // In UnitTests, this will fail, althouth UnitTests.octest does have the localized resource.
    // In UnitTests, NSBundle actually falls back to en.lproj, even if the primary language is french. (see +setUp)
    NSBundle * testBundle = [NSBundle bundleForClass:[self class]];

    NSString * localizedPathInTestBundle = [testBundle pathForResource:@"Localized" ofType:@"txt"];
    STAssertEqualObjects([[localizedPathInTestBundle stringByDeletingLastPathComponent] lastPathComponent],
                         @"fr.lproj",
                         nil);

    NSString * localizedText = [NSString stringWithContentsOfFile:localizedPathInTestBundle encoding:NSUTF8StringEncoding error:NULL];
    STAssertEqualObjects(localizedText,
                         @"Français",
                         nil);
}

@end
