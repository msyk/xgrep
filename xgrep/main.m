//
//  main.m
//  xgrep
//
//  Created by Masayuki Nii on 2013/03/03.
//  Copyright (c) 2013年 msyk.net. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        NSError *error;
        NSStringEncoding usedEnc;
        
        //        NSLog( @"argc=%d", argc);
        
        NSString *argv1 = [[NSString alloc] initWithBytes: argv[1]
                                                   length: strlen(argv[1])
                                                 encoding: NSUTF8StringEncoding];
        
        if ([argv1 isEqualToString: @"-f"] && argc >= 4) {   // sed file
            NSString *sedFile = [[NSString alloc] initWithBytes: argv[2]
                                                         length: strlen(argv[2])
                                                       encoding: NSUTF8StringEncoding];
            NSString *targetFile = [[NSString alloc] initWithBytes: argv[3]
                                                            length: strlen(argv[3])
                                                          encoding: NSUTF8StringEncoding];
            NSMutableString *targetFileContent = [NSMutableString stringWithString:
                                                  [NSString stringWithContentsOfFile: targetFile
                                                                        usedEncoding: &usedEnc
                                                                               error: &error]];
            NSString *sedFileContent = [NSString stringWithContentsOfFile: sedFile
                                                             usedEncoding: &usedEnc
                                                                    error: &error];
            [[sedFileContent componentsSeparatedByString: @"\n"] enumerateObjectsUsingBlock: ^(NSString *aLine, NSUInteger idx, BOOL *stop){
                if ( [aLine hasPrefix: @"s"])    {
                    NSRegularExpression *regex;
                    NSError *error;
                    NSString *separator = [aLine substringWithRange: NSMakeRange( 1, 1)];
                    NSCharacterSet *sepSet = [NSCharacterSet characterSetWithCharactersInString: separator];
                    NSArray *replacePattern = [aLine componentsSeparatedByCharactersInSet: sepSet];
                    if ( replacePattern.count < 3)  {
                        NSLog( @"substitute command error: %@", aLine);
                    } else {
                        regex = [NSRegularExpression regularExpressionWithPattern: replacePattern[1]
                                                                          options: 0
                                                                            error: &error];
                        if ( error != nil ) {
                            NSLog( @"regular exp error: %@ %@", replacePattern[1], error.description);
                        }
                        NSInteger count = [regex replaceMatchesInString: targetFileContent
                                                                options: 0
                                                                  range: NSMakeRange(0, targetFileContent.length)
                                                           withTemplate: replacePattern[2]];
                        //                        NSLog( @"count=%ld pattern=%@",count, replacePattern[1]);
                    }
                }
            }];
            printf( "%s", [targetFileContent UTF8String] );
            
            
        } else {
            NSString *pattern = [[NSString alloc] initWithBytes: argv[1]
                                                         length: strlen(argv[1])
                                                       encoding: NSUTF8StringEncoding];
            NSString *targetFile = [[NSString alloc] initWithBytes: argv[2]
                                                            length: strlen(argv[2])
                                                          encoding: NSUTF8StringEncoding];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern
                                                                                   options: 0
                                                                                     error: &error];
            
            NSString *fileContent = [NSString stringWithContentsOfFile: targetFile
                                                          usedEncoding: &usedEnc
                                                                 error: &error];
            
            [[fileContent componentsSeparatedByString: @"\n"] enumerateObjectsUsingBlock: ^(NSString *aLine, NSUInteger idx, BOOL *stop){
                if ( [regex numberOfMatchesInString: aLine
                                            options: 0
                                              range: NSMakeRange(0, aLine.length)] > 0 )   {
                    NSLog( @"%@", aLine );
                };
            }];
        }
    }
    return 0;
}

